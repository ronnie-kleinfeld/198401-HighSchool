using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;

namespace HighSchool.Tests;

/// <summary>Boots the whole site against a throw-away SQLite file filled from the real PASCAL folder.</summary>
public sealed class SiteFactory : WebApplicationFactory<Program>
{
    private readonly string _db = Path.Combine(Path.GetTempPath(), $"highschool-test-{Guid.NewGuid():N}.db");

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseSetting("ConnectionStrings:Default", $"Data Source={_db};Pooling=False");
        builder.UseSetting("Legacy:DataPath", LegacyFolder.Root);
    }

    protected override void Dispose(bool disposing)
    {
        base.Dispose(disposing);
        try { File.Delete(_db); } catch (IOException) { }
    }
}

public partial class WebSmokeTests(SiteFactory factory) : IClassFixture<SiteFactory>
{
    [Theory]
    [InlineData("/", "Pascal programs")]
    [InlineData("/Micro", "MICRO")]
    [InlineData("/Romi", "788")]
    [InlineData("/Romi/Report?kind=directory", "אלפון כל הערים")]
    [InlineData("/Romi/Report?kind=city&city=21", "ירושלים")]
    [InlineData("/Romi/Report?kind=cities", "קרית אונו")]
    [InlineData("/Iq", "105")]
    [InlineData("/Iq/Questions", "איסלאמאבד")]
    [InlineData("/Iq/Paint", "canvas")]
    [InlineData("/Msd", "עקרונות בהתנהגות")]
    [InlineData("/Msd/Check", "מערכת מספר 1")]
    [InlineData("/Nihul", "כרטיס אשראי")]
    [InlineData("/Nihul/Report", "דף חשבון")]
    [InlineData("/Nihul/Create?type=A", "הפקדות מזומנים")]
    [InlineData("/Classics", "THINK")]
    [InlineData("/Classics/Think?moves=4,2,Z", "Pegs left: <strong>31")]
    [InlineData("/Classics/Maze", "MAZE")]
    [InlineData("/Classics/Toto", "TT-NEW")]
    [InlineData("/Classics/Code", "CODE")]
    [InlineData("/Classics/Hezka", "HEZKA")]
    [InlineData("/Classics/Cubia", "CUBIA")]
    public async Task Pages_render(string url, string expected)
    {
        var response = await factory.CreateClient().GetAsync(url);
        var html = await response.Content.ReadAsStringAsync();

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.Contains(expected, html);
    }

    [Fact]
    public async Task Micro_loads_a_1988_program_and_runs_it_over_json()
    {
        var client = factory.CreateClient();
        var page = await client.GetStringAsync("/Micro");
        var token = TokenPattern().Match(page).Groups[1].Value;

        async Task<JsonElement> Post(string url, object body)
        {
            using var request = new HttpRequestMessage(HttpMethod.Post, url) { Content = JsonContent.Create(body) };
            request.Headers.Add("RequestVerificationToken", token);
            var response = await client.SendAsync(request);
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadFromJsonAsync<JsonElement>();
        }

        await Post("/Micro/LoadProgram", new { name = "ORT-88" });
        var started = await Post("/Micro/Command", new { line = "G2010" });
        Assert.Equal("go", started.GetProperty("state").GetProperty("mode").GetString());

        var run = await Post("/Micro/Run", new { ips = 10_000 });
        Assert.Equal("halted", run.GetProperty("status").GetString());
        Assert.Equal(6, run.GetProperty("events").EnumerateArray().Count(e => e.GetProperty("kind").GetString() == "digit"));
    }

    [Fact]
    public async Task Posts_without_an_antiforgery_token_are_rejected()
    {
        var response = await factory.CreateClient().PostAsJsonAsync("/Micro/Command", new { line = "CLS" });
        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
    }

    [GeneratedRegex("name=\"__RequestVerificationToken\" type=\"hidden\" value=\"([^\"]+)\"")]
    private static partial Regex TokenPattern();
}
