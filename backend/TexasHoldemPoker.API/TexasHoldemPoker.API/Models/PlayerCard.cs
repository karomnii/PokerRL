using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class PlayerCard
    {
        [Key]
        public int PlayerCardId { get; set; }
        public int GamePlayerId { get; set; }
        public int CardId { get; set; }
        public int Position { get; set; }

        // Navigation properties
        public GamePlayer GamePlayer { get; set; }
        public Card Card { get; set; }
    }
}
