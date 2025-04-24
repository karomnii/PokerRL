using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class User
    {
        [Key] public int UserId { get; set; }
        [Required, MaxLength(50)] public string Username { get; set; }
        [Required, MaxLength(100)] public string Email { get; set; }
        [Required, MaxLength(128)] public string PasswordHash { get; set; }
        public int ChipsBalance { get; set; }
        public string? AvatarImage { get; set; }

        public DateTime RegistrationDate { get; set; }
        public DateTime? LastLoginDate { get; set; }
        public bool IsActive { get; set; }

        public ICollection<GamePlayer> GamePlayers { get; set; }
        public ICollection<Purchase> Purchases { get; set; }
        public ICollection<ChipTransaction> ChipTransactions { get; set; }
        public ICollection<GameRoundWinner> GameRoundWinners { get; set; }
    }
}