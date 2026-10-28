namespace HighSchool.Web.Modules.Romi;

public sealed record City(int Code, string Name, string AreaCode)
{
    public string Display => AreaCode.Length > 0 ? $"{Name} {AreaCode}" : Name;
}

/// <summary>
/// The CLIB constant from ROMI.PAS: 65 cities, each with its phone area code.
/// A store's CITY field is the 1-based index into this list, so the order must never change
/// (the original's comment: "add new cities at the end of the list").
/// </summary>
public static class RomiCities
{
    public static readonly IReadOnlyList<City> All =
    [
        new(1, "אבן יהודה", "053"),
        new(2, "אופקים", "057"),
        new(3, "אור יהודה", "03"),
        new(4, "אור עקיבא", "03"),
        new(5, "אילת", "059"),
        new(6, "אשדוד", "08"),
        new(7, "אשקלון", "051"),
        new(8, "באר שבע", "057"),
        new(9, "בית שאן", "06"),
        new(10, "בני ברק", "03"),
        new(11, "בת ים", "03"),
        new(12, "גבעתיים", "03"),
        new(13, "הרצליה", "052"),
        new(14, "חדרה", "06"),
        new(15, "חולון", "03"),
        new(16, "חיפה", "04"),
        new(17, "טבעון", "04"),
        new(18, "טבריה", "06"),
        new(19, "יבנה", "08"),
        new(20, "יקנעם", "04"),
        new(21, "ירושלים", "02"),
        new(22, "כפר סבא", "052"),
        new(23, "כפר תבור", "06"),
        new(24, "כרמיאל", "04"),
        new(25, "לוד", "08"),
        new(26, "נהריה", "04"),
        new(27, "נס ציונה", "08"),
        new(28, "נצרת", "06"),
        new(29, "נתניה", "05"),
        new(30, "סביון", "03"),
        new(31, "עכו", "04"),
        new(32, "עפולה", "06"),
        new(33, "פתח תקוה", "03"),
        new(34, "קרית אתא", "04"),
        new(35, "קרית ביאליק", "04"),
        new(36, "שום מקום", ""),
        new(37, "קרית מוצקין", "04"),
        new(38, "ראש העין", "03"),
        new(39, "ראשון לציון", "03"),
        new(40, "רחובות", "08"),
        new(41, "רמלה", "08"),
        new(42, "רמת אביב ג", "03"),
        new(43, "רמת אפעל", "03"),
        new(44, "רמת גן", "03"),
        new(45, "רמת השרון", "03"),
        new(46, "רמת ישי", "04"),
        new(47, "רמתיים-הוד השרון", "052"),
        new(48, "רעננה", "052"),
        new(49, "תל אביב", "03"),
        new(50, "קרית מלאכי", "057"),
        new(51, "גדרה", "08"),
        new(52, "קשרים", ""),
        new(53, "הגושרים", "06"),
        new(54, "יהוד", "03"),
        new(55, "מגדל העמק", "06"),
        new(56, "מנחמיה", "06"),
        new(57, "צפת", "06"),
        new(58, "חצור הגלילית", "06"),
        new(59, "ניר צבי", "08"),
        new(60, "קרית ים", "04"),
        new(61, "ערד", "057"),
        new(62, "זכרון יעקב", "04"),
        new(63, "טירת הכרמל", "04"),
        new(64, "קרית גת", "051"),
        new(65, "קרית אונו", "03"),
    ];

    public static City? Find(int code) => code >= 1 && code <= All.Count ? All[code - 1] : null;

    public static string NameOf(int code) => Find(code)?.Display ?? $"עיר {code}";
}
