using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class ChipTransaction
{
    public int TransactionId { get; set; }

    public int UserId { get; set; }

    public int Amount { get; set; }

    public string TransactionType { get; set; } = null!;

    public int? ReferenceId { get; set; }

    public DateTime TransactionDate { get; set; }

    public string? Description { get; set; }

    public virtual User User { get; set; } = null!;
}