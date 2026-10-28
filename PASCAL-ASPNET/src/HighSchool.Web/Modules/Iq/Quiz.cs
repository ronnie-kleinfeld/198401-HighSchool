using HighSchool.Web.Data;

namespace HighSchool.Web.Modules.Iq;

public sealed class QuizRound
{
    public string Subject { get; set; } = "";
    public string Term { get; set; } = "";
    public List<string> Options { get; set; } = [];
    public int CorrectOption { get; set; }   // 1..4
    public int? Answer { get; set; }         // 1..4 once answered
    public bool IsCorrect => Answer == CorrectOption;
}

/// <summary>
/// The general-knowledge drill of IQWYEDA.PAS (procedure ASK): ten rounds, each showing a term
/// and four definitions, one of them right. Score = 10% per correct answer.
/// </summary>
public sealed class Quiz
{
    public const int Rounds = 10;
    public const int Choices = 4;

    /// <summary>The original refused to start with fewer than 16 questions in YEDA.DAT.</summary>
    public const int MinimumQuestions = 16;

    public List<QuizRound> Items { get; set; } = [];
    public int Current { get; set; }

    public int Right => Items.Count(r => r.Answer is not null && r.IsCorrect);
    public int Wrong => Items.Count(r => r.Answer is not null && !r.IsCorrect);
    public bool Finished => Current >= Items.Count;
    public int Percent => Items.Count == 0 ? 0 : Right * 100 / Items.Count;

    public static Quiz Create(IReadOnlyList<Question> bank, Random? random = null)
    {
        if (bank.Count < MinimumQuestions)
            throw new InvalidOperationException($"At least {MinimumQuestions} questions are needed.");

        var rnd = random ?? new Random();
        var quiz = new Quiz();
        var asked = new HashSet<int>();

        while (quiz.Items.Count < Rounds)
        {
            var answer = rnd.Next(bank.Count);
            if (!asked.Add(answer)) continue;

            // Four different wrong definitions, then the right one dropped into a random slot.
            var picks = new List<int>();
            while (picks.Count < Choices)
            {
                var other = rnd.Next(bank.Count);
                if (other != answer && !picks.Contains(other)) picks.Add(other);
            }
            var slot = rnd.Next(Choices);
            picks[slot] = answer;

            quiz.Items.Add(new QuizRound
            {
                Subject = bank[answer].Subject,
                Term = bank[answer].Term,
                Options = picks.Select(i => bank[i].Definition).ToList(),
                CorrectOption = slot + 1,
            });
        }
        return quiz;
    }

    public QuizRound? Round => Finished ? null : Items[Current];

    public void Answer(int option)
    {
        if (Round is { Answer: null } round && option is >= 1 and <= Choices) round.Answer = option;
    }

    public void Next()
    {
        if (Round is { Answer: not null }) Current++;
    }
}
