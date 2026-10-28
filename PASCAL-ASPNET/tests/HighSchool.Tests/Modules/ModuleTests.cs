using HighSchool.Web.Data;
using HighSchool.Web.Modules.Classics;
using HighSchool.Web.Modules.Iq;
using HighSchool.Web.Modules.Msd;

namespace HighSchool.Tests.Modules;

public class ModuleTests
{
    [Fact]
    public void Msd_seed_parses_the_fixed_width_course_rows()
    {
        var courses = MsdSeed.Courses();
        Assert.Equal(10, courses.Count);
        Assert.Equal(27, courses.Sum(c => c.Sections.Count));

        var first = courses[0].Sections[0];
        Assert.Equal(2, first.Day);
        Assert.Equal(new TimeOnly(12, 0), first.Start);
        Assert.Equal(new TimeOnly(13, 30), first.End);
        Assert.Equal("109", first.Room);
        Assert.Equal("גלנטה", first.Lecturer);
    }

    [Fact]
    public void Msd_solver_returns_only_clash_free_timetables()
    {
        var courses = MsdSeed.Courses().Take(5).ToList(); // the original checked the first five courses
        var result = TimetableSolver.Solve(courses, MsdSeed.BlockedSlots());

        Assert.Equal(5 * 3 * 4 * 3 * 3, result.Combinations);
        Assert.NotEmpty(result.Timetables);
        Assert.Equal(result.Combinations, result.Timetables.Count + result.Rejected);
        foreach (var t in result.Timetables)
        {
            Assert.Equal(5, t.Count);
            for (var i = 0; i < t.Count; i++)
            for (var j = i + 1; j < t.Count; j++)
                Assert.False(TimetableSolver.Overlaps(t[i], t[j]));
            Assert.DoesNotContain(t, s => TimetableSolver.HitsBlocked(s, MsdSeed.BlockedSlots()));
        }
    }

    [Fact]
    public void Peg_solitaire_starts_with_32_pegs_and_supports_undo_by_replay()
    {
        var game = new PegSolitaire();
        Assert.Equal(32, game.PegsLeft);
        Assert.False(game.TryMove(new PegMove(4, 4, 'W')));   // the hole itself
        Assert.True(game.TryMove(new PegMove(4, 2, 'Z')));    // jump down into the center
        Assert.Equal(31, game.PegsLeft);
        Assert.True(game[4, 4]);

        var replayed = PegSolitaire.Replay(game.Serialize(), take: 0);
        Assert.Equal(32, replayed.PegsLeft);
    }

    [Fact]
    public void Maze_walk_reaches_the_bottom_right_corner_without_crossing_itself()
    {
        var result = MazeWalk.Generate(seed: 1988);
        var path = new List<(int, int)>();
        foreach (var e in result.Events)
        {
            if (e.Kind == "back") path.RemoveRange(e.Length, path.Count - e.Length);
            else path.Add((e.X, e.Y));
        }

        Assert.Equal((1, 1), path[0]);
        Assert.Equal((MazeWalk.Width, MazeWalk.Height), path[^1]);
        Assert.Equal(path.Count, path.Distinct().Count());
        Assert.Equal(result.Steps, path.Count);
    }

    [Theory]
    [InlineData("hello world")]
    [InlineData("xyz abc")]
    public void Caesar_round_trips_lower_case(string text) =>
        Assert.Equal(text, Caesar.Apply(Caesar.Apply(text, encrypt: true), encrypt: false));

    [Theory]
    [InlineData(2, 10, "1024")]
    [InlineData(-3, 3, "-27")]
    [InlineData(-3, 2, "9")]
    [InlineData(5, 0, "1")]
    public void Power_by_repeated_addition(int b, int e, string expected) =>
        Assert.Equal(expected, RepeatedAdditionPower.Compute(b, e).Numerator.ToString());

    [Fact]
    public void Quiz_asks_ten_distinct_terms_with_the_right_answer_among_four()
    {
        var bank = Enumerable.Range(1, 20)
            .Select(i => new Question { Id = i, Subject = "s", Term = $"t{i}", Definition = $"d{i}" }).ToList();
        var quiz = Quiz.Create(bank, new Random(7));

        Assert.Equal(10, quiz.Items.Select(r => r.Term).Distinct().Count());
        foreach (var round in quiz.Items)
        {
            Assert.Equal(4, round.Options.Distinct().Count());
            Assert.Equal("d" + round.Term[1..], round.Options[round.CorrectOption - 1]);
        }

        quiz.Answer(quiz.Round!.CorrectOption);
        quiz.Next();
        Assert.Equal(1, quiz.Right);
        Assert.Equal(1, quiz.Current);
    }
}
