using System.Numerics;
using System.Text;

namespace HighSchool.Web.Modules.Classics;

/// <summary>CODE.PAS: shift every character by 4 ("hatzpana" = encrypt) or back by 4 ("pianuach" = decrypt).</summary>
public static class Caesar
{
    public const int Shift = 4;

    /// <summary>
    /// Same rule as the original: move by ±4, then wrap results that fall just outside a–z
    /// (codes 93–96 move up 26, codes 123–126 move down 26). Lower-case text round-trips;
    /// other characters are shifted exactly as CODE.PAS shifted them.
    /// </summary>
    public static string Apply(string text, bool encrypt)
    {
        var sb = new StringBuilder(text.Length);
        foreach (var ch in text)
        {
            var c = ch + (encrypt ? Shift : -Shift);
            if (c is > 92 and < 97) c += 26;
            if (c is > 122 and < 127) c -= 26;
            sb.Append(c < 0 ? ch : (char)c);
        }
        return sb.ToString();
    }
}

public sealed record PowerResult(BigInteger Numerator, bool Reciprocal, long Additions)
{
    public string Display => Reciprocal ? $"1/{Numerator} = {(double)1 / (double)Numerator:0.0000######}" : Numerator.ToString();
}

/// <summary>
/// HEZKA.PAS: raise a base to a power using only addition ("basis and maarich").
/// The original made a negative result whenever the base was negative and odd; the sign
/// actually depends on the exponent being odd, which is what this version does.
/// </summary>
public static class RepeatedAdditionPower
{
    public const int MaxBase = 1000;
    public const int MaxExponent = 60;

    public static PowerResult Compute(int @base, int exponent)
    {
        if (Math.Abs(@base) > MaxBase || Math.Abs(exponent) > MaxExponent)
            throw new ArgumentOutOfRangeException(nameof(@base), $"|base| ≤ {MaxBase}, |exponent| ≤ {MaxExponent}");
        if (exponent == 0) return new PowerResult(1, false, 0);
        if (@base == 0) return new PowerResult(0, false, 0);

        int a = Math.Abs(@base), b = Math.Abs(exponent);
        BigInteger s = a, f = a;
        long additions = 0;
        for (var x = 1; x <= b - 1; x++)
        {
            for (var y = 1; y <= a - 1; y++) { s += f; additions++; }
            f = s;
        }
        if (@base < 0 && b % 2 == 1) s = -s;
        return new PowerResult(s, exponent < 0, additions);
    }
}

public sealed record TotoMatch(int Home, int Away, double HomePct, double DrawPct, double AwayPct, char[] Columns);

/// <summary>
/// TT-NEW.PAS: fills four columns of a 14-match Toto (1 / X / 2) form. Each match gets two strengths;
/// the draw weight is min + |difference| / sum, and each column is drawn at random with those weights.
/// </summary>
public static class Toto
{
    public const int Matches = 14;
    public const int Columns = 4;

    public static IReadOnlyList<TotoMatch> Fill(IReadOnlyList<(int Home, int Away)> strengths, Random? random = null)
    {
        var rnd = random ?? new Random();
        return strengths.Select(m =>
        {
            int a = Math.Max(1, m.Home), b = Math.Max(1, m.Away);
            var c = Math.Min(a, b) + Math.Abs(a - b) / (double)(a + b);
            var t = a + b + c;
            double d = a / t * 100, e = c / t * 100, f = b / t * 100;
            var cols = new char[Columns];
            for (var r = 0; r < Columns; r++)
            {
                var g = rnd.Next(100) + 1;
                cols[r] = g < d ? '1' : g > d + e ? '2' : 'X';
            }
            return new TotoMatch(a, b, d, e, f, cols);
        }).ToList();
    }
}

/// <summary>
/// CUBIA.PAS: a scrolling "canyon". Each row draws a wall of ═ from the left (width X) and from the
/// right (width Y); two dice decide whether the walls step inwards-left or inwards-right.
/// </summary>
public static class Canyon
{
    public const int Width = 80;

    public static IReadOnlyList<string> Rows(int count, Random? random = null)
    {
        var rnd = random ?? new Random();
        var rows = new List<string>(count);
        int x = 1, y = 1;
        for (var i = 0; i < count; i++)
        {
            var line = new char[Width];
            for (var k = 0; k < Width; k++)
            {
                var col = k + 1;
                line[k] = col <= x || col >= Width - y ? '═' : ' ';
            }
            rows.Add(new string(line));

            var dice = rnd.Next(6) + rnd.Next(6);
            if (dice % 2 == 0) { x++; y--; } else { x--; y++; }
        }
        return rows;
    }
}
