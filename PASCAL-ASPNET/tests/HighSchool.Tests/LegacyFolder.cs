namespace HighSchool.Tests;

/// <summary>Locates the original PASCAL folder of the repository (the source of the imported data).</summary>
public static class LegacyFolder
{
    public static string Root { get; } = Find();

    public static string File(params string[] parts) => Path.Combine([Root, .. parts]);

    private static string Find()
    {
        for (var dir = new DirectoryInfo(AppContext.BaseDirectory); dir is not null; dir = dir.Parent)
        {
            var candidate = Path.Combine(dir.FullName, "PASCAL");
            if (Directory.Exists(Path.Combine(candidate, "ROMI"))) return candidate;
        }
        throw new DirectoryNotFoundException("PASCAL folder not found above the test output directory");
    }
}
