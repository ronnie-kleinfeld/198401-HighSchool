namespace HighSchool.Web.Modules.Micro;

public enum StepOutcome { Ok, Halted, WaitingForInput, Restart, UnknownOpcode }

/// <summary>
/// The interpreter of MICRO-C.PAS (procedure CAOF), rewritten as a straightforward 8085 core.
///
/// Differences from the 1988 interpreter, which had several bugs a real program could trip over:
/// PUSH B/D wrote to the wrong stack bytes, LHLD read from the wrong address, DAD/CMP/SUB got the carry wrong,
/// and the auxiliary-carry flag and DAA were not implemented. Those now behave like the Intel part.
/// Kept from the original: the HOLD delay instruction (08), RST used as "return to monitor",
/// and the reset state (SP = 38FE, PC = 2000).
/// </summary>
public sealed class Cpu8085
{
    public const int ResetPc = 0x2000;
    public const int ResetSp = 0x38FE;

    public byte A { get; set; }
    public byte B { get; set; }
    public byte C { get; set; }
    public byte D { get; set; }
    public byte E { get; set; }
    public byte H { get; set; }
    public byte L { get; set; }
    public ushort SP { get; set; } = ResetSp;
    public ushort PC { get; set; } = ResetPc;

    public bool FlagS { get; set; }
    public bool FlagZ { get; set; }
    public bool FlagAC { get; set; }
    public bool FlagP { get; set; }
    public bool FlagCY { get; set; }

    public byte[] Memory { get; set; } = new byte[0x10000];

    /// <summary>Set when the last step stopped on an IN instruction; the value is supplied with <see cref="CompleteInput"/>.</summary>
    public byte? PendingInputPort { get; set; }

    /// <summary>Extra delay (milliseconds) requested by the last HOLD instruction.</summary>
    public int LastDelayMs { get; private set; }

    /// <summary>What the last OUT instruction changed on the panel, if anything.</summary>
    public PanelEvent? LastPanelEvent { get; private set; }

    public void Reset()
    {
        A = B = C = D = E = H = L = 0;
        FlagS = FlagZ = FlagAC = FlagP = FlagCY = false;
        SP = ResetSp;
        PC = ResetPc;
        PendingInputPort = null;
    }

    public ushort BC { get => (ushort)(B << 8 | C); set { B = (byte)(value >> 8); C = (byte)value; } }
    public ushort DE { get => (ushort)(D << 8 | E); set { D = (byte)(value >> 8); E = (byte)value; } }
    public ushort HL { get => (ushort)(H << 8 | L); set { H = (byte)(value >> 8); L = (byte)value; } }

    public byte Flags
    {
        get => (byte)((FlagS ? 0x80 : 0) | (FlagZ ? 0x40 : 0) | (FlagAC ? 0x10 : 0) | (FlagP ? 0x04 : 0) | 0x02 | (FlagCY ? 0x01 : 0));
        set
        {
            FlagS = (value & 0x80) != 0; FlagZ = (value & 0x40) != 0; FlagAC = (value & 0x10) != 0;
            FlagP = (value & 0x04) != 0; FlagCY = (value & 0x01) != 0;
        }
    }

    public ushort PSW { get => (ushort)(A << 8 | Flags); set { A = (byte)(value >> 8); Flags = (byte)value; } }

    public byte M { get => Memory[HL]; set => Memory[HL] = value; }

    public byte GetReg(int index) => index switch
    {
        0 => B, 1 => C, 2 => D, 3 => E, 4 => H, 5 => L, 6 => M, _ => A
    };

    public void SetReg(int index, byte value)
    {
        switch (index)
        {
            case 0: B = value; break;
            case 1: C = value; break;
            case 2: D = value; break;
            case 3: E = value; break;
            case 4: H = value; break;
            case 5: L = value; break;
            case 6: M = value; break;
            default: A = value; break;
        }
    }

    private ushort GetPair(int p) => p switch { 0 => BC, 1 => DE, 2 => HL, _ => SP };

    private void SetPair(int p, ushort v)
    {
        switch (p)
        {
            case 0: BC = v; break;
            case 1: DE = v; break;
            case 2: HL = v; break;
            default: SP = v; break;
        }
    }

    private void Push(ushort v)
    {
        Memory[--SP] = (byte)(v >> 8);
        Memory[--SP] = (byte)v;
    }

