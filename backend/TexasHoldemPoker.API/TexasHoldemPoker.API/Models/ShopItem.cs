using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class ShopItem
    {
        [Key] public int ItemId { get; set; }
        [Required, MaxLength(100)] public string Name { get; set; }
        [MaxLength(500)] public string Description { get; set; }
        public decimal Price { get; set; }
        [Required, MaxLength(50)] public string ItemType { get; set; } // Chips, Avatar, TableTheme, CardDeck, Emote
        public bool IsActive { get; set; }

        public ICollection<Purchase> Purchases { get; set; }
    }
}