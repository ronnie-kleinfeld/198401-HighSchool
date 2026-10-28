using HighSchool.Web.Legacy;
using HighSchool.Web.Modules.Micro;

namespace HighSchool.Tests.Micro;

public class MicroMonitorTests
{
    public static TheoryData<byte> AllOpcodes => [.. OpcodeTable.All.Select(o => o.Code)];

    [Theory]
    [MemberData(nameof(AllOpcodes))]
    public void Every_listed_instruction_assembles_back_to_the_same_bytes(byte code)
    {
        var op = OpcodeTable.Get(code)!;
        var text = op.Format(0x34, 0x12);
        var bytes = Assembler.Assemble(text);

        Assert.Equal(code, bytes[0]);
        Assert.Equal(op.Length, bytes.Length);
    }

    [Fact]
    public void Append_assembles_and_advances_the_prompt()
    {
        var m = new MicroMachine();
        MicroMonitor.Execute(m, "A2000 MVI A,38");

        Assert.Equal([0x3E, 0x38], m.Cpu.Memory[0x2000..0x2002]);
        Assert.Equal("A2002 ", m.Prompt);
        Assert.Equal(new ConsoleLine("A2000:MVI  A,38", "O2000:3E,38"), m.Console[^1]);
    }

    [Fact]
    public void Opcode_entry_validates_instruction_length()
    {
        var m = new MicroMachine();
        MicroMonitor.Execute(m, "O2000 C3,00");
        Assert.Equal("err", m.Console[^1].Kind);
        Assert.StartsWith("7 ", m.Console[^1].Left);

        MicroMonitor.Execute(m, "O2000 C3,00,20");
        Assert.Equal(new ConsoleLine("O2000:C3,00,20", "A2000:JMP  2000"), m.Console[^1]);
    }

    [Fact]
    public void List_set_move_and_register_commands()
    {
        var m = new MicroMachine();
        MicroMonitor.Execute(m, "S2000 3E,38,76");
        MicroMonitor.Execute(m, "M2000-2002 3000");
        MicroMonitor.Execute(m, "L3000-3002");
        Assert.Equal("A3000:MVI  A,38", m.Console[^2].Left);
        Assert.Equal("A3002:HLT", m.Console[^1].Left);

        MicroMonitor.Execute(m, "R:HL=3000");
        MicroMonitor.Execute(m, "R:M=99");
        Assert.Equal(0x99, m.Cpu.Memory[0x3000]);
    }

    [Theory]
    [InlineData("A0050 NOP", 5)]
    [InlineData("A2000 MVX A,1", 2)]
    [InlineData("A2000 MVI Q,1", 3)]
    [InlineData("X2000", 6)]
    [InlineData("L2010-2000", 1)]
    public void Errors_use_the_original_numbers(string command, int error)
    {
        var m = new MicroMachine();
        MicroMonitor.Execute(m, command);
        Assert.Equal("err", m.Console[^1].Kind);
        Assert.StartsWith($"{error} ", m.Console[^1].Left);
    }

    [Fact]
    public void Go_runs_a_saved_1988_program_and_lights_the_seven_segment_display()
    {
        var program = LegacyImporter.ReadMicroPrograms(LegacyFolder.File("MICRO", "MCRNAME.DAT"))
            .Single(p => p.Name == "ORT-88");
        var m = new MicroMachine();
        program.Code.CopyTo(m.Cpu.Memory, program.StartAddress);

        MicroMonitor.Execute(m, $"G{program.StartAddress:X4}");
        var batch = MicroRunner.Run(m, budgetMs: 1000, instructionsPerSecond: 10_000);

        Assert.Equal("halted", batch.Status);
        Assert.Equal(6, batch.Events.Count(e => e.Kind == "digit"));
        Assert.Equal(RunMode.None, m.Mode);
        Assert.StartsWith("Halt at", m.Console[^1].Left);
    }

    [Fact]
    public void Trace_executes_one_instruction_per_batch()
    {
        var m = new MicroMachine();
        MicroMonitor.Execute(m, "S2000 3E,01,3C,76");
        MicroMonitor.Execute(m, "T2000");

        var first = MicroRunner.Run(m, 1000, 10_000);
        Assert.Equal("trace", first.Status);
        Assert.Equal(0x2002, m.Cpu.PC);

        MicroRunner.Run(m, 1000, 10_000);
        Assert.Equal(2, m.Cpu.A);
    }
}
