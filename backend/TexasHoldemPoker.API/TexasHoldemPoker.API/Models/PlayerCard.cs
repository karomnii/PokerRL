using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class PlayerCard
{
    public int PlayerCardId { get; set; }

    public int? GamePlayerId { get; set; }

    public int UserId { get; set; }

    public int GameRoundId { get; set; }

    public int CardId { get; set; }

    public int Position { get; set; }

    public virtual Card Card { get; set; } = null!;

    public virtual GamePlayer GamePlayer { get; set; }

    public virtual GameRound GameRound { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
