using HighSchool.Web.Modules.Micro;

namespace HighSchool.Tests.Micro;

public class CpuTests
{
    private static (Cpu8085 Cpu, IoPanel Io) Load(params string[] source)
    {
        var cpu = new Cpu8085();
        var address = Cpu8085.ResetPc;
        foreach (var line in source)
        {
            var bytes = Assembler.Assemble(line);
            bytes.CopyTo(cpu.Memory, address);
            address += bytes.Length;
        }
        return (cpu, new IoPanel());
    }

    private static StepOutcome RunToHalt(Cpu8085 cpu, IoPanel io, int limit = 10_000)
    {
        for (var i = 0; i < limit; i++)
        {
            var outcome = cpu.Step(io);
            if (outcome != StepOutcome.Ok) return outcome;
        }
        throw new TimeoutException();
    }

    [Fact]
    public void Add_sets_carry_and_zero()
    {
        var (cpu, io) = Load("MVI A,F0", "MVI B,10", "ADD B", "HLT");
        Assert.Equal(StepOutcome.Halted, RunToHalt(cpu, io));
        Assert.Equal(0, cpu.A);
        Assert.True(cpu.FlagCY);
        Assert.True(cpu.FlagZ);
        Assert.True(cpu.FlagP);
    }

    [Fact]
    public void Compare_sets_borrow_when_operand_is_larger()
    {
        var (cpu, io) = Load("MVI A,05", "CPI 07", "HLT");
        RunToHalt(cpu, io);
        Assert.Equal(5, cpu.A);
        Assert.True(cpu.FlagCY);
        Assert.True(cpu.FlagS);
        Assert.False(cpu.FlagZ);
    }

    [Fact]
    public void Daa_adjusts_bcd_addition()
    {
        var (cpu, io) = Load("MVI A,38", "ADI 45", "DAA", "HLT");
        RunToHalt(cpu, io);
        Assert.Equal(0x83, cpu.A);
    }

    [Fact]
    public void Push_pop_call_and_ret_use_the_stack_like_an_8085()
    {
        var (cpu, io) = Load(
            "LXI B,1234",      // 2000
            "PUSH B",          // 2003
            "POP D",           // 2004
            "CALL 2010",       // 2005
            "HLT",             // 2008
            "NOP", "NOP", "NOP", "NOP", "NOP", "NOP", "NOP",
            "MVI A,77",        // 2010
            "RET");
        Assert.Equal(StepOutcome.Halted, RunToHalt(cpu, io));
        Assert.Equal(0x1234, cpu.DE);
        Assert.Equal(0x77, cpu.A);
        Assert.Equal(Cpu8085.ResetSp, cpu.SP);
        Assert.Equal(0x2008, cpu.PC);
    }

    [Fact]
    public void Loop_with_conditional_jump_counts_down()
    {
        var (cpu, io) = Load("MVI C,05", "MVI A,00", "ADI 02", "DCR C", "JNZ 2004", "HLT");
        RunToHalt(cpu, io);
        Assert.Equal(10, cpu.A);
        Assert.Equal(0, cpu.C);
    }

    [Fact]
    public void Out_drives_the_panel_and_in_waits_for_the_user()
    {
        var (cpu, io) = Load("MVI A,8A", "OUT #05", "MVI A,C0", "OUT #04", "IN #00", "OUT #00", "HLT");
        Assert.Equal(StepOutcome.WaitingForInput, RunToHalt(cpu, io));
        Assert.Equal((byte)0x00, cpu.PendingInputPort);
        Assert.Equal(0xC0, io.Digits[2]);

        cpu.CompleteInput(0b1010_0101);
        Assert.Equal(StepOutcome.Halted, RunToHalt(cpu, io));
        Assert.Equal(0b1010_0101, io.Leds);
    }

    [Fact]
    public void Hold_is_the_original_delay_instruction()
    {
        var (cpu, io) = Load("HOLD 0000");
        cpu.Step(io);
        Assert.Equal(32767 / 2, cpu.LastDelayMs);
    }
}
