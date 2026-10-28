using System.Text.RegularExpressions;

namespace HighSchool.Web.Modules.Micro;

/// <summary>
/// The command line of MICRO (procedure ENTER and friends in MICRO-B/C.PAS).
/// <code>
/// A2000 MVI A,38      assemble one instruction            O2000 3E,38     enter one instruction as op codes
/// L2000-2010          list as mnemonics (L2000- to 7FFF)  K2000-2010      list with op codes first
/// P2000-2010          printable listing                   S2000 48,54     set memory bytes
/// M2000-2010 3000     move a block                        G2000 / T2000   run / trace
/// R:A=15              set a register, pair or flag        CLS             clear the window
/// </code>
/// </summary>
public static partial class MicroMonitor
{
    public const int MinAddress = 0x0100;
    public const int MaxAddress = 0x7FFF;
    private const int MaxListLines = 2048;

    public static void Execute(MicroMachine m, string input)
    {
        var line = input.Trim().ToUpperInvariant();
        if (line.Length == 0) { m.Prompt = ""; return; }

        m.Write(new ConsoleLine(line, "", "cmd"));
        try
        {
            if (line == "CLS") { m.Console.Clear(); m.Prompt = ""; return; }

            switch (line[0])
            {
                case 'A': Append(m, line); break;
                case 'O': Opcode(m, line); break;
                case 'L' or 'K' or 'P': List(m, line); break;
                case 'S': Set(m, line); break;
                case 'M': Move(m, line); break;
                case 'G' or 'T': Start(m, line); break;
                case 'R': SetRegister(m, line); break;
                default: throw new MicroException(MicroError.UnknownCommand);
            }
        }
        catch (MicroException ex)
        {
            m.Error(ex.Error);
        }
    }

    private static int Address(string hex)
    {
        var value = Assembler.ParseHex(hex, 4) ?? throw new MicroException(MicroError.Syntax);
        if (value is < MinAddress or > MaxAddress) throw new MicroException(MicroError.LineOutOfRange);
        return value;
    }

    private static int Next(int address) => address > MaxAddress ? MinAddress : address;

    private static byte[] HexBytes(string text)
    {
        var digits = Regex.Replace(text, "[ ,:]", "");
        if (digits.Length == 0 || digits.Length % 2 != 0 || !HexOnly().IsMatch(digits))
            throw new MicroException(MicroError.OpcodeSyntax);
        return Convert.FromHexString(digits);
    }

    private static void Append(MicroMachine m, string line)
    {
        var match = AppendPattern().Match(line);
        if (!match.Success) throw new MicroException(MicroError.Syntax);
        var address = Address(match.Groups[1].Value);

        if (match.Groups[2].Value.Length == 0) { m.Prompt = $"A{address:X4} "; return; }

        var bytes = Assembler.Assemble(match.Groups[2].Value);
        bytes.CopyTo(m.Cpu.Memory, address);
        WriteListingLine(m, address, mnemonicsFirst: true);
        m.Prompt = $"A{Next(address + bytes.Length):X4} ";
    }

    private static void Opcode(MicroMachine m, string line)
    {
        var match = BytesPattern().Match(line);
        if (!match.Success) throw new MicroException(MicroError.OpcodeSyntax);
        var address = Address(match.Groups[1].Value);
        if (match.Groups[2].Value.Length == 0) { m.Prompt = $"O{address:X4} "; return; }

        var bytes = HexBytes(match.Groups[2].Value);
        var op = OpcodeTable.Get(bytes[0]) ?? throw new MicroException(MicroError.UnknownOpcode);
        if (bytes.Length != op.Length) throw new MicroException(MicroError.OpcodeSyntax);

        bytes.CopyTo(m.Cpu.Memory, address);
        WriteListingLine(m, address, mnemonicsFirst: false);
        m.Prompt = $"O{Next(address + bytes.Length):X4} ";
    }

    private static void Set(MicroMachine m, string line)
    {
        var match = BytesPattern().Match(line);
        if (!match.Success) throw new MicroException(MicroError.OpcodeSyntax);
        var address = Address(match.Groups[1].Value);
        if (match.Groups[2].Value.Length == 0) { m.Prompt = $"S{address:X4}:"; return; }

        var bytes = HexBytes(match.Groups[2].Value);
        if (address + bytes.Length - 1 > MaxAddress) throw new MicroException(MicroError.LineOutOfRange);
        bytes.CopyTo(m.Cpu.Memory, address);
        m.Write(new ConsoleLine($"S{address:X4}:{Convert.ToHexString(bytes)}"));
        m.Prompt = $"S{Next(address + bytes.Length):X4}:";
    }

    private static void Move(MicroMachine m, string line)
    {
        var match = MovePattern().Match(line);
        if (!match.Success) throw new MicroException(MicroError.Syntax);
        int from = Address(match.Groups[1].Value), to = Address(match.Groups[2].Value), dest = Address(match.Groups[3].Value);
        if (to < from) throw new MicroException(MicroError.ListType);
        var length = to - from + 1;
        if (dest + length - 1 > MaxAddress) throw new MicroException(MicroError.LineOutOfRange);
        Array.Copy(m.Cpu.Memory, from, m.Cpu.Memory, dest, length);
        m.Write(new ConsoleLine($"Moved {length:X4}h bytes to {dest:X4}"));
        m.Prompt = "";
    }

