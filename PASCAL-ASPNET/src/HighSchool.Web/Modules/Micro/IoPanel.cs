namespace HighSchool.Web.Modules.Micro;

/// <summary>A visible change on the panel: kind "led" (index 0), "digit" (0..5) or "text" (0..19).</summary>
public sealed record PanelEvent(string Kind, int Index, int Value);

/// <summary>
/// The right-hand panel of MICRO's screen: the trainer's I/O ports.
/// <list type="bullet">
/// <item>#00 out – 8 binary LEDs; #00 in – 8 toggle switches.</item>
/// <item>#04 out – segment pattern for the current 7-segment digit (active low: bit7..0 = d c b a dp g f e).</item>
/// <item>#05 out – digit select: high nibble must be 8, bit 3 = auto-advance, bits 0-2 = digit 0..5.</item>
/// <item>#FF out – a character on the 20-character text line; #FF in – a key from the keyboard.</item>
/// </list>
/// </summary>
public sealed class IoPanel
{
    public const int DigitCount = 6;
    public const int TextWidth = 20;

    public byte Leds { get; set; }
    public byte[] Digits { get; set; } = Blank();
    public int DigitCursor { get; set; }
    public bool AutoAdvance { get; set; } = true;
    public string Text { get; set; } = new(' ', TextWidth);
    public int TextCursor { get; set; }
    public byte Switches { get; set; }

    private static byte[] Blank() => Enumerable.Repeat((byte)0xFF, DigitCount).ToArray();

    /// <summary>"Clean ports" from the F5 Operate menu.</summary>
    public void Clear()
    {
        Leds = 0;
        Digits = Blank();
        DigitCursor = 0;
        AutoAdvance = true;
        Text = new string(' ', TextWidth);
        TextCursor = 0;
    }

    public static bool IsInputPort(byte port) => port is 0x00 or 0xFF;

    public PanelEvent? Write(byte port, byte value)
    {
        switch (port)
        {
            case 0x00:
                Leds = value;
                return new PanelEvent("led", 0, value);
            case 0x04:
                var digit = DigitCursor;
                Digits[digit] = value;
                if (AutoAdvance) DigitCursor = (DigitCursor + 1) % DigitCount;
                return new PanelEvent("digit", digit, value);
            case 0x05:
                if (value >> 4 == 8)
                {
                    AutoAdvance = (value & 0x08) != 0;
                    DigitCursor = Math.Min(value & 0x07, DigitCount - 1);
                }
                return null;
            case 0xFF:
                if (value < 32) return null;
                var pos = TextCursor;
                var chars = Text.ToCharArray();
                chars[pos] = (char)value;
                Text = new string(chars);
                TextCursor = (TextCursor + 1) % TextWidth;
                return new PanelEvent("text", pos, value);
            default:
                return null;
        }
    }
}
