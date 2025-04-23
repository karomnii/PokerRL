using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TexasHoldemPoker.API.Models
{
    public class Purchase
    {
        [Key] public int PurchaseId { get; set; }

        [ForeignKey("User")] public int UserId { get; set; }
        public User User { get; set; }

        [ForeignKey("ShopItem")] public int ItemId { get; set; }
        public ShopItem ShopItem { get; set; }

        public DateTime PurchaseDate { get; set; }
        public decimal Price { get; set; }
        public string PaymentMethod { get; set; }
        public string TransactionId { get; set; }
    }
}