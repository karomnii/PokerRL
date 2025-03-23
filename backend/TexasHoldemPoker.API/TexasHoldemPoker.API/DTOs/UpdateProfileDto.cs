using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.DTOs
{
    public class UpdateProfileDto
    {
        [EmailAddress]
        public string Email { get; set; }
        public string AvatarImage { get; set; }
    }
}
