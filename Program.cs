using Microsoft.EntityFrameworkCore;
using WebRedirector.Database;
using WebRedirector.Database.Entities;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();

// Prefer connection string from connected service / configuration.
string? connectionString = builder.Configuration.GetConnectionString("AppsDatabase");

builder.Services.AddDbContext<AppsContext>(options =>
{
    // Enable transient error resiliency and pass the connection string.
    _ = options.UseSqlServer(connectionString, sqlOptions =>
    {
        _ = sqlOptions.EnableRetryOnFailure();
    });
});

WebApplication app = builder.Build();

app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapGet("/{alias:regex(^[A-Za-z0-9]+$)}", async (string alias, AppsContext db) =>
{
    UrlEntity? entry = await db.Urls.AsNoTracking().FirstOrDefaultAsync(u => u.Alias == alias);
    return entry is null ? Results.Redirect("PageNotFound", permanent: false) : Results.Redirect(entry.Destination, permanent: false);
});

app.MapStaticAssets();
app.MapRazorPages().WithStaticAssets();

app.Run();
