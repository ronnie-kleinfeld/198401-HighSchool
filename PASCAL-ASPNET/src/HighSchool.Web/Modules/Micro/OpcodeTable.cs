namespace HighSchool.Web.Modules.Micro;

public enum Immediate { None, Byte, Word, Port }

public sealed record OpcodeInfo(byte Code, string Mnemonic, string Registers, Immediate Immediate)
{
    public int Length => Immediate switch { Immediate.None => 1, Immediate.Word => 3, _ => 2 };

    /// <summary>Formats like the original listing: mnemonic padded to 4, a space, then operands ("MVI  A,38").</summary>
    public string Format(byte lo, byte hi)
    {
        var imm = Immediate switch
        {
            Immediate.Byte => lo.ToString("X2"),
            Immediate.Port => "#" + lo.ToString("X2"),
            Immediate.Word => ((hi << 8) | lo).ToString("X4"),
            _ => ""
        };
        var operands = Registers.Length > 0 && imm.Length > 0 ? $"{Registers},{imm}" : Registers + imm;
        return operands.Length == 0 ? Mnemonic : $"{Mnemonic,-4} {operands}";
    }
}

/// <summary>
/// The Intel 8085 instruction set as MICRO.PAS knew it (tables MEM_, OPR_, LEN in MICRO-A.PAS),
/// including its private "HOLD addr" (opcode 08), a delay instruction that does not exist on a real 8085.
/// </summary>
public static class OpcodeTable
{
    public static readonly string[] Reg8 = ["B", "C", "D", "E", "H", "L", "M", "A"];
    private static readonly string[] Pairs = ["B", "D", "H", "SP"];
    private static readonly string[] StackPairs = ["B", "D", "H", "PSW"];
    private static readonly string[] Conditions = ["NZ", "Z", "NC", "C", "PO", "PE", "P", "M"];
    private static readonly string[] AluOps = ["ADD", "ADC", "SUB", "SBB", "ANA", "XRA", "ORA", "CMP"];
    private static readonly string[] AluImm = ["ADI", "ACI", "SUI", "SBI", "ANI", "XRI", "ORI", "CPI"];

    private static readonly OpcodeInfo?[] Table = Build();

    public static OpcodeInfo? Get(byte code) => Table[code];

    public static IEnumerable<OpcodeInfo> All => Table.Where(o => o is not null)!;

    private static OpcodeInfo?[] Build()
    {
        var t = new OpcodeInfo?[256];
        void Add(int code, string mnemonic, string regs = "", Immediate imm = Immediate.None) =>
            t[code] = new OpcodeInfo((byte)code, mnemonic, regs, imm);

        for (var d = 0; d < 8; d++)
        {
            for (var s = 0; s < 8; s++)
                if (d != 6 || s != 6) Add(0x40 + d * 8 + s, "MOV", $"{Reg8[d]},{Reg8[s]}");
            Add(0x04 + d * 8, "INR", Reg8[d]);
            Add(0x05 + d * 8, "DCR", Reg8[d]);
            Add(0x06 + d * 8, "MVI", Reg8[d], Immediate.Byte);
            for (var s = 0; s < 8; s++) Add(0x80 + d * 8 + s, AluOps[d], Reg8[s]);
            Add(0xC6 + d * 8, AluImm[d], "", Immediate.Byte);
            Add(0xC0 + d * 8, "R" + Conditions[d]);
            Add(0xC2 + d * 8, "J" + Conditions[d], "", Immediate.Word);
            Add(0xC4 + d * 8, "C" + Conditions[d], "", Immediate.Word);
            Add(0xC7 + d * 8, "RST", d.ToString());
        }
        Add(0x76, "HLT");

        for (var p = 0; p < 4; p++)
        {
            Add(0x01 + p * 16, "LXI", Pairs[p], Immediate.Word);
            Add(0x03 + p * 16, "INX", Pairs[p]);
            Add(0x09 + p * 16, "DAD", Pairs[p]);
            Add(0x0B + p * 16, "DCX", Pairs[p]);
            Add(0xC1 + p * 16, "POP", StackPairs[p]);
            Add(0xC5 + p * 16, "PUSH", StackPairs[p]);
        }

        Add(0x00, "NOP");
        Add(0x02, "STAX", "B"); Add(0x12, "STAX", "D");
        Add(0x0A, "LDAX", "B"); Add(0x1A, "LDAX", "D");
        Add(0x22, "SHLD", "", Immediate.Word); Add(0x2A, "LHLD", "", Immediate.Word);
        Add(0x32, "STA", "", Immediate.Word); Add(0x3A, "LDA", "", Immediate.Word);
        Add(0x07, "RLC"); Add(0x0F, "RRC"); Add(0x17, "RAL"); Add(0x1F, "RAR");
        Add(0x27, "DAA"); Add(0x2F, "CMA"); Add(0x37, "STC"); Add(0x3F, "CMC");
        Add(0x20, "RIM"); Add(0x30, "SIM");
        Add(0x08, "HOLD", "", Immediate.Word);
        Add(0xC3, "JMP", "", Immediate.Word);
        Add(0xCD, "CALL", "", Immediate.Word);
        Add(0xC9, "RET");
        Add(0xD3, "OUT", "", Immediate.Port);
        Add(0xDB, "IN", "", Immediate.Port);
        Add(0xE3, "XTHL"); Add(0xE9, "PCHL"); Add(0xEB, "XCHG"); Add(0xF9, "SPHL");
        Add(0xF3, "DI"); Add(0xFB, "EI");
        return t;
    }
}
