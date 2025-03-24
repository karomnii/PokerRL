using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class PokerTable
    {
        [Key]
        public int TableId { get; set; }
        public string Name { get; set; }
        public int EntryFee { get; set; }
        public int MinBuyIn { get; set; }
        public int MaxBuyIn { get; set; }
        public int SmallBlind { get; set; }
        public int BigBlind { get; set; }
        public int MaxPlayers { get; set; }
        public string DifficultyLevel { get; set; }
        public bool IsActive { get; set; }

        // Navigation properties
        public ICollection<Game> Games { get; set; }
    }
}
