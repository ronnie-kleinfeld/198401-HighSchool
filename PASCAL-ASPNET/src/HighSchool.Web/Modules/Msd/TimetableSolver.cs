using HighSchool.Web.Data;

namespace HighSchool.Web.Modules.Msd;

public sealed record TimetableResult(
    IReadOnlyList<IReadOnlyList<CourseSection>> Timetables,
    long Combinations,
    long Rejected,
    bool Truncated);

/// <summary>
/// Check_Data / MAIN / MSD_RUN_CHECK from MSD.PAS: walk every combination of one section per course
/// (the RUN[] odometer), reject combinations that collide with each other or with a blocked time,
/// and keep the rest (at most 2000, the size of MSD_Data).
/// The original compared minute-by-minute in a [day,hour,minute] boolean grid; here two meetings
/// collide when their [Start, End) intervals overlap on the same day, which is the same rule.
/// </summary>
public static class TimetableSolver
{
    public const int MaxResults = 2000;

    public static TimetableResult Solve(IEnumerable<Course> courses, IReadOnlyCollection<BlockedSlot> blocked)
    {
        var options = courses
            .Where(c => c.IsActive)
            .Select(c => c.Sections.Where(s => s.IsActive && !HitsBlocked(s, blocked)).OrderBy(s => s.GroupNumber).ToArray())
            .ToArray();

        var combinations = courses.Where(c => c.IsActive)
            .Aggregate(1L, (n, c) => n * c.Sections.Count(s => s.IsActive));

        var results = new List<IReadOnlyList<CourseSection>>();
        if (options.Length == 0 || options.Any(o => o.Length == 0))
            return new TimetableResult(results, combinations, combinations, false);

        var chosen = new CourseSection[options.Length];
        var truncated = false;

        void Walk(int depth)
        {
            if (truncated) return;
            if (depth == options.Length)
            {
                if (results.Count == MaxResults) { truncated = true; return; }
                results.Add(chosen.ToArray());
                return;
            }
            foreach (var section in options[depth])
            {
                var clash = false;
                for (var i = 0; i < depth && !clash; i++) clash = Overlaps(chosen[i], section);
                if (clash) continue;
                chosen[depth] = section;
                Walk(depth + 1);
            }
        }

        Walk(0);
        return new TimetableResult(results, combinations, truncated ? -1 : combinations - results.Count, truncated);
    }

    public static bool Overlaps(CourseSection a, CourseSection b) =>
        a.Day == b.Day && a.Start < b.End && b.Start < a.End;

    public static bool HitsBlocked(CourseSection s, IEnumerable<BlockedSlot> blocked) =>
        blocked.Any(x => x.Day == s.Day && s.Start < x.To && x.From < s.End);
}
