using System.Text;

namespace HighSchool.Web.Legacy;

/// <summary>
/// Reads fields out of a Turbo Pascal 3.x typed-file record ("FILE OF record").
/// Layouts follow the TP3 rules: string[n] = length byte + n chars, integer = 2 bytes LE,
/// boolean/char = 1 byte, real = 6-byte Borland real (a.k.a. Real48).
/// </summary>
public sealed class TurboPascalRecord(byte[] buffer, int offset)
{
    private static readonly Encoding Cp862;

    static TurboPascalRecord()
    {
        Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
        Cp862 = Encoding.GetEncoding(862);
    }

    private int _pos = offset;

    public static IEnumerable<TurboPascalRecord> ReadAll(byte[] file, int recordSize)
    {
        for (var i = 0; i + recordSize <= file.Length; i += recordSize)
            yield return new TurboPascalRecord(file, i);
    }

    /// <summary>Reads a string[maxLength] and returns it as it was stored (visual order for Hebrew).</summary>
    public string ReadRawString(int maxLength)
    {
        var len = Math.Min(buffer[_pos], (byte)maxLength);
        var text = Cp862.GetString(buffer, _pos + 1, len);
        _pos += maxLength + 1;
        return text;
    }

    /// <summary>Reads a string[maxLength] and converts DOS visual Hebrew to logical order.</summary>
    public string ReadString(int maxLength) => VisualHebrew.ToLogical(ReadRawString(maxLength));

    public short ReadInteger()
    {
        var value = BitConverter.ToInt16(buffer, _pos);
        _pos += 2;
        return value;
    }

    public bool ReadBoolean() => buffer[_pos++] != 0;

    public char ReadChar() => Cp862.GetString(buffer, _pos++, 1)[0];

    public double ReadReal()
    {
        var value = Real48.ToDouble(buffer.AsSpan(_pos, 6));
        _pos += 6;
        return value;
    }
}

/// <summary>Borland 6-byte real: byte 0 = exponent (bias 129), bytes 1..5 = mantissa, sign in the top bit of byte 5.</summary>
public static class Real48
{
    public static double ToDouble(ReadOnlySpan<byte> b)
    {
        if (b[0] == 0) return 0.0;
        var negative = (b[5] & 0x80) != 0;
        long mantissa = ((long)(b[5] & 0x7F) << 32) | ((long)b[4] << 24) | ((long)b[3] << 16) | ((long)b[2] << 8) | b[1];
        var value = (1.0 + mantissa / (double)(1L << 39)) * Math.Pow(2, b[0] - 129);
        return negative ? -value : value;
    }
}
