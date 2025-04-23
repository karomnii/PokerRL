using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class GameRoundWinner
    {
        [Key] public int GameRoundWinnerId { get; set; }

        [ForeignKey("GameRound")] public int GameRoundId { get; set; }
        public GameRound GameRound { get; set; }

        [ForeignKey("User")] public int UserId { get; set; }
        public User User { get; set; }

        public int AmountWon { get; set; }
    }
}