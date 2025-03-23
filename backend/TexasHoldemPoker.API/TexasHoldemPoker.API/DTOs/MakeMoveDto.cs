using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.DTOs
{
    public class MakeMoveDto
    {
        [Required]
        public string ActionType { get; set; }

        public int Amount { get; set; }
    }
}
