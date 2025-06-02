using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.DTOs
{
    public class CreateGameDto
    {
        [Required] public int TableId { get; set; }
    }
}