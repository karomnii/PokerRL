using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class Card
    {
        [Key]
        public int CardId { get; set; }
        public string Suit { get; set; }
        public string Value { get; set; }

        // Navigation properties
        public ICollection<CommunityCard> CommunityCards { get; set; }
        public ICollection<PlayerCard> PlayerCards { get; set; }
    }
}
