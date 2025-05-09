using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class Game
{
    public int GameId { get; set; }

    public int TableId { get; set; }

    public DateTime StartTime { get; set; }

    public DateTime? EndTime { get; set; }

    public int? CurrentTurnPlayerId { get; set; }

    public int PotSize { get; set; }

    public virtual GamePlayer? CurrentTurnPlayer { get; set; }

    public virtual ICollection<GamePlayer> GamePlayers { get; set; } = new List<GamePlayer>();

    public virtual ICollection<GameRound> GameRounds { get; set; } = new List<GameRound>();

    public virtual PokerTable Table { get; set; } = null!;
}