    /// <summary>Lines a listing produces; shared by L/K in the window and P on the print page.</summary>
    public static IEnumerable<(int Address, string Mnemonic, string Opcodes)> Listing(byte[] memory, int from, int to)
    {
        var count = 0;
        for (var address = from; address <= to && count < MaxListLines; count++)
        {
            var (mnemonic, length) = Assembler.Disassemble(memory, address);
            var opcodes = mnemonic == "----" ? "--" : Assembler.OpcodeBytes(memory, address, length);
            yield return (address, mnemonic, opcodes);
            address += length;
        }
    }

    public static (int From, int To) ParseRange(string text)
    {
        var match = RangePattern().Match(text.Trim().ToUpperInvariant());
        if (!match.Success) throw new MicroException(MicroError.ListType);
        var from = Address(match.Groups[1].Value);
        var to = match.Groups[2].Success
            ? (match.Groups[3].Value.Length == 0 ? MaxAddress : Address(match.Groups[3].Value))
            : from;
        if (to < from) throw new MicroException(MicroError.ListType);
        return (from, to);
    }

    private static void List(MicroMachine m, string line)
    {
        var (from, to) = ParseRange(line[1..]);
        if (line[0] == 'P')
        {
            m.Write(new ConsoleLine($"Print {from:X4}-{to:X4}", "", $"print:{from:X4}-{to:X4}"));
            m.Prompt = "";
            return;
        }
        foreach (var (address, _, _) in Listing(m.Cpu.Memory, from, to))
            WriteListingLine(m, address, mnemonicsFirst: line[0] == 'L');
        m.Prompt = "";
    }

    private static void WriteListingLine(MicroMachine m, int address, bool mnemonicsFirst)
    {
        var (mnemonic, length) = Assembler.Disassemble(m.Cpu.Memory, address);
        var a = $"A{address:X4}:{mnemonic}";
        var o = $"O{address:X4}:{(mnemonic == "----" ? "--" : Assembler.OpcodeBytes(m.Cpu.Memory, address, length))}";
        m.Write(mnemonicsFirst ? new ConsoleLine(a, o) : new ConsoleLine(o, a));
    }

    private static void Start(MicroMachine m, string line)
    {
        var match = RunPattern().Match(line);
        if (!match.Success) throw new MicroException(MicroError.Syntax);
        if (match.Groups[2].Value.Length > 0) m.Cpu.PC = (ushort)Address(match.Groups[2].Value);
        m.Cpu.PendingInputPort = null;
        m.Mode = match.Groups[1].Value == "G" ? RunMode.Go : RunMode.Trace;
        m.Write(new ConsoleLine($"{(m.Mode == RunMode.Go ? "Run" : "Trace")} from {m.Cpu.PC:X4}", "B = break", "info"));
        m.Prompt = "";
    }

    private static void SetRegister(MicroMachine m, string line)
    {
        var match = RegisterPattern().Match(line);
        if (!match.Success) throw new MicroException(MicroError.Syntax);
        var name = match.Groups[1].Value;
        var value = Assembler.ParseHex(match.Groups[2].Value, 4) ?? throw new MicroException(MicroError.Syntax);
        var cpu = m.Cpu;

        var limit = name switch { "S" or "Z" or "P" or "CY" => 1, "SP" or "PC" or "PSW" or "BC" or "DE" or "HL" => 0xFFFF, _ => 0xFF };
        if (value > limit) throw new MicroException(MicroError.Syntax);

        switch (name)
        {
            case "SP": cpu.SP = (ushort)value; break;
            case "PC": cpu.PC = (ushort)value; break;
            case "PSW": cpu.PSW = (ushort)value; break;
            case "BC": cpu.BC = (ushort)value; break;
            case "DE": cpu.DE = (ushort)value; break;
            case "HL": cpu.HL = (ushort)value; break;
            case "S": cpu.FlagS = value == 1; break;
            case "Z": cpu.FlagZ = value == 1; break;
            case "P": cpu.FlagP = value == 1; break;
            case "CY": cpu.FlagCY = value == 1; break;
            default: cpu.SetReg(Array.IndexOf(OpcodeTable.Reg8, name), (byte)value); break;
        }
        m.Write(new ConsoleLine($"R:{name}={value:X}"));
        m.Prompt = "R:";
    }

    [GeneratedRegex(@"^A\s*([0-9A-F]{1,4})\s*:?\s*(.*)$")] private static partial Regex AppendPattern();
    [GeneratedRegex(@"^[OS]\s*([0-9A-F]{1,4})\s*:?\s*([0-9A-F ,]*)$")] private static partial Regex BytesPattern();
    [GeneratedRegex(@"^M\s*([0-9A-F]{1,4})\s*-\s*([0-9A-F]{1,4})[\s,]+([0-9A-F]{1,4})$")] private static partial Regex MovePattern();
    [GeneratedRegex(@"^\s*([0-9A-F]{1,4})\s*(-\s*([0-9A-F]{0,4}))?\s*$")] private static partial Regex RangePattern();
    [GeneratedRegex(@"^([GT])\s*([0-9A-F]{0,4})$")] private static partial Regex RunPattern();
    [GeneratedRegex(@"^R\s*:?\s*(PSW|SP|PC|BC|DE|HL|CY|[ABCDEHLMSZP])\s*=\s*([0-9A-F]{1,4})H?$")] private static partial Regex RegisterPattern();
    [GeneratedRegex("^[0-9A-F]+$")] private static partial Regex HexOnly();
}
