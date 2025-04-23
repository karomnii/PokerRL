using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class PokerTable
    {
        [Key] public int TableId { get; set; }
        [Required, MaxLength(50)] public string Name { get; set; }
        public int EntryFee { get; set; }
        public int MinBuyIn { get; set; }
        public int MaxBuyIn { get; set; }
        public int SmallBlind { get; set; }
        public int BigBlind { get; set; }
        public int MaxPlayers { get; set; }
        [Required, MaxLength(20)] public string DifficultyLevel { get; set; }
        public bool IsActive { get; set; }

        public ICollection<Game> Games { get; set; }
    }
}