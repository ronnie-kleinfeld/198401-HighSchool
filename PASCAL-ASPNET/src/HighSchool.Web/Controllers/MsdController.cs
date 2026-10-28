using HighSchool.Web.Data;
using HighSchool.Web.Modules.Msd;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HighSchool.Web.Controllers;

public sealed record MsdIndexModel(IReadOnlyList<Course> Courses, IReadOnlyList<BlockedSlot> Blocked);

public sealed record MsdCheckModel(
    IReadOnlyList<Course> Courses, int[] Selected, TimetableResult Result, int Index, IReadOnlyList<BlockedSlot> Blocked);

/// <summary>MSD.EXE – "MSD Check Up": find clash-free timetables (מערכת שעות).</summary>
public class MsdController(AppDbContext db) : Controller
{
    public static readonly string[] DayNames = ["", "א", "ב", "ג", "ד", "ה", "ו", "ש"];

    /// <summary>The "Data" and "Course" commands: the list of courses and their sections.</summary>
    public async Task<IActionResult> Index() =>
        View(new MsdIndexModel(await LoadCourses(), await db.BlockedSlots.OrderBy(b => b.Day).ThenBy(b => b.From).ToListAsync()));

    [HttpPost]
    public async Task<IActionResult> ToggleCourse(int id)
    {
        if (await db.Courses.FindAsync(id) is { } c) { c.IsActive = !c.IsActive; await db.SaveChangesAsync(); }
        return RedirectToAction(nameof(Index));
    }

    [HttpPost]
    public async Task<IActionResult> ToggleSection(int id)
    {
        var section = await db.CourseSections.FindAsync(id);
        if (section is null) return RedirectToAction(nameof(Index));
        section.IsActive = !section.IsActive;
        await db.SaveChangesAsync();
        return RedirectToAction(nameof(Index), null, $"course-{section.CourseId}");
    }

    [HttpPost]
    public async Task<IActionResult> AddBlocked(int day, TimeOnly from, TimeOnly to)
    {
        if (day is >= 1 and <= 7 && from < to)
        {
            db.BlockedSlots.Add(new BlockedSlot { Day = day, From = from, To = to });
            await db.SaveChangesAsync();
        }
        return RedirectToAction(nameof(Index), null, "blocked");
    }

    [HttpPost]
    public async Task<IActionResult> DeleteBlocked(int id)
    {
        await db.BlockedSlots.Where(b => b.Id == id).ExecuteDeleteAsync();
        return RedirectToAction(nameof(Index), null, "blocked");
    }

    /// <summary>The "Check" command followed by "Look": run the check and browse the good timetables.</summary>
    public async Task<IActionResult> Check(int[] courses, int n = 1)
    {
        var all = await LoadCourses();
        var selected = courses.Length > 0 ? courses : all.Where(c => c.IsActive).Take(5).Select(c => c.Id).ToArray();
        var chosen = all.Where(c => selected.Contains(c.Id)).ToList();
        var blocked = await db.BlockedSlots.ToListAsync();
        var result = TimetableSolver.Solve(chosen, blocked);
        var index = result.Timetables.Count == 0 ? 0 : Math.Clamp(n, 1, result.Timetables.Count);
        return View(new MsdCheckModel(all, selected, result, index, blocked));
    }

    private Task<List<Course>> LoadCourses() =>
        db.Courses.Include(c => c.Sections.OrderBy(s => s.GroupNumber)).OrderBy(c => c.Id).ToListAsync();
}
