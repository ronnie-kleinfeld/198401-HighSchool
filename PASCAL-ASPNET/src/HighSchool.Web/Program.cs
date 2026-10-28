using System.Text.Encodings.Web;
using System.Text.Unicode;
using HighSchool.Web.Data;
using HighSchool.Web.Legacy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.WebEncoders;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews(o =>
{
    o.Filters.Add(new AutoValidateAntiforgeryTokenAttribute());
    o.SuppressImplicitRequiredAttributeForNonNullableReferenceTypes = true; // optional text fields default to ""
});
builder.Services.AddAntiforgery(o => o.HeaderName = "RequestVerificationToken");
// Emit Hebrew as text rather than &#x5D0;-style entities.
builder.Services.Configure<WebEncoderOptions>(o => o.TextEncoderSettings = new TextEncoderSettings(UnicodeRanges.All));

var dbPath = Path.Combine(builder.Environment.ContentRootPath, "App_Data", "highschool.db");
Directory.CreateDirectory(Path.GetDirectoryName(dbPath)!);
builder.Services.AddDbContext<AppDbContext>(o =>
    o.UseSqlite(builder.Configuration.GetConnectionString("Default") ?? $"Data Source={dbPath}"));
builder.Services.AddScoped<LegacyImporter>();

builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(o =>
{
    o.Cookie.Name = ".HighSchool.Session";
    o.Cookie.HttpOnly = true;
    o.Cookie.IsEssential = true;
    o.IdleTimeout = TimeSpan.FromHours(2);
});

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.EnsureCreated();
    var legacyRoot = Path.GetFullPath(Path.Combine(app.Environment.ContentRootPath,
        app.Configuration["Legacy:DataPath"] ?? "../../../PASCAL"));
    await scope.ServiceProvider.GetRequiredService<LegacyImporter>().ImportAsync(legacyRoot);
}

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseRouting();
app.UseSession();
app.UseAuthorization();

app.MapStaticAssets();
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();

app.Run();

public partial class Program;
