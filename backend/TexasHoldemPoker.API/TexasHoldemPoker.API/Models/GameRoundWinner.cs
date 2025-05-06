using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class GameRoundWinner
{
    public int GameRoundWinnerId { get; set; }

    public int GameRoundId { get; set; }

    public int UserId { get; set; }

    public int AmountWon { get; set; }

    public virtual GameRound GameRound { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}