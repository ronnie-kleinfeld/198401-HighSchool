using HighSchool.Web.Data;
using HighSchool.Web.Modules.Romi;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HighSchool.Web.Controllers;

public sealed record StoreListModel(IReadOnlyList<Store> Stores, string? Query, int? City, int Page, int Pages, int Total);

public sealed record StoreReportModel(string Kind, string Title, IReadOnlyList<IGrouping<int, Store>> Groups, int? City);

/// <summary>ROMI.COM – the store directory of רומי תכשיטים בע"מ.</summary>
public class RomiController(AppDbContext db) : Controller
{
    private const int PageSize = 25;

    /// <summary>Main menu plus the store list (menu 3, "שינוי נתונים", started with a search by store name).</summary>
    public async Task<IActionResult> Index(string? q, int? city, int page = 1)
    {
        var query = db.Stores.AsQueryable();
        if (!string.IsNullOrWhiteSpace(q))
            query = query.Where(s => s.StoreName.Contains(q) || s.ContactName.Contains(q) || s.Address.Contains(q));
        if (city is not null) query = query.Where(s => s.CityCode == city);

        var total = await query.CountAsync();
        var pages = Math.Max(1, (total + PageSize - 1) / PageSize);
        page = Math.Clamp(page, 1, pages);
        var stores = await query.OrderBy(s => s.CityCode).ThenBy(s => s.StoreName)
            .Skip((page - 1) * PageSize).Take(PageSize).ToListAsync();
        return View(new StoreListModel(stores, q, city, page, pages, total));
    }

    // ---- 1. הכנסת חנות לאלפון ----

    public IActionResult Create(int? city) => View("Edit", new Store { CityCode = city ?? 1 });

    [HttpPost]
    public async Task<IActionResult> Create(Store store, bool another)
    {
        if (!ModelState.IsValid) return View("Edit", store);
        Normalize(store);
        db.Stores.Add(store);
        await db.SaveChangesAsync();
        TempData["Message"] = $"החנות \"{store.StoreName}\" נוספה לאלפון ({RomiCities.NameOf(store.CityCode)})";
        return another ? RedirectToAction(nameof(Create), new { city = store.CityCode }) : RedirectToAction(nameof(Index));
    }

    // ---- 3. שינוי נתונים: edit, delete, and +/- paging through the file ----

    public async Task<IActionResult> Edit(int id)
    {
        var store = await db.Stores.FindAsync(id);
        if (store is null) return NotFound();
        ViewData["Previous"] = await db.Stores.Where(s => s.Id < id).OrderByDescending(s => s.Id).Select(s => (int?)s.Id).FirstOrDefaultAsync();
        ViewData["Next"] = await db.Stores.Where(s => s.Id > id).OrderBy(s => s.Id).Select(s => (int?)s.Id).FirstOrDefaultAsync();
        return View(store);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(int id, Store store)
    {
        if (id != store.Id) return BadRequest();
        if (!ModelState.IsValid) return View(store);
        Normalize(store);
        db.Update(store);
        await db.SaveChangesAsync();
        TempData["Message"] = "השינויים נשמרו";
        return RedirectToAction(nameof(Edit), new { id });
    }

    [HttpPost]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await db.Stores.Where(s => s.Id == id).ExecuteDeleteAsync();
        TempData["Message"] = deleted > 0 ? "החנות נמחקה" : "החנות לא נמצאה";
        return RedirectToAction(nameof(Index));
    }

    // ---- 2. הדפסת נתונים and 7. הדפסת קובץ לא ממוין ----

    public IActionResult Reports() => View();

    /// <param name="kind">
    /// directory = 1. אלפון כל הערים · city = 2. אלפון לכל עיר בנפרד · country = 3. חנויות בכל הארץ א-ב ·
    /// cities = 4. רשימת ערים · unsorted = 7. כל החנויות לא ממוין
    /// </param>
    public async Task<IActionResult> Report(string kind, int? city)
    {
        if (kind == "cities") return View("Cities", RomiCities.All.OrderBy(c => c.Name, StringComparer.Ordinal).ToList());

        var stores = await db.Stores.ToListAsync();
        var (title, groups) = kind switch
        {
            "directory" => ("אלפון כל הערים", ByCity(stores)),
            "city" when RomiCities.Find(city ?? 0) is { } c => ($"רשימת חנויות בעיר - {c.Display}", ByCity(stores.Where(s => s.CityCode == c.Code))),
            "country" => ("רשימת חנויות בארץ", OneGroup(Sorted(stores))),
            "unsorted" => ("כל החנויות - קובץ לא ממוין", OneGroup(stores.OrderBy(s => s.Id))),
            _ => (null, null),
        };
        if (title is null) return RedirectToAction(nameof(Reports));
        return View(new StoreReportModel(kind, title, groups!, city));
    }

    private static IOrderedEnumerable<Store> Sorted(IEnumerable<Store> stores) =>
        stores.OrderBy(s => s.CityCode).ThenBy(s => s.StoreName, StringComparer.Ordinal);

    private static List<IGrouping<int, Store>> ByCity(IEnumerable<Store> stores) =>
        Sorted(stores).GroupBy(s => s.CityCode).ToList();

    private static List<IGrouping<int, Store>> OneGroup(IEnumerable<Store> stores) =>
        stores.GroupBy(_ => 0).ToList();

    private static void Normalize(Store s)
    {
        s.StoreName = s.StoreName.Trim();
        s.Address = s.Address?.Trim() ?? "";
        s.ContactName = s.ContactName?.Trim() ?? "";
        s.WorkPhone = s.WorkPhone?.Trim() ?? "";
        s.HomePhone = s.HomePhone?.Trim() ?? "";
        s.ExtraPhone = s.ExtraPhone?.Trim() ?? "";
    }
}
