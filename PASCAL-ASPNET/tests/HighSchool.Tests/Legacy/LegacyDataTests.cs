using HighSchool.Web.Legacy;
using HighSchool.Web.Modules.Romi;

namespace HighSchool.Tests.Legacy;

public class LegacyDataTests
{
    [Theory]
    [InlineData("תילגנא", "אנגלית")]
    [InlineData("053 הדוהי ןבא", "אבן יהודה 053")]
    [InlineData("LADY-LI", "LADY-LI")]
    [InlineData("ןתמה אנא לופיטב ךתשקב", "בקשתך בטיפול אנא המתן")]
    [InlineData("F7 - האיציל", "ליציאה - F7")]
    public void Visual_hebrew_is_converted_to_logical_order(string visual, string logical) =>
        Assert.Equal(logical, VisualHebrew.ToLogical(visual));

    [Fact]
    public void Real48_decodes_borland_reals()
    {
        // 3475.0 = 1.6967773... * 2^11  -> exponent byte 129 + 11 = 140
        Assert.Equal(3475.0, Real48.ToDouble([0x8C, 0x00, 0x00, 0x00, 0x30, 0x59]), 6);
        Assert.Equal(-1.0, Real48.ToDouble([0x81, 0, 0, 0, 0, 0x80]));
        Assert.Equal(0.0, Real48.ToDouble([0, 1, 2, 3, 4, 5]));
    }

    [Fact]
    public void Romi_store_file_has_788_active_stores_with_known_cities()
    {
        var stores = LegacyImporter.ReadStores(LegacyFolder.File("ROMI", "ROMISTOR.DAT")).ToList();

        Assert.Equal(788, stores.Count);
        Assert.All(stores, s => Assert.NotNull(RomiCities.Find(s.CityCode)));
        Assert.Contains(stores, s => s.StoreName == "LADY-LI");
        Assert.DoesNotContain(stores, s => s.WorkPhone.Any(char.IsLetter));
    }

    [Fact]
    public void Iq_question_bank_is_read_in_logical_hebrew()
    {
        var questions = LegacyImporter.ReadQuestions(LegacyFolder.File("IQ", "YEDA.DAT")).ToList();

        Assert.Equal(105, questions.Count);
        Assert.Equal("איסלאמאבד", questions[0].Term);
        Assert.Equal("בירת פקיסטן", questions[0].Definition);
        Assert.StartsWith("ידע", questions[0].Subject);
    }

    [Fact]
    public void Nihul_ledger_differs_from_1987_only_where_the_credit_card_sign_bug_struck()
    {
        var file = LegacyFolder.File("PROGRAMS", "NIHUL.DAT");
        var entries = LegacyImporter.ReadLedger(file).ToList();
        var storedBalances = TurboPascalRecord.ReadAll(File.ReadAllBytes(file), LegacyImporter.LedgerRecordSize)
            .Skip(2)
            .Select(r => { r.ReadChar(); r.ReadInteger(); r.ReadReal(); r.ReadRawString(6); r.ReadRawString(6); return r.ReadReal(); })
            .ToList();
        Assert.Equal(storedBalances.Count, entries.Count);

        // NIHUL.PAS never set a sign for 'K' (credit card), so it reused the previous one. Once, as the
        // first entry of a session, that sign was still 0 and a 345 charge did not change the balance.
        var mismatches = Enumerable.Range(0, entries.Count)
            .Where(i => Math.Abs(storedBalances[i] - (i == 0 ? 0 : storedBalances[i - 1])
                                 - (double)(entries[i].Balance - (i == 0 ? 0 : entries[i - 1].Balance))) > 0.01)
            .ToList();
        var bug = Assert.Single(mismatches);
        Assert.Equal('K', entries[bug].Type);
        Assert.Equal(345m, entries[bug].Amount);
        Assert.Equal(storedBalances[^1] - 345, (double)entries[^1].Balance, 1);
        Assert.Equal(new DateOnly(1987, 1, 1), entries[0].Date);
    }

    [Fact]
    public void Micro_directory_lists_the_saved_8085_programs()
    {
        var programs = LegacyImporter.ReadMicroPrograms(LegacyFolder.File("MICRO", "MCRNAME.DAT"))
            .ToDictionary(p => p.Name);

        Assert.Equal(0x2000, programs["RUN-LEFT"].StartAddress);
        Assert.Equal(0x3E, programs["RUN-LEFT"].Code[0]);   // MVI A,88
        Assert.Equal(0x2010, programs["STEPS"].StartAddress);
        Assert.DoesNotContain("ADD-2", programs.Keys);       // erased entry
    }
}
