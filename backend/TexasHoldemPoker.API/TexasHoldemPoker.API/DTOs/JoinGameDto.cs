using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.DTOs
{
    public class JoinGameDto
    {
        [Required] [Range(1, 9)] public int SeatPosition { get; set; }

        [Required] [Range(1, int.MaxValue)] public int BuyInAmount { get; set; }
    }
}