using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class Game
    {
        [Key]
        public int GameId { get; set; }
        public int TableId { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public string CurrentState { get; set; }
        public int PotSize { get; set; }
        public int? WinnerId { get; set; }
        public int? CurrentTurnUserId { get; set; }

        // Navigation properties
        public PokerTable Table { get; set; }
        public User Winner { get; set; }
        public User CurrentTurnUser { get; set; }
        public ICollection<GamePlayer> GamePlayers { get; set; }
        public ICollection<Move> Moves { get; set; }
        public ICollection<CommunityCard> CommunityCards { get; set; }
    }
}
