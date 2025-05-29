using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class PokerTable
{
    public int TableId { get; set; }

    public string Name { get; set; } = null!;

    public int EntryFee { get; set; }

    public int MinBuyIn { get; set; }

    public int MaxBuyIn { get; set; }

    public int SmallBlind { get; set; }

    public int BigBlind { get; set; }

    public int MaxPlayers { get; set; }

    public string? DifficultyLevel { get; set; }

    public bool IsActive { get; set; }

    public virtual ICollection<Game> Games { get; set; } = new List<Game>();
}
