using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class GamePlayer
{
    public int GamePlayerId { get; set; }

    public int GameId { get; set; }

    public int UserId { get; set; }

    public int SeatPosition { get; set; }

    public int InitialChips { get; set; }

    public int CurrentChips { get; set; }

    public bool IsActive { get; set; }

    public bool IsDealer { get; set; }

    public bool IsSmallBlind { get; set; }

    public bool IsBigBlind { get; set; }

    public virtual Game Game { get; set; } = null!;

    public virtual ICollection<Game> Games { get; set; } = new List<Game>();

    public virtual ICollection<PlayerCard> PlayerCards { get; set; } = new List<PlayerCard>();

    public virtual User User { get; set; } = null!;
}