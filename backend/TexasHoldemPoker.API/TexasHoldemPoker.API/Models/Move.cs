using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class Move
{
    public int MoveId { get; set; }

    public int GameRoundId { get; set; }

    public int PlayerId { get; set; }

    public string ActionType { get; set; } = null!;

    public int Amount { get; set; }

    public DateTime MoveTime { get; set; }

    public string Round { get; set; } = null!;

    public virtual GameRound GameRound { get; set; } = null!;

    public virtual User Player { get; set; } = null!;
}