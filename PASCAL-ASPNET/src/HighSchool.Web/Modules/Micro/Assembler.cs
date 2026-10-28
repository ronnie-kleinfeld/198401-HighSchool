using System.Globalization;

namespace HighSchool.Web.Modules.Micro;

public sealed class MicroException(MicroError error) : Exception(error.Message)
{
    public MicroError Error { get; } = error;
}

/// <summary>Error numbers and help text from ERR_ / ERT in MICRO-A.PAS (shown by F3 in the original).</summary>
public sealed record MicroError(int Number, string Message, string Explanation)
{
    public static readonly MicroError ListType = new(1, "List type mistake",
        "A request for a program list that does not have a char that departure between the two line numbers");
    public static readonly MicroError InvalidOperation = new(2, "Invalid mnemonics operations",
        "The mnemonics operation does not match with the computer library or the mnemonics does not operate like an command");
    public static readonly MicroError InvalidOperand = new(3, "Invalid mnemonics operand",
        "The mnemonics operand is not correct");
    public static readonly MicroError Syntax = new(4, "Syntax error",
        "An error was brought up in the middle of the program run and the program can not continue");
    public static readonly MicroError LineOutOfRange = new(5, "Line out of range",
        "Line number is out of the computer range (h0100-h7FFF)");
    public static readonly MicroError UnknownCommand = new(6, "Unkonwed command",
        "The first letter in the line does not match with the list which the computer has");
    public static readonly MicroError OpcodeSyntax = new(7, "Op code syntax error",
        "The op code is out of range, this error might be also because the length of the op code is not in the right length");
    public static readonly MicroError UnknownOpcode = new(8, "Unkonwed op code",
        "The op code in the memory list does not operate like an op code");

    public static readonly IReadOnlyList<MicroError> All =
        [ListType, InvalidOperation, InvalidOperand, Syntax, LineOutOfRange, UnknownCommand, OpcodeSyntax, UnknownOpcode];
}

/// <summary>APPEND (mnemonics → op codes) and LIST (op codes → mnemonics) from MICRO-B.PAS.</summary>
public static class Assembler
{
    private static readonly Dictionary<string, OpcodeInfo> ByShape =
        OpcodeTable.All.ToDictionary(o => Shape(o.Mnemonic, o.Registers, o.Immediate != Immediate.None));

    private static string Shape(string mnemonic, string regs, bool hasImmediate) =>
        $"{mnemonic}|{regs}|{(hasImmediate ? "#" : "")}";

    /// <summary>Assembles one source line such as "MVI A,38", "LXI H,2000" or "OUT #04".</summary>
    public static byte[] Assemble(string source)
    {
        var text = source.Trim().ToUpperInvariant();
        if (text.Length == 0) throw new MicroException(MicroError.InvalidOperation);

        var space = text.IndexOf(' ');
        var mnemonic = space < 0 ? text : text[..space];
        var operands = space < 0 ? [] : text[(space + 1)..]
            .Split(',', StringSplitOptions.TrimEntries | StringSplitOptions.RemoveEmptyEntries);

        if (!OpcodeTable.All.Any(o => o.Mnemonic == mnemonic))
            throw new MicroException(MicroError.InvalidOperation);

        // Try "all operands are registers" first, then "last operand is a number".
        if (ByShape.TryGetValue(Shape(mnemonic, string.Join(',', operands), false), out var plain))
            return [plain.Code];

        if (operands.Length > 0 &&
            ByShape.TryGetValue(Shape(mnemonic, string.Join(',', operands[..^1]), true), out var withImm))
        {
            var value = ParseHex(operands[^1], withImm.Immediate == Immediate.Word ? 4 : 2)
                        ?? throw new MicroException(MicroError.InvalidOperand);
            return withImm.Length == 2
                ? [withImm.Code, (byte)value]
                : [withImm.Code, (byte)(value & 0xFF), (byte)(value >> 8)];
        }

        throw new MicroException(MicroError.InvalidOperand);
    }

    /// <summary>Accepts 38, 38H, #38, $38 (hex, like everything in MICRO).</summary>
    public static int? ParseHex(string token, int maxDigits)
    {
        var t = token.Trim().TrimStart('#', '$');
        if (t.EndsWith('H')) t = t[..^1];
        if (t.Length == 0 || t.Length > maxDigits) return null;
        return int.TryParse(t, NumberStyles.HexNumber, CultureInfo.InvariantCulture, out var v) ? v : null;
    }

    public static (string Mnemonic, int Length) Disassemble(ReadOnlySpan<byte> memory, int address)
    {
        var op = OpcodeTable.Get(memory[address & 0xFFFF]);
        if (op is null) return ("----", 1);
        return (op.Format(memory[(address + 1) & 0xFFFF], memory[(address + 2) & 0xFFFF]), op.Length);
    }

    /// <summary>The O-column of a listing: "3E,38" / "C3,00,20".</summary>
    public static string OpcodeBytes(ReadOnlySpan<byte> memory, int address, int length)
    {
        var parts = new string[length];
        for (var i = 0; i < length; i++) parts[i] = memory[(address + i) & 0xFFFF].ToString("X2");
        return string.Join(',', parts);
    }
}
