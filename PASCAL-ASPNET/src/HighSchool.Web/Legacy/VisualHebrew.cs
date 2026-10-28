using System.Text;

namespace HighSchool.Web.Legacy;

/// <summary>
/// The 1988 programs stored Hebrew in "visual" order: the characters were laid out left-to-right
/// exactly as they appeared on a DOS screen, so every Hebrew word is reversed in the file
/// (e.g. 'תילגנא' is "אנגלית"). Latin letters and digits embedded in the text were typed so that
/// they also read correctly on screen.
///
/// Converting to logical order = reverse the whole string, then reverse each left-to-right run
/// (Latin letters / digits and the punctuation between them) back again.
/// Strings without any Hebrew letter are returned unchanged.
/// </summary>
public static class VisualHebrew
{
    public static bool ContainsHebrew(string s) => s.Any(IsHebrewLetter);

    public static string ToLogical(string visual)
    {
        if (!ContainsHebrew(visual)) return visual.TrimEnd();

        var chars = visual.ToCharArray();
        Array.Reverse(chars);
        var sb = new StringBuilder(chars.Length);

        var i = 0;
        while (i < chars.Length)
        {
            if (!IsStrongLtr(chars[i]))
            {
                sb.Append(Mirror(chars[i]));
                i++;
                continue;
            }

            // Grow an LTR run: strong LTR chars, allowing joiners (.,:/-) that sit between two LTR chars.
            var end = i;
            while (end + 1 < chars.Length &&
                   (IsStrongLtr(chars[end + 1]) ||
                    (IsJoiner(chars[end + 1]) && end + 2 < chars.Length && IsStrongLtr(chars[end + 2]))))
                end++;

            for (var k = end; k >= i; k--) sb.Append(chars[k]);
            i = end + 1;
        }

        return sb.ToString().Trim();
    }

    private static bool IsHebrewLetter(char c) => c is >= 'א' and <= 'ת';

    private static bool IsStrongLtr(char c) => char.IsAsciiLetterOrDigit(c);

    private static bool IsJoiner(char c) => c is '.' or ',' or ':' or '/' or '-' or '\'';

    // Paired punctuation flips direction when the reading order flips.
    private static char Mirror(char c) => c switch
    {
        '(' => ')', ')' => '(',
        '[' => ']', ']' => '[',
        '{' => '}', '}' => '{',
        '<' => '>', '>' => '<',
        _ => c
    };
}
