namespace HighSchool.Web.Modules.Nihul;

public sealed record TransactionType(char Letter, string Name, int Sign)
{
    public bool IsCredit => Sign > 0;
}

/// <summary>
/// The TAF constant and the sign table from CASES in NIHUL.PAS.
/// The original mapped 'A'..'E','L','O' to +1 and 'F'..'J','M','N' to -1 and forgot 'K'
/// (credit card), which then reused whatever sign the previous transaction had. Here 'K' is a debit.
/// </summary>
public static class TransactionTypes
{
    public static readonly IReadOnlyList<TransactionType> All =
    [
        new('A', "הפקדות מזומנים", +1),
        new('B', "הפקדת משכורת", +1),
        new('C', "הפקדות שקים", +1),
        new('D', "העברות זכות", +1),
        new('E', "העברות מיוחדות", +1),
        new('F', "הוצאת שיקים", -1),
        new('G', "תשלום הוראות קבע", -1),
        new('H', "העברות חובה", -1),
        new('I', "הוצאות מזומנים", -1),
        new('J', "כספומט", -1),
        new('K', "כרטיס אשראי", -1),
        new('L', "התאמה לחיוב", +1),
        new('M', "התאמה לשלילה", -1),
        new('N', "ריבית חובה", -1),
        new('O', "ריבית זכות", +1),
    ];

    public static TransactionType? Find(char letter) =>
        All.FirstOrDefault(t => t.Letter == char.ToUpperInvariant(letter));
}
