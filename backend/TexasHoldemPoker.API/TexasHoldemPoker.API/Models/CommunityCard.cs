using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class CommunityCard
    {
        [Key]
        public int CommunityCardId { get; set; }
        public int GameId { get; set; }
        public int CardId { get; set; }
        public int Position { get; set; }

        // Navigation properties
        public Game Game { get; set; }
        public Card Card { get; set; }
    }
}
