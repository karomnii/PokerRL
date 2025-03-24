using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class ShopItem
    {
        [Key]
        public int ItemId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public string ItemType { get; set; }
        public bool IsActive { get; set; }

        // Navigation properties
        public ICollection<Purchase> Purchases { get; set; }
    }
}
