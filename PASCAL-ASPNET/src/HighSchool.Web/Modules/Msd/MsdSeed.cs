using HighSchool.Web.Data;

namespace HighSchool.Web.Modules.Msd;

/// <summary>
/// The Course_ID / Course_data constants of MSD_WORK\MSD.PAS. Each Course_data row was a fixed-width string:
/// <code>
///  cols 1-2  course id      cols 3-6   group number   col 7  day (1 = Sunday)
///  cols 8-11 start HHMM     cols 12-15 last minute    cols 16-18 room
///  cols 19-28 lecturer      col 29     '+' open / '-' closed
/// </code>
/// </summary>
public static class MsdSeed
{
    private static readonly string[] CourseNames =
    [
        "עקרונות בהתנהגות", "שיווק א", "סטטיסטיקה א", "כתיבה", "מתמטיקה א",
        "מיקרו", "אנגלית", "ת-מיקרו", "ת-חשבונאות", "ת-סטטיסטיקה",
    ];

    // The numeric part is copied verbatim from Course_data; the lecturer is the name converted to logical Hebrew.
    private static readonly (string Row, string Lecturer, char Status)[] Rows =
    [
        ("010001212001329109", "גלנטה", '+'),
        ("010002410001129109", "גלנטה", '+'),
        ("010003412301359109", "גלנטה", '+'),
        ("010004108000929109", "גלנטה", '+'),
        ("010005108001244109", "נורית", '+'),
        ("020006312001329109", "שפירא", '+'),
        ("020007610001129109", "בורשטיין", '+'),
        ("020008108000929109", "בורשטיין", '+'),
        ("030009208000929109", "בליצקי", '+'),
        ("030010210001129109", "בליצקי", '+'),
        ("030011108000929109", "סטטי", '+'),
        ("030012110001129109", "שולמן", '+'),
        ("040013408000929109", "תורגמן", '+'),
        ("040014110001129109", "תורגמן", '+'),
        ("040015109001454109", "לוגימן", '+'),
        ("050016210001214109", "פלמון", '+'),
        ("050017410001214109", "דנון", '+'),
        ("050018412001414109", "דנון", '+'),
        ("060019212301359109", "וייס", '+'),
        ("060020410001129109", "וייס", '+'),
        ("060021408000929109", "נוימן", '+'),
        ("060022412301359109", "נוימן", '+'),
        ("070023317302059204", "דויד", '+'),
        ("080024214001459204", "קוני", '+'),
        ("090025414001459102", "אילן", '+'),
        ("090026415001559102", "אילן", '+'),
        ("100027215001559204", "סטטי", '+'),
    ];

    public static List<Course> Courses()
    {
        var courses = CourseNames.Select((name, i) => new Course { Id = i + 1, Name = name, IsActive = true }).ToList();
        foreach (var (row, lecturer, status) in Rows)
            courses[int.Parse(row[..2]) - 1].Sections.Add(ParseRow(row, lecturer, status));
        return courses;
    }

    public static CourseSection ParseRow(string row, string lecturer, char status) => new()
    {
        GroupNumber = int.Parse(row[2..6]),
        Day = row[6] - '0',
        Start = new TimeOnly(int.Parse(row[7..9]), int.Parse(row[9..11])),
        End = new TimeOnly(int.Parse(row[11..13]), int.Parse(row[13..15])).AddMinutes(1),
        Room = row[15..18],
        Lecturer = lecturer,
        IsActive = status == '+',
    };

    /// <summary>Clear_Main_MSD: Sunday and Thursday are fully taken, Tuesday until 17:00.</summary>
    public static List<BlockedSlot> BlockedSlots() =>
    [
        new() { Day = 1, From = new TimeOnly(8, 0), To = new TimeOnly(23, 0) },
        new() { Day = 3, From = new TimeOnly(8, 0), To = new TimeOnly(17, 0) },
        new() { Day = 5, From = new TimeOnly(8, 0), To = new TimeOnly(23, 0) },
    ];
}
