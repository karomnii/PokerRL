using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TexasHoldemPoker.API.Models
{
    public class ChipTransaction
    {
        [Key] public int TransactionId { get; set; }

        [ForeignKey("User")] public int UserId { get; set; }
        public User User { get; set; }

        public int Amount { get; set; }

        [Required, MaxLength(50)]
        public string TransactionType { get; set; } // Purchase, GameWin, GameLoss, Bonus, Gift, Refund

        public int? ReferenceId { get; set; }
        public DateTime TransactionDate { get; set; }
        [MaxLength(255)] public string Description { get; set; }
    }
}