using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TexasHoldemPoker.API.Models
{
    public class CommunityCard
    {
        [Key] public int CommunityCardId { get; set; }

        [ForeignKey("Game")] public int GameId { get; set; }
        public Game Game { get; set; }

        [ForeignKey("Card")] public int CardId { get; set; }
        public Card Card { get; set; }

        public int Position { get; set; }
    }
}