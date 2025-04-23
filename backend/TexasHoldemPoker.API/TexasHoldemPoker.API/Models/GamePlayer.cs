using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TexasHoldemPoker.API.Models
{
    public class GamePlayer
    {
        [Key] public int GamePlayerId { get; set; }

        [ForeignKey("Game")] public int GameId { get; set; }
        public Game Game { get; set; }

        [ForeignKey("User")] public int UserId { get; set; }
        public User User { get; set; }

        public int SeatPosition { get; set; }
        public int InitialChips { get; set; }
        public int CurrentChips { get; set; }
        public bool IsActive { get; set; }
        public bool IsDealer { get; set; }
        public bool IsSmallBlind { get; set; }
        public bool IsBigBlind { get; set; }

        public ICollection<PlayerCard> PlayerCards { get; set; }
    }
}