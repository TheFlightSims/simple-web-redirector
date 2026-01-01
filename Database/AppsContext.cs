using Microsoft.EntityFrameworkCore;
using WebRedirector.Database.Entities;

namespace WebRedirector.Database
{
    public class AppsContext(DbContextOptions<AppsContext> options) : DbContext(options)
    {
        public DbSet<UrlEntity> Urls { get; set; }
    }
}