    private ushort Pop()
    {
        var lo = Memory[SP++];
        var hi = Memory[SP++];
        return (ushort)(hi << 8 | lo);
    }

    private void SetSZP(byte r)
    {
        FlagS = (r & 0x80) != 0;
        FlagZ = r == 0;
        FlagP = System.Numerics.BitOperations.PopCount(r) % 2 == 0;
    }

    private byte Add(byte a, byte v, bool carryIn)
    {
        var c = carryIn ? 1 : 0;
        var r = a + v + c;
        FlagAC = (a & 0x0F) + (v & 0x0F) + c > 0x0F;
        FlagCY = r > 0xFF;
        SetSZP((byte)r);
        return (byte)r;
    }

    private byte Sub(byte a, byte v, bool borrowIn)
    {
        var b = borrowIn ? 1 : 0;
        var r = a - v - b;
        FlagAC = (a & 0x0F) + (~v & 0x0F) + (1 - b) > 0x0F;
        FlagCY = r < 0;
        SetSZP((byte)r);
        return (byte)r;
    }

    private void Alu(int op, byte v)
    {
        switch (op)
        {
            case 0: A = Add(A, v, false); break;
            case 1: A = Add(A, v, FlagCY); break;
            case 2: A = Sub(A, v, false); break;
            case 3: A = Sub(A, v, FlagCY); break;
            case 4: FlagAC = ((A | v) & 0x08) != 0; A &= v; FlagCY = false; SetSZP(A); break;
            case 5: A ^= v; FlagCY = FlagAC = false; SetSZP(A); break;
            case 6: A |= v; FlagCY = FlagAC = false; SetSZP(A); break;
            default: Sub(A, v, false); break;
        }
    }

    private bool Condition(int cc) => cc switch
    {
        0 => !FlagZ, 1 => FlagZ, 2 => !FlagCY, 3 => FlagCY,
        4 => !FlagP, 5 => FlagP, 6 => !FlagS, _ => FlagS
    };

