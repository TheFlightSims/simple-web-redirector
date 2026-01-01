using Microsoft.AspNetCore.Mvc.RazorPages;
using WebRedirector.Database;

namespace WebRedirector.Pages
{
    public class IndexModel(AppsContext context) : PageModel
    {
        private readonly AppsContext _context = context;
    }
}
