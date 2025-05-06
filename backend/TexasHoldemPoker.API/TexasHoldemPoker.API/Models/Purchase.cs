using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class Purchase
{
    public int PurchaseId { get; set; }

    public int UserId { get; set; }

    public int ItemId { get; set; }

    public DateTime PurchaseDate { get; set; }

    public decimal Price { get; set; }

    public string? PaymentMethod { get; set; }

    public string? TransactionId { get; set; }

    public virtual ShopItem Item { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}