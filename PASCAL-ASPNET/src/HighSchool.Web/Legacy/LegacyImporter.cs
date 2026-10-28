using System.Globalization;
using HighSchool.Web.Data;
using HighSchool.Web.Modules.Msd;
using HighSchool.Web.Modules.Nihul;
using Microsoft.EntityFrameworkCore;

namespace HighSchool.Web.Legacy;

/// <summary>
/// One-time import of the original 1987-88 data files into the database.
/// Each table is filled only while it is still empty, so running it again is harmless.
/// </summary>
public sealed class LegacyImporter(AppDbContext db, ILogger<LegacyImporter> log)
{
    // Record sizes of the Turbo Pascal records (see the type declarations in each .PAS file).
    public const int StoreRecordSize = 2 + 21 + 31 + 16 + 13 * 3 + 1;  // ROMI.PAS     MAIN
    public const int QuestionRecordSize = 21 + 21 + 68 + 1;             // IQEYEDA.PAS  YEDA
    public const int LedgerRecordSize = 1 + 2 + 6 + 7 + 7 + 6;          // NIHUL.PAS    PEOLOT
    public const int MicroDirRecordSize = 9 + 2 + 2 + 1;                // MICRO-A.PAS  MAIN

    public async Task ImportAsync(string legacyRoot)
    {
        if (!await db.Courses.AnyAsync())
        {
            db.Courses.AddRange(MsdSeed.Courses());
            db.BlockedSlots.AddRange(MsdSeed.BlockedSlots());
            await db.SaveChangesAsync();
        }

        if (!Directory.Exists(legacyRoot))
        {
            log.LogWarning("Legacy data folder {Path} not found - starting with empty tables", legacyRoot);
            return;
        }

        await ImportIfEmpty(db.Stores, Path.Combine(legacyRoot, "ROMI", "ROMISTOR.DAT"), ReadStores);
        await ImportIfEmpty(db.Questions, Path.Combine(legacyRoot, "IQ", "YEDA.DAT"), ReadQuestions);
        await ImportIfEmpty(db.Ledger, Path.Combine(legacyRoot, "PROGRAMS", "NIHUL.DAT"), ReadLedger);
        await ImportIfEmpty(db.MicroPrograms, Path.Combine(legacyRoot, "MICRO", "MCRNAME.DAT"), ReadMicroPrograms);
    }

    private async Task ImportIfEmpty<T>(DbSet<T> set, string file, Func<string, IEnumerable<T>> read) where T : class
    {
        if (await set.AnyAsync() || !File.Exists(file)) return;
        var rows = read(file).ToList();
        set.AddRange(rows);
        await db.SaveChangesAsync();
        log.LogInformation("Imported {Count} {Type} rows from {File}", rows.Count, typeof(T).Name, file);
    }

    public static IEnumerable<Store> ReadStores(string file)
    {
        foreach (var r in TurboPascalRecord.ReadAll(File.ReadAllBytes(file), StoreRecordSize))
        {
            var store = new Store
            {
                CityCode = r.ReadInteger(),
                StoreName = r.ReadString(20),
                Address = r.ReadString(30),
                ContactName = r.ReadString(15),
                WorkPhone = r.ReadString(12),
                HomePhone = r.ReadString(12),
                ExtraPhone = r.ReadString(12),
            };
            if (r.ReadBoolean()) yield return store; // EXE = false marks an erased slot
        }
    }

    public static IEnumerable<Question> ReadQuestions(string file)
    {
        foreach (var r in TurboPascalRecord.ReadAll(File.ReadAllBytes(file), QuestionRecordSize))
        {
            var q = new Question { Subject = r.ReadString(20), Term = r.ReadString(20), Definition = r.ReadString(67) };
            if (r.ReadBoolean()) yield return q; // KOD = false marks a deleted question
        }
    }

    public static IEnumerable<LedgerEntry> ReadLedger(string file)
    {
        // Record 0 is never written by NIHUL (OPEN_FILE seeks straight to 1) and record 1 is the empty opening row.
        var balance = 0m;
        foreach (var r in TurboPascalRecord.ReadAll(File.ReadAllBytes(file), LedgerRecordSize).Skip(2))
        {
            var letter = r.ReadChar();
            var code = r.ReadInteger();
            var amount = (decimal)Math.Round(r.ReadReal(), 2);
            var date = ParseDate(r.ReadRawString(6));
            var valueDate = ParseDate(r.ReadRawString(6));
            if (TransactionTypes.Find(letter) is not { } type) continue;

            balance += type.Sign * amount;
            yield return new LedgerEntry
            {
                Type = type.Letter,
                Code = code == 0 ? null : code,
                Amount = amount,
                Date = date,
                ValueDate = valueDate,
                Balance = balance,
            };
        }
    }

    /// <summary>NIHUL stored dates as DDMMYY text; all entries are from the 1980s.</summary>
    public static DateOnly ParseDate(string ddmmyy) =>
        DateOnly.TryParseExact(ddmmyy, "ddMMyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out var d)
            ? (d.Year > 2050 ? d.AddYears(-100) : d.Year < 1950 ? d.AddYears(100) : d)
            : new DateOnly(1987, 1, 1);

    public static IEnumerable<MicroProgram> ReadMicroPrograms(string directoryFile)
    {
        var folder = Path.GetDirectoryName(directoryFile)!;
        var programs = new Dictionary<string, MicroProgram>(StringComparer.OrdinalIgnoreCase);

        foreach (var r in TurboPascalRecord.ReadAll(File.ReadAllBytes(directoryFile), MicroDirRecordSize))
        {
            var name = r.ReadRawString(8).Trim();
            var start = (ushort)r.ReadInteger();
            r.ReadInteger(); // RANGE: not reliable in the surviving file, the program file length is used instead
            var active = r.ReadBoolean();
            var codeFile = Path.Combine(folder, name + ".DAT");
            if (!active || name.Length == 0 || !File.Exists(codeFile)) continue;

            // Later directory entries replace earlier ones with the same name, like SAVE overwriting.
            programs[name] = new MicroProgram { Name = name, StartAddress = start, Code = File.ReadAllBytes(codeFile) };
        }
        return programs.Values;
    }
}
