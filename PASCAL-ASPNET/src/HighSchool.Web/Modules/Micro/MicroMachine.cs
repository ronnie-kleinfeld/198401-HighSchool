namespace HighSchool.Web.Modules.Micro;

public enum RunMode { None, Go, Trace }

/// <summary>One line of the monitor's left window. The original showed two columns split by '│'.</summary>
public sealed record ConsoleLine(string Left, string Right = "", string Kind = "out");

/// <summary>Everything MICRO.COM kept in global variables, so it can live in the user's session.</summary>
public sealed class MicroMachine
{
    public const int MaxConsoleLines = 400;

    public Cpu8085 Cpu { get; set; } = new();
    public IoPanel Panel { get; set; } = new();
    public List<ConsoleLine> Console { get; set; } = [];
    public RunMode Mode { get; set; }
    public bool Beep { get; set; } = true;

    /// <summary>The text pre-filled on the next command line ("A2002 " after assembling at 2000).</summary>
    public string Prompt { get; set; } = "A2000 ";

    public void Write(ConsoleLine line)
    {
        Console.Add(line);
        if (Console.Count > MaxConsoleLines) Console.RemoveRange(0, Console.Count - MaxConsoleLines);
    }

    public void Error(MicroError error) => Write(new ConsoleLine($"{error.Number} {error.Message}", "", "err"));
}

public sealed record RunBatch(string Status, double DurationMs, IReadOnlyList<TimedPanelEvent> Events, string? Message, byte? InputPort);

public sealed record TimedPanelEvent(double T, string Kind, int Index, int Value);

/// <summary>
/// The RUN loop of MICRO-C.PAS, cut into batches so a browser can animate the panel in real time.
/// Each batch runs until <paramref name="budgetMs"/> of simulated time has passed (at the chosen
/// instructions-per-second) or the program halts, breaks, or waits on IN #00 / IN #FF.
/// </summary>
public static class MicroRunner
{
    private const int MaxInstructionsPerBatch = 2_000_000;

    public static RunBatch Run(MicroMachine m, double budgetMs, int instructionsPerSecond, byte? input = null)
    {
        var cpu = m.Cpu;
        var events = new List<TimedPanelEvent>();
        var msPerInstruction = 1000.0 / Math.Clamp(instructionsPerSecond, 100, 5_000_000);
        var t = 0.0;

        if (cpu.PendingInputPort is { } waiting)
        {
            if (input is null) return new RunBatch("input", 0, events, null, waiting);
            cpu.CompleteInput(input.Value);
            if (waiting == 0xFF && m.Panel.Write(0xFF, input.Value) is { } echo)
                events.Add(new TimedPanelEvent(0, echo.Kind, echo.Index, echo.Value));
            m.Write(new ConsoleLine($"Enter {(waiting == 0 ? "number #00" : "key in #FF")}", input.Value.ToString("X2")));
        }

        var steps = m.Mode == RunMode.Trace ? 1 : MaxInstructionsPerBatch;
        for (var i = 0; i < steps && t < budgetMs; i++)
        {
            var pc = cpu.PC;
            var outcome = cpu.Step(m.Panel);
            t += msPerInstruction + cpu.LastDelayMs;
            if (cpu.LastPanelEvent is { } e) events.Add(new TimedPanelEvent(t, e.Kind, e.Index, e.Value));

            switch (outcome)
            {
                case StepOutcome.Halted:
                    return Stop(m, "halted", t, events, $"Halt at {pc:X4}");
                case StepOutcome.Restart:
                    return Stop(m, "halted", t, events, $"RST {(cpu.Memory[pc] >> 3) & 7} at {pc:X4} - back to monitor");
                case StepOutcome.UnknownOpcode:
                    m.Error(MicroError.UnknownOpcode);
                    return Stop(m, "error", t, events, $"Break at {pc:X4}");
                case StepOutcome.WaitingForInput:
                    return new RunBatch("input", t, events, null, cpu.PendingInputPort);
            }
        }

        if (m.Mode == RunMode.Trace)
            return new RunBatch("trace", t, events, $"{cpu.PC:X4}  {Assembler.Disassemble(cpu.Memory, cpu.PC).Mnemonic}", null);
        return new RunBatch("running", t, events, null, null);
    }

    public static void Break(MicroMachine m)
    {
        if (m.Mode == RunMode.None) return;
        m.Cpu.PendingInputPort = null;
        m.Mode = RunMode.None;
        m.Write(new ConsoleLine($"Break at {m.Cpu.PC:X4}", "", "info"));
    }

    private static RunBatch Stop(MicroMachine m, string status, double t, List<TimedPanelEvent> events, string message)
    {
        m.Mode = RunMode.None;
        m.Write(new ConsoleLine(message, "", "info"));
        return new RunBatch(status, t, events, message, null);
    }
}
