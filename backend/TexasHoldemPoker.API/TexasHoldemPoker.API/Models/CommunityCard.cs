using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class CommunityCard
{
    public int CommunityCardId { get; set; }

    public int GameRoundId { get; set; }

    public int CardId { get; set; }

    public int Position { get; set; }

    public virtual Card Card { get; set; } = null!;

    public virtual GameRound GameRound { get; set; } = null!;
}
