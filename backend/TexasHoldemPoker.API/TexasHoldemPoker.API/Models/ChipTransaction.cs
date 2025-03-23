using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class ChipTransaction
    {
        [Key]
        public int TransactionId { get; set; }
        public int UserId { get; set; }
        public int Amount { get; set; }
        public string TransactionType { get; set; }
        public int? ReferenceId { get; set; }
        public DateTime TransactionDate { get; set; }
        public string Description { get; set; }

        // Navigation properties
        public User User { get; set; }
    }

}
