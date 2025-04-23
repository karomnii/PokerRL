using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TexasHoldemPoker.API.Models
{
    public class PlayerCard
    {
        [Key] public int PlayerCardId { get; set; }

        [ForeignKey("GamePlayer")] public int GamePlayerId { get; set; }
        public GamePlayer GamePlayer { get; set; }

        [ForeignKey("Card")] public int CardId { get; set; }
        public Card Card { get; set; }

        public int Position { get; set; }
    }
}