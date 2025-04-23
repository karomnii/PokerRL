using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TexasHoldemPoker.API.Models
{
    public class Game
    {
        [Key] public int GameId { get; set; }

        [ForeignKey("Table")] public int TableId { get; set; }
        public PokerTable Table { get; set; }

        public DateTime StartTime { get; set; }
        public DateTime? EndTime { get; set; }

        [Required, MaxLength(20)]
        public string CurrentState { get; set; } // Waiting, PreFlop, Flop, Turn, River, Showdown, Completed

        public int PotSize { get; set; }

        [ForeignKey("CurrentTurnUser")] public int? CurrentTurnUserId { get; set; }
        public User CurrentTurnUser { get; set; }

        public ICollection<GamePlayer> GamePlayers { get; set; }
        public ICollection<Move> Moves { get; set; }
        public ICollection<CommunityCard> CommunityCards { get; set; }
        public ICollection<GameRound> GameRounds { get; set; }
    }
}