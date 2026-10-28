namespace HighSchool.Web.Modules.Classics;

/// <summary>A step of the walk: "add" a cell to the path, or "back" to cut the path to <see cref="Length"/> cells.</summary>
public sealed record MazeEvent(string Kind, int X, int Y, int Length);

public sealed record MazeResult(IReadOnlyList<MazeEvent> Events, int Steps, int Total);

/// <summary>
/// MAZE.PAS: a random self-avoiding walk across a 70×20 field from the top-left corner to the
/// bottom-right one. Moves are biased right/down (11 right, 7 left, 5 down, 4 up out of 28);
/// when ten tries fail the walk is cut back to a random earlier step and the abandoned cells are freed.
/// STEP is the length of the final path and TOTAL the number of steps taken, as printed by the original.
/// </summary>
public static class MazeWalk
{
    public const int Width = 70;
    public const int Height = 20;
    private const int MaxIterations = 200_000;

    public static MazeResult Generate(int? seed = null)
    {
        var rnd = seed is { } s ? new Random(s) : new Random();
        while (true)
        {
            var result = TryGenerate(rnd);
            if (result is not null) return result;
        }
    }

    private static MazeResult? TryGenerate(Random rnd)
    {
        var visited = new bool[Width + 2, Height + 2];
        var path = new List<(int X, int Y)> { (1, 1) };
        var events = new List<MazeEvent> { new("add", 1, 1, 1) };
        int x = 1, y = 1, total = 0;

        while (!(x == Width && y == Height))
        {
            if (++total > MaxIterations) return null;
            visited[x, y] = true;

            int x1, y1, tries = 0;
            do
            {
                if (++tries > 1000) return null; // boxed in even after cutting back: start over
                if (tries == 11) // stuck: jump back a random distance (the original's "D = 11" branch)
                {
                    var end = path.Count;
                    var cut = rnd.Next(40) + 1;
                    if (end <= cut) { while (cut >= end) cut -= 6; }
                    else cut = end - cut;
                    cut = Math.Max(cut, 1);

                    for (var i = cut; i < end; i++) visited[path[i].X, path[i].Y] = false;
                    path.RemoveRange(cut, end - cut);
                    (x, y) = path[^1];
                    events.Add(new MazeEvent("back", x, y, cut));
                }

                (x1, y1) = (x, y);
                var a = rnd.Next(28) + 1;
                if (x1 == 1 || y1 == 1) a = rnd.Next(2) + 7;
                if (x1 == Width) a = rnd.Next(2) + 3;
                if (y1 == Height) a = rnd.Next(2) + 6;
                switch (a)
                {
                    case 1 or 2 or 7 or 9 or 11 or 12 or 16 or 18 or 19 or 25 or 28: x1++; break;
                    case 3 or 10 or 15 or 20 or 22 or 26 or 27: x1--; break;
                    case 4 or 5 or 8 or 13 or 24: y1++; break;
                    case 6 or 14 or 21 or 23: y1--; break;
                }
            } while (!(y1 is >= 1 and <= Height && x1 is >= 1 and <= Width && !visited[x1, y1]));

            (x, y) = (x1, y1);
            path.Add((x, y));
            events.Add(new MazeEvent("add", x, y, path.Count));
        }

        return new MazeResult(events, path.Count, total);
    }
}
