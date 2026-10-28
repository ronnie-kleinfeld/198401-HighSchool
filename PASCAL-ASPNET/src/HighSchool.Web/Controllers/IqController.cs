using System.Text.Json;
using HighSchool.Web.Data;
using HighSchool.Web.Modules.Iq;
using QuizState = HighSchool.Web.Modules.Iq.Quiz;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HighSchool.Web.Controllers;

public sealed record QuestionListModel(IReadOnlyList<Question> Questions, string? Query, string? Subject, IReadOnlyList<string> Subjects);

/// <summary>IQS.COM and its programs: IQWYEDA (drill), IQEYEDA (question editor), IQEPAINT (drawing), READ (listing).</summary>
public class IqController(AppDbContext db) : Controller
{
    private const string QuizKey = "iq-quiz";

    public async Task<IActionResult> Index()
    {
        ViewData["Count"] = await db.Questions.CountAsync();
        return View();
    }

    // ---- IQWYEDA: תרגול ידע כללי ----

    [HttpPost]
    public async Task<IActionResult> Start()
    {
        var bank = await db.Questions.ToListAsync();
        if (bank.Count < QuizState.MinimumQuestions)
        {
            TempData["Message"] = $"אין מספיק נתונים בקובץ - דרושות לפחות {QuizState.MinimumQuestions} שאלות";
            return RedirectToAction(nameof(Index));
        }
        SaveQuiz(QuizState.Create(bank));
        return RedirectToAction(nameof(Quiz));
    }

    public IActionResult Quiz()
    {
        var quiz = LoadQuiz();
        return quiz is null ? RedirectToAction(nameof(Index)) : View(quiz);
    }

    [HttpPost]
    public IActionResult Answer(int option)
    {
        var quiz = LoadQuiz();
        if (quiz is null) return RedirectToAction(nameof(Index));
        quiz.Answer(option);
        SaveQuiz(quiz);
        return RedirectToAction(nameof(Quiz));
    }

    [HttpPost]
    public IActionResult Next()
    {
        var quiz = LoadQuiz();
        if (quiz is null) return RedirectToAction(nameof(Index));
        quiz.Next();
        SaveQuiz(quiz);
        return RedirectToAction(nameof(Quiz));
    }

    [HttpPost]
    public IActionResult Stop()
    {
        HttpContext.Session.Remove(QuizKey);
        return RedirectToAction(nameof(Index));
    }

    private QuizState? LoadQuiz() =>
        HttpContext.Session.GetString(QuizKey) is { } json ? JsonSerializer.Deserialize<QuizState>(json) : null;

    private void SaveQuiz(QuizState quiz) => HttpContext.Session.SetString(QuizKey, JsonSerializer.Serialize(quiz));

    // ---- IQEYEDA: הכנסת / שינוי / מחיקת מידע ----

    public async Task<IActionResult> Questions(string? q, string? subject)
    {
        var query = db.Questions.AsQueryable();
        if (!string.IsNullOrWhiteSpace(q)) query = query.Where(x => x.Term.Contains(q) || x.Definition.Contains(q));
        if (!string.IsNullOrWhiteSpace(subject)) query = query.Where(x => x.Subject == subject);
        var subjects = await db.Questions.Select(x => x.Subject).Distinct().OrderBy(s => s).ToListAsync();
        return View(new QuestionListModel(await query.OrderBy(x => x.Id).ToListAsync(), q, subject, subjects));
    }

    public async Task<IActionResult> Create() =>
        View("Edit", new Question { Subject = await db.Questions.OrderByDescending(x => x.Id).Select(x => x.Subject).FirstOrDefaultAsync() ?? "" });

    [HttpPost]
    public async Task<IActionResult> Create(Question question)
    {
        if (!ModelState.IsValid) return View("Edit", question);
        db.Questions.Add(question);
        await db.SaveChangesAsync();
        TempData["Message"] = $"\"{question.Term}\" נוסף לקובץ";
        return RedirectToAction(nameof(Create));
    }

    public async Task<IActionResult> Edit(int id) =>
        await db.Questions.FindAsync(id) is { } q ? View(q) : NotFound();

    [HttpPost]
    public async Task<IActionResult> Edit(int id, Question question)
    {
        if (id != question.Id) return BadRequest();
        if (!ModelState.IsValid) return View(question);
        db.Update(question);
        await db.SaveChangesAsync();
        TempData["Message"] = "השינויים נשמרו";
        return RedirectToAction(nameof(Questions));
    }

    [HttpPost]
    public async Task<IActionResult> Delete(int id)
    {
        await db.Questions.Where(x => x.Id == id).ExecuteDeleteAsync();
        TempData["Message"] = "השאלה נמחקה";
        return RedirectToAction(nameof(Questions));
    }

    // ---- IQEPAINT: ציור במקשי החצים ----

    public IActionResult Paint() => View();
}
