using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class GameRound
{
    public int GameRoundId { get; set; }

    public int GameId { get; set; }

    public int RoundNumber { get; set; }

    public string CurrentState { get; set; } = null!;

    public DateTime StartTime { get; set; }

    public DateTime? EndTime { get; set; }

    public int PotSize { get; set; }

    public virtual ICollection<CommunityCard> CommunityCards { get; set; } = new List<CommunityCard>();

    public virtual Game Game { get; set; } = null!;

    public virtual ICollection<GameRoundWinner> GameRoundWinners { get; set; } = new List<GameRoundWinner>();

    public virtual ICollection<Move> Moves { get; set; } = new List<Move>();

    public virtual ICollection<PlayerCard> PlayerCards { get; set; } = new List<PlayerCard>();
}
