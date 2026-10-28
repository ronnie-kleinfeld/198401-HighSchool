using HighSchool.Web.Modules.Classics;
using Microsoft.AspNetCore.Mvc;

namespace HighSchool.Web.Controllers;

public sealed record ThinkModel(PegSolitaire Game, int? SelectedX, int? SelectedY);

public sealed class TotoForm
{
    public int[] Home { get; set; } = Enumerable.Repeat(1, Toto.Matches).ToArray();
    public int[] Away { get; set; } = Enumerable.Repeat(1, Toto.Matches).ToArray();
    public IReadOnlyList<TotoMatch>? Result { get; set; }
}

public sealed class CodeForm
{
    public string Text { get; set; } = "";
    public bool Encrypt { get; set; } = true;
    public string? Result { get; set; }
}

public sealed class PowerForm
{
    public int Base { get; set; } = 2;
    public int Exponent { get; set; } = 10;
    public PowerResult? Result { get; set; }
    public string? Error { get; set; }
}

/// <summary>The small programs in PASCAL\PROGRAMS (and CUBIA.PAS from MICRO).</summary>
public class ClassicsController : Controller
{
    public IActionResult Index() => View();

    // THINK.PAS – peg solitaire. The whole game is the move list in the query string.
    public IActionResult Think(string? moves, int? x, int? y, char? dir)
    {
        var game = PegSolitaire.Replay(moves);
        if (x is { } px && y is { } py && dir is { } d && game.TryMove(new PegMove(px, py, d)))
            return RedirectToAction(nameof(Think), new { moves = game.Serialize() });
        return View(new ThinkModel(game, x, y));
    }

    // MAZE.PAS
    public IActionResult Maze() => View();

    [HttpGet]
    public IActionResult MazeData(int? seed) => Json(MazeWalk.Generate(seed));

    // TT-NEW.PAS
    public IActionResult Toto() => View(new TotoForm());

    [HttpPost]
    public IActionResult Toto(TotoForm form)
    {
        if (form.Home.Length != Modules.Classics.Toto.Matches || form.Away.Length != Modules.Classics.Toto.Matches)
            return View(new TotoForm());
        form.Result = Modules.Classics.Toto.Fill(form.Home.Zip(form.Away).ToList());
        return View(form);
    }

    // CODE.PAS
    public IActionResult Code() => View(new CodeForm());

    [HttpPost]
    public IActionResult Code(CodeForm form)
    {
        form.Result = Caesar.Apply(form.Text ?? "", form.Encrypt);
        return View(form);
    }

    // HEZKA.PAS
    public IActionResult Hezka() => View(new PowerForm());

    [HttpPost]
    public IActionResult Hezka(PowerForm form)
    {
        try { form.Result = RepeatedAdditionPower.Compute(form.Base, form.Exponent); }
        catch (ArgumentOutOfRangeException) { form.Error = $"|basis| ≤ {RepeatedAdditionPower.MaxBase}, |maarich| ≤ {RepeatedAdditionPower.MaxExponent}"; }
        return View(form);
    }

    // CUBIA.PAS
    public IActionResult Cubia() => View();

    [HttpGet]
    public IActionResult CubiaData(int rows = 400) => Json(Canyon.Rows(Math.Clamp(rows, 20, 2000)));
}
