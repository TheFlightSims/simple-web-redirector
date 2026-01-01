using System.ComponentModel.DataAnnotations;

namespace WebRedirector.Database.Entities
{
    public class UrlEntity
    {
        [Key]
        public required Guid Id { get; set; }
        public required string Alias { get; set; }
        public required string Destination { get; set; }
    }
}