    /// <summary>Executes one instruction. OUT writes go to <paramref name="io"/>.</summary>
    public StepOutcome Step(IoPanel io)
    {
        LastDelayMs = 0;
        LastPanelEvent = null;
        var op = Memory[PC];
        var info = OpcodeTable.Get(op);
        if (info is null) return StepOutcome.UnknownOpcode;

        var lo = Memory[(ushort)(PC + 1)];
        var hi = Memory[(ushort)(PC + 2)];
        var word = (ushort)(hi << 8 | lo);
        var next = (ushort)(PC + info.Length);

        int dst = (op >> 3) & 7, src = op & 7, pair = (op >> 4) & 3;

        switch (op)
        {
            case 0x76:
                return StepOutcome.Halted;
            case >= 0x40 and <= 0x7F:
                SetReg(dst, GetReg(src));
                break;
            case >= 0x80 and <= 0xBF:
                Alu(dst, GetReg(src));
                break;

            case 0x00 or 0x20 or 0x30 or 0xF3 or 0xFB:
                if (op == 0x20) A = 0; // RIM: no interrupts pending, no serial input
                break;
            case 0x08: // HOLD – MICRO's delay: delay(abs(lo*256+hi-32767) div 2) in the original
                LastDelayMs = Math.Abs(lo * 256 + hi - 32767) / 2;
                break;

            case 0x01 or 0x11 or 0x21 or 0x31: SetPair(pair, word); break;
            case 0x03 or 0x13 or 0x23 or 0x33: SetPair(pair, (ushort)(GetPair(pair) + 1)); break;
            case 0x0B or 0x1B or 0x2B or 0x3B: SetPair(pair, (ushort)(GetPair(pair) - 1)); break;
            case 0x09 or 0x19 or 0x29 or 0x39:
            {
                var r = HL + GetPair(pair);
                FlagCY = r > 0xFFFF;
                HL = (ushort)r;
                break;
            }

            case 0x02: Memory[BC] = A; break;
            case 0x12: Memory[DE] = A; break;
            case 0x0A: A = Memory[BC]; break;
            case 0x1A: A = Memory[DE]; break;
            case 0x22: Memory[word] = L; Memory[(ushort)(word + 1)] = H; break;
            case 0x2A: L = Memory[word]; H = Memory[(ushort)(word + 1)]; break;
            case 0x32: Memory[word] = A; break;
            case 0x3A: A = Memory[word]; break;

            case 0x04 or 0x0C or 0x14 or 0x1C or 0x24 or 0x2C or 0x34 or 0x3C:
            {
                var v = GetReg(dst);
                var r = (byte)(v + 1);
                FlagAC = (v & 0x0F) == 0x0F;
                SetSZP(r);
                SetReg(dst, r);
                break;
            }
            case 0x05 or 0x0D or 0x15 or 0x1D or 0x25 or 0x2D or 0x35 or 0x3D:
            {
                var v = GetReg(dst);
                var r = (byte)(v - 1);
                FlagAC = (v & 0x0F) != 0;
                SetSZP(r);
                SetReg(dst, r);
                break;
            }
            case 0x06 or 0x0E or 0x16 or 0x1E or 0x26 or 0x2E or 0x36 or 0x3E:
                SetReg(dst, lo);
                break;

            case 0x07: FlagCY = (A & 0x80) != 0; A = (byte)(A << 1 | (FlagCY ? 1 : 0)); break;
            case 0x0F: FlagCY = (A & 0x01) != 0; A = (byte)(A >> 1 | (FlagCY ? 0x80 : 0)); break;
            case 0x17: { var c = FlagCY; FlagCY = (A & 0x80) != 0; A = (byte)(A << 1 | (c ? 1 : 0)); break; }
            case 0x1F: { var c = FlagCY; FlagCY = (A & 0x01) != 0; A = (byte)(A >> 1 | (c ? 0x80 : 0)); break; }
            case 0x27:
            {
                var correction = 0;
                var carry = FlagCY;
                if ((A & 0x0F) > 9 || FlagAC) correction |= 0x06;
                if (A > 0x99 || FlagCY) { correction |= 0x60; carry = true; }
                A = Add(A, (byte)correction, false);
                FlagCY = carry;
                break;
            }
            case 0x2F: A = (byte)~A; break;
            case 0x37: FlagCY = true; break;
            case 0x3F: FlagCY = !FlagCY; break;

            case 0xC6 or 0xCE or 0xD6 or 0xDE or 0xE6 or 0xEE or 0xF6 or 0xFE:
                Alu(dst, lo);
                break;

            case 0xC3: next = word; break;
            case 0xCD: Push(next); next = word; break;
            case 0xC9: next = Pop(); break;
            case 0xC2 or 0xCA or 0xD2 or 0xDA or 0xE2 or 0xEA or 0xF2 or 0xFA:
                if (Condition(dst)) next = word;
                break;
            case 0xC4 or 0xCC or 0xD4 or 0xDC or 0xE4 or 0xEC or 0xF4 or 0xFC:
                if (Condition(dst)) { Push(next); next = word; }
                break;
            case 0xC0 or 0xC8 or 0xD0 or 0xD8 or 0xE0 or 0xE8 or 0xF0 or 0xF8:
                if (Condition(dst)) next = Pop();
                break;
            case 0xC7 or 0xCF or 0xD7 or 0xDF or 0xE7 or 0xEF or 0xF7 or 0xFF:
                return StepOutcome.Restart;

            case 0xC1 or 0xD1 or 0xE1: SetPair(pair, Pop()); break;
            case 0xF1: PSW = Pop(); break;
            case 0xC5 or 0xD5 or 0xE5: Push(GetPair(pair)); break;
            case 0xF5: Push(PSW); break;

            case 0xE3:
            {
                var top = (ushort)(Memory[(ushort)(SP + 1)] << 8 | Memory[SP]);
                Memory[SP] = L;
                Memory[(ushort)(SP + 1)] = H;
                HL = top;
                break;
            }
            case 0xE9: next = HL; break;
            case 0xEB: (H, L, D, E) = (D, E, H, L); break;
            case 0xF9: SP = HL; break;

            case 0xD3:
                LastPanelEvent = io.Write(lo, A);
                break;
            case 0xDB:
                if (IoPanel.IsInputPort(lo))
                {
                    PendingInputPort = lo;
                    return StepOutcome.WaitingForInput; // PC stays on the IN until the value arrives
                }
                A = 0;
                break;
        }

        PC = next;
        return StepOutcome.Ok;
    }

    /// <summary>Finishes an IN instruction that stopped with <see cref="StepOutcome.WaitingForInput"/>.</summary>
    public void CompleteInput(byte value)
    {
        if (PendingInputPort is null) return;
        A = value;
        PendingInputPort = null;
        PC = (ushort)(PC + 2);
    }
}
