using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class Purchase
    {
        [Key]
        public int PurchaseId { get; set; }
        public int UserId { get; set; }
        public int ItemId { get; set; }
        public DateTime PurchaseDate { get; set; }
        public decimal Price { get; set; }
        public string PaymentMethod { get; set; }
        public string TransactionId { get; set; }

        // Navigation properties
        public User User { get; set; }
        public ShopItem Item { get; set; }
    }
}
