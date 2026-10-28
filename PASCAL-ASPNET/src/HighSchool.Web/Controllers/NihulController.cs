using System.ComponentModel.DataAnnotations;
using HighSchool.Web.Data;
using HighSchool.Web.Modules.Nihul;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HighSchool.Web.Controllers;

public sealed class LedgerEntryForm
{
    public char Type { get; set; }

    [Display(Name = "קוד"), Range(0, 32767)]
    public int? Code { get; set; }

    [Display(Name = "סכום"), Required(ErrorMessage = "יש להקיש סכום"), Range(0.1, 99999.9, ErrorMessage = "סכום בין 0.1 ל-99999.9")]
    public decimal? Amount { get; set; }

    [Display(Name = "תאריך")]
    public DateOnly Date { get; set; } = DateOnly.FromDateTime(DateTime.Today);

    [Display(Name = "תאריך ערך")]
    public DateOnly ValueDate { get; set; } = DateOnly.FromDateTime(DateTime.Today);
}

public sealed record LedgerViewModel(IReadOnlyList<LedgerEntry> Entries, decimal Balance, char? Filter);

/// <summary>NIHUL.COM – bank account bookkeeping (1987).</summary>
public class NihulController(AppDbContext db) : Controller
{
    public async Task<IActionResult> Index()
    {
        var recent = await db.Ledger.OrderByDescending(e => e.Id).Take(5).ToListAsync();
        return View(new LedgerViewModel(recent, recent.FirstOrDefault()?.Balance ?? 0, null));
    }

    /// <summary>Menu A..O: one transaction of the chosen type (procedure PAGE).</summary>
    public async Task<IActionResult> Create(char type)
    {
        if (TransactionTypes.Find(type) is null) return RedirectToAction(nameof(Index));
        ViewData["Previous"] = await db.Ledger.OrderByDescending(e => e.Id).FirstOrDefaultAsync();
        return View(new LedgerEntryForm { Type = char.ToUpperInvariant(type) });
    }

    [HttpPost]
    public async Task<IActionResult> Create(LedgerEntryForm form, bool another)
    {
        var type = TransactionTypes.Find(form.Type);
        if (type is null) return RedirectToAction(nameof(Index));
        var previous = await db.Ledger.OrderByDescending(e => e.Id).FirstOrDefaultAsync();
        if (!ModelState.IsValid)
        {
            ViewData["Previous"] = previous;
            return View(form);
        }

        var amount = Math.Round(form.Amount!.Value, 1);
        var entry = new LedgerEntry
        {
            Type = type.Letter,
            Code = form.Code is 0 ? null : form.Code,
            Amount = amount,
            Date = form.Date,
            ValueDate = form.ValueDate,
            Balance = (previous?.Balance ?? 0) + type.Sign * amount,
        };
        db.Ledger.Add(entry);
        await db.SaveChangesAsync();
        TempData["Message"] = $"{type.Name}: {amount:N1} · יתרה {entry.Balance:N1}";
        return another ? RedirectToAction(nameof(Create), new { type = type.Letter }) : RedirectToAction(nameof(Index));
    }

    /// <summary>P – יתרה: the statement, for one type or Z = all.</summary>
    public async Task<IActionResult> Report(char? type)
    {
        var filter = type is { } t && TransactionTypes.Find(t) is { } found ? found.Letter : (char?)null;
        var query = db.Ledger.AsQueryable();
        if (filter is { } f) query = query.Where(e => e.Type == f);
        var entries = await query.OrderBy(e => e.Id).ToListAsync();
        var balance = await db.Ledger.OrderByDescending(e => e.Id).Select(e => e.Balance).FirstOrDefaultAsync();
        return View(new LedgerViewModel(entries, balance, filter));
    }
}
