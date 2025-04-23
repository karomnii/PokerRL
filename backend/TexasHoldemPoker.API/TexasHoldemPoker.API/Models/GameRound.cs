using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class GameRound
    {
        [Key] public int GameRoundId { get; set; }

        [ForeignKey("Game")] public int GameId { get; set; }
        public Game Game { get; set; }

        public int RoundNumber { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int PotSize { get; set; }

        public ICollection<GameRoundWinner> Winners { get; set; }
    }
}