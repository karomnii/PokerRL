using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class User
{
    public int UserId { get; set; }

    public string Username { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public int ChipsBalance { get; set; }

    public string? AvatarImage { get; set; } = "/images/default.png"; 

    public string AvatarType { get; set; }

    public DateTime RegistrationDate { get; set; }

    public DateTime? LastLoginDate { get; set; }

    public bool IsActive { get; set; }

    public bool? IsBot { get; set; }

    public virtual ICollection<ChipTransaction> ChipTransactions { get; set; } = new List<ChipTransaction>();

    public virtual ICollection<GamePlayer> GamePlayers { get; set; } = new List<GamePlayer>();

    public virtual ICollection<GameRoundWinner> GameRoundWinners { get; set; } = new List<GameRoundWinner>();

    public virtual ICollection<Move> Moves { get; set; } = new List<Move>();

    public virtual ICollection<Purchase> Purchases { get; set; } = new List<Purchase>();

    public virtual ICollection<UserModel> UserModels { get; set; } = new List<UserModel>();
}