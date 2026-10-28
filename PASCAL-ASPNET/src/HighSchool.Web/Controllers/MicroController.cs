using System.Text.Json;
using HighSchool.Web.Data;
using HighSchool.Web.Modules.Micro;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HighSchool.Web.Controllers;

/// <summary>MICRO.COM – the 8085 trainer. The machine lives in the session; the page talks to it with JSON.</summary>
public class MicroController(AppDbContext db) : Controller
{
    private const string SessionKey = "micro";

    public sealed record CommandRequest(string Line);
    public sealed record RunRequest(int Ips = 10_000, int? Input = null);
    public sealed record OperateRequest(string Action);
    public sealed record ProgramRequest(string Name, string? From = null, string? To = null, string? At = null);

    public IActionResult Index() => View(Load());

    [HttpPost]
    public IActionResult Command([FromBody] CommandRequest request)
    {
        var m = Load();
        MicroMonitor.Execute(m, request.Line ?? "");
        return Save(m);
    }

    [HttpPost]
    public IActionResult Run([FromBody] RunRequest request)
    {
        var m = Load();
        if (m.Mode == RunMode.None) return Json(new { status = "idle", state = State(m) });
        var input = request.Input is { } v ? (byte?)Math.Clamp(v, 0, 255) : null;
        var batch = MicroRunner.Run(m, budgetMs: 400, request.Ips, input);
        Store(m);
        return Json(new { batch.Status, batch.DurationMs, batch.Events, batch.Message, batch.InputPort, state = State(m) });
    }

    [HttpPost]
    public IActionResult Break()
    {
        var m = Load();
        MicroRunner.Break(m);
        return Save(m);
    }

    /// <summary>F5 – Operate: beep on/off, clean ports, clear registers.</summary>
    [HttpPost]
    public IActionResult Operate([FromBody] OperateRequest request)
    {
        var m = Load();
        switch (request.Action)
        {
            case "beep": m.Beep = !m.Beep; break;
            case "ports": m.Panel.Clear(); break;
            case "registers": m.Cpu.Reset(); m.Mode = RunMode.None; break;
            case "memory": m.Cpu.Memory = new byte[0x10000]; break;
        }
        return Save(m);
    }

    // ---- F9 – Input/Output: the MCRNAME.DAT directory, now a table ----

    [HttpGet]
    public async Task<IActionResult> Programs() =>
        Json(await db.MicroPrograms.OrderBy(p => p.Name)
            .Select(p => new { p.Name, Start = p.StartAddress.ToString("X4"), Range = p.Code.Length.ToString("X4") })
            .ToListAsync());

    [HttpPost]
    public async Task<IActionResult> SaveProgram([FromBody] ProgramRequest request)
    {
        var m = Load();
        var name = (request.Name ?? "").Trim().ToUpperInvariant();
        var from = Assembler.ParseHex(request.From ?? "", 4);
        var to = Assembler.ParseHex(request.To ?? "", 4);
        if (name.Length is 0 or > 8 || from is null || to is null || to < from || from < MicroMonitor.MinAddress || to > MicroMonitor.MaxAddress)
            return BadRequest(new { error = "Name (1-8 chars) and a range inside 0100-7FFF are required" });

        var program = await db.MicroPrograms.SingleOrDefaultAsync(p => p.Name == name)
                      ?? db.MicroPrograms.Add(new MicroProgram { Name = name }).Entity;
        program.StartAddress = from.Value;
        program.Code = m.Cpu.Memory[from.Value..(to.Value + 1)];
        await db.SaveChangesAsync();

        m.Write(new ConsoleLine($"Saved {name} {from:X4}-{to:X4}", "", "info"));
        return Save(m);
    }

    [HttpPost]
    public async Task<IActionResult> LoadProgram([FromBody] ProgramRequest request)
    {
        var m = Load();
        var name = (request.Name ?? "").Trim().ToUpperInvariant();
        var program = await db.MicroPrograms.SingleOrDefaultAsync(p => p.Name == name);
        if (program is null) return NotFound(new { error = "File not found" });

        var at = string.IsNullOrWhiteSpace(request.At) ? program.StartAddress : Assembler.ParseHex(request.At, 4);
        if (at is null || at < MicroMonitor.MinAddress || at + program.Code.Length - 1 > 0xFFFF)
            return BadRequest(new { error = "Load address must be inside 0100-7FFF" });

        program.Code.CopyTo(m.Cpu.Memory, at.Value);
        m.Cpu.PC = (ushort)at.Value;
        m.Write(new ConsoleLine($"Loaded {name} at {at:X4} ({program.Code.Length:X4}h bytes)", $"G{at:X4} to run", "info"));
        m.Prompt = $"L{at:X4}-{Math.Min(at.Value + program.Code.Length - 1, MicroMonitor.MaxAddress):X4}";
        return Save(m);
    }

    [HttpPost]
    public async Task<IActionResult> EraseProgram([FromBody] ProgramRequest request)
    {
        var name = (request.Name ?? "").Trim().ToUpperInvariant();
        var deleted = await db.MicroPrograms.Where(p => p.Name == name).ExecuteDeleteAsync();
        return deleted == 0 ? NotFound(new { error = "File not found" }) : Ok(new { erased = name });
    }

    /// <summary>The P command – the original sent the listing to the printer (writeln(lst,…)).</summary>
    [HttpGet]
    public IActionResult Print(string range)
    {
        var m = Load();
        try
        {
            var (from, to) = MicroMonitor.ParseRange(range ?? "");
            ViewData["Range"] = $"{from:X4}-{to:X4}";
            return View(MicroMonitor.Listing(m.Cpu.Memory, from, to).ToList());
        }
        catch (MicroException ex)
        {
            return BadRequest(ex.Message);
        }
    }

    // ---- session plumbing ----

    private MicroMachine Load()
    {
        var json = HttpContext.Session.GetString(SessionKey);
        return json is null ? new MicroMachine() : JsonSerializer.Deserialize<MicroMachine>(json) ?? new MicroMachine();
    }

    private void Store(MicroMachine m) => HttpContext.Session.SetString(SessionKey, JsonSerializer.Serialize(m));

    private JsonResult Save(MicroMachine m)
    {
        Store(m);
        return Json(new { state = State(m) });
    }

    public static object State(MicroMachine m)
    {
        var c = m.Cpu;
        return new
        {
            registers = new
            {
                a = c.A, b = c.B, c = c.C, d = c.D, e = c.E, h = c.H, l = c.L,
                sp = c.SP, pc = c.PC, psw = c.PSW,
                mbc = c.Memory[c.BC], mde = c.Memory[c.DE], mhl = c.Memory[c.HL], mpc = c.Memory[c.PC],
            },
            flags = new { s = c.FlagS, z = c.FlagZ, ac = c.FlagAC, p = c.FlagP, cy = c.FlagCY },
            panel = new { leds = m.Panel.Leds, digits = m.Panel.Digits.Select(d => (int)d), text = m.Panel.Text },
            console = m.Console,
            m.Prompt,
            mode = m.Mode.ToString().ToLowerInvariant(),
            m.Beep,
            next = Assembler.Disassemble(c.Memory, c.PC).Mnemonic,
        };
    }
}
