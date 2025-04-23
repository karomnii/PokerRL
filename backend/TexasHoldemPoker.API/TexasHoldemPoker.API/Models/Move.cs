using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TexasHoldemPoker.API.Models
{
    public class Move
    {
        [Key] public int MoveId { get; set; }

        [ForeignKey("Game")] public int GameId { get; set; }
        public Game Game { get; set; }

        [ForeignKey("Player")] public int PlayerId { get; set; }
        public User Player { get; set; }

        [Required, MaxLength(20)] public string ActionType { get; set; } // Fold, Check, Call, Bet, Raise, AllIn

        public int Amount { get; set; }
        public DateTime MoveTime { get; set; }

        [Required, MaxLength(20)] public string Round { get; set; } // PreFlop, Flop, Turn, River
    }
}