using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class LeaderboardView
{
    public int UserId { get; set; }

    public string Username { get; set; } = null!;

    public int ChipsBalance { get; set; }

    public string? AvatarImage { get; set; }

    public int? GamesWon { get; set; }

    public int? GamesPlayed { get; set; }

    public double? WinRatio { get; set; }
}
