using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class Card
{
    public int CardId { get; set; }

    public string Suit { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<CommunityCard> CommunityCards { get; set; } = new List<CommunityCard>();

    public virtual ICollection<PlayerCard> PlayerCards { get; set; } = new List<PlayerCard>();
}
