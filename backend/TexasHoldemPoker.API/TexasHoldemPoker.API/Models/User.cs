using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class User
    {
        [Key]
        public int UserId { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public int ChipsBalance { get; set; }
        public string AvatarImage { get; set; } = "/images/default.png";        
        public DateTime RegistrationDate { get; set; }
        public DateTime? LastLoginDate { get; set; }
        public bool IsActive { get; set; }
        public string AvatarType { get; set; }

        // Navigation properties
        public ICollection<GamePlayer> GamePlayers { get; set; }
        public ICollection<Game> WonGames { get; set; }
        public ICollection<Move> Moves { get; set; }
        public ICollection<Purchase> Purchases { get; set; }
        public ICollection<ChipTransaction> ChipTransactions { get; set; }
    }
}
