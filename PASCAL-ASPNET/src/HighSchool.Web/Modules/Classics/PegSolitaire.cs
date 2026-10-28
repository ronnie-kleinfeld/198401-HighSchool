namespace HighSchool.Web.Modules.Classics;

public sealed record PegMove(int X, int Y, char Direction)
{
    public override string ToString() => $"{X},{Y},{Direction}";
}

/// <summary>
/// THINK.PAS: English peg solitaire on the 33-hole cross board, center empty.
/// Moves are entered as a peg plus a direction letter, as in the original:
/// W = up, Z = down, A = left, S = right. The game is the list of moves, so "go back" (the '-' key)
/// simply replays all but the last one.
/// </summary>
public sealed class PegSolitaire
{
    public const int Size = 7;
    private readonly bool?[,] _cells = new bool?[Size + 1, Size + 1]; // null = not a hole, true = peg

    public List<PegMove> Moves { get; } = [];

    public PegSolitaire()
    {
        for (var x = 1; x <= Size; x++)
            for (var y = 1; y <= Size; y++)
                if (IsHole(x, y)) _cells[x, y] = !(x == 4 && y == 4);
    }

    public static bool IsHole(int x, int y) =>
        x is >= 1 and <= Size && y is >= 1 and <= Size && (x is >= 3 and <= 5 || y is >= 3 and <= 5);

    public bool? this[int x, int y] => IsHole(x, y) ? _cells[x, y] : null;

    public int PegsLeft => Enumerable.Range(1, Size).Sum(x => Enumerable.Range(1, Size).Count(y => _cells[x, y] == true));

    public static (int Dx, int Dy) Delta(char direction) => char.ToUpperInvariant(direction) switch
    {
        'W' => (0, -1),
        'Z' => (0, 1),
        'A' => (-1, 0),
        'S' => (1, 0),
        _ => (0, 0)
    };

    public bool CanMove(PegMove m)
    {
        var (dx, dy) = Delta(m.Direction);
        if (dx == 0 && dy == 0) return false;
        return this[m.X, m.Y] == true && this[m.X + dx, m.Y + dy] == true && this[m.X + 2 * dx, m.Y + 2 * dy] == false;
    }

    public IEnumerable<char> LegalDirections(int x, int y) =>
        "WZAS".Where(d => CanMove(new PegMove(x, y, d)));

    public bool AnyMovesLeft() =>
        Enumerable.Range(1, Size).Any(x => Enumerable.Range(1, Size).Any(y => LegalDirections(x, y).Any()));

    public bool TryMove(PegMove m)
    {
        if (!CanMove(m)) return false;
        var (dx, dy) = Delta(m.Direction);
        _cells[m.X, m.Y] = false;
        _cells[m.X + dx, m.Y + dy] = false;
        _cells[m.X + 2 * dx, m.Y + 2 * dy] = true;
        Moves.Add(m with { Direction = char.ToUpperInvariant(m.Direction) });
        return true;
    }

    public string Serialize() => string.Join(';', Moves);

    /// <summary>Rebuilds a game from its move list, skipping anything that is not legal.</summary>
    public static PegSolitaire Replay(string? moves, int? take = null)
    {
        var game = new PegSolitaire();
        var parsed = (moves ?? "").Split(';', StringSplitOptions.RemoveEmptyEntries)
            .Select(Parse).OfType<PegMove>();
        foreach (var m in take is { } n ? parsed.Take(n) : parsed) game.TryMove(m);
        return game;
    }

    private static PegMove? Parse(string s)
    {
        var p = s.Split(',');
        return p.Length == 3 && int.TryParse(p[0], out var x) && int.TryParse(p[1], out var y) && p[2].Length == 1
            ? new PegMove(x, y, p[2][0])
            : null;
    }
}
