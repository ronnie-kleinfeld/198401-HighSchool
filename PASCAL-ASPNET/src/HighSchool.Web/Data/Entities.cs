using System.ComponentModel.DataAnnotations;

namespace HighSchool.Web.Data;

// ---- ROMI: store directory (ROMI.PAS, record MAIN in ROMISTOR.DAT) ----
public class Store
{
    public int Id { get; set; }

    [Range(1, 65, ErrorMessage = "קוד עיר בין 1 ל-65")]
    [Display(Name = "עיר")]
    public int CityCode { get; set; }

    [Required(ErrorMessage = "יש להקיש שם חנות"), StringLength(20)]
    [Display(Name = "חנות")]
    public string StoreName { get; set; } = "";

    [StringLength(30)]
    [Display(Name = "כתובת")]
    public string Address { get; set; } = "";

    [StringLength(15)]
    [Display(Name = "שם")]
    public string ContactName { get; set; } = "";

    [StringLength(12), RegularExpression(@"^[0-9\-]*$", ErrorMessage = "ספרות ומקף בלבד")]
    [Display(Name = "טלפון עבודה")]
    public string WorkPhone { get; set; } = "";

    [StringLength(12), RegularExpression(@"^[0-9\-]*$", ErrorMessage = "ספרות ומקף בלבד")]
    [Display(Name = "טלפון בית")]
    public string HomePhone { get; set; } = "";

    [StringLength(12), RegularExpression(@"^[0-9\-]*$", ErrorMessage = "ספרות ומקף בלבד")]
    [Display(Name = "טלפון נוסף")]
    public string ExtraPhone { get; set; } = "";
}

// ---- IQ: general-knowledge question bank (IQ*.PAS, record YEDA in YEDA.DAT) ----
public class Question
{
    public int Id { get; set; }

    [Required(ErrorMessage = "יש להקיש נושא"), StringLength(20)]
    [Display(Name = "נושא")]
    public string Subject { get; set; } = "";

    [Required(ErrorMessage = "יש להקיש מושג"), StringLength(20)]
    [Display(Name = "מושג")]
    public string Term { get; set; } = "";

    [Required(ErrorMessage = "יש להקיש פירוש"), StringLength(67)]
    [Display(Name = "פירוש")]
    public string Definition { get; set; } = "";
}

// ---- NIHUL: bank account ledger (NIHUL.PAS, record PEOLOT in NIHUL.DAT) ----
public class LedgerEntry
{
    public int Id { get; set; }

    /// <summary>Transaction type letter A..O, see <see cref="HighSchool.Web.Modules.Nihul.TransactionTypes"/>.</summary>
    public char Type { get; set; }

    /// <summary>Optional reference code (check number etc.); the original showed 0 as "---".</summary>
    public int? Code { get; set; }

    public decimal Amount { get; set; }
    public DateOnly Date { get; set; }
    public DateOnly ValueDate { get; set; }

    /// <summary>Running balance after this entry, as the original stored it.</summary>
    public decimal Balance { get; set; }
}

// ---- MSD: course timetable planner (MSD.PAS constants Course_ID / Course_data) ----
public class Course
{
    public int Id { get; set; }
    [Required, StringLength(16)] public string Name { get; set; } = "";
    /// <summary>The '+'/'-' flag in Course_ID: inactive courses are not scheduled.</summary>
    public bool IsActive { get; set; } = true;
    public List<CourseSection> Sections { get; set; } = [];
}

public class CourseSection
{
    public int Id { get; set; }
    public int CourseId { get; set; }
    public Course? Course { get; set; }
    public int GroupNumber { get; set; }
    /// <summary>1 = Sunday (א) … 7 = Saturday.</summary>
    public int Day { get; set; }
    public TimeOnly Start { get; set; }
    /// <summary>Exclusive end time (the original stored the last minute, e.g. 13:29 → 13:30).</summary>
    public TimeOnly End { get; set; }
    [StringLength(3)] public string Room { get; set; } = "";
    [StringLength(10)] public string Lecturer { get; set; } = "";
    /// <summary>The status column: '-' sections are closed and never chosen.</summary>
    public bool IsActive { get; set; } = true;
}

/// <summary>Times the student is not available (Clear_Main_MSD in the original).</summary>
public class BlockedSlot
{
    public int Id { get; set; }
    public int Day { get; set; }
    public TimeOnly From { get; set; }
    public TimeOnly To { get; set; }
}

// ---- MICRO: programs saved from the 8085 simulator (MCRNAME.DAT + <name>.DAT) ----
public class MicroProgram
{
    public int Id { get; set; }
    [Required, StringLength(8)] public string Name { get; set; } = "";
    public int StartAddress { get; set; }
    public byte[] Code { get; set; } = [];
}
