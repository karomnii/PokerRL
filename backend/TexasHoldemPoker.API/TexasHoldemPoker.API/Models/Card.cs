using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class Card
    {
        [Key] public int CardId { get; set; }
        [Required, MaxLength(10)] public string Suit { get; set; }
        [Required, MaxLength(5)] public string Value { get; set; }
    }
}