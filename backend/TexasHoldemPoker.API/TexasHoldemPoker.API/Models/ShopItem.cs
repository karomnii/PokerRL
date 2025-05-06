using System;
using System.Collections.Generic;

namespace TexasHoldemPoker.API.Models;

public partial class ShopItem
{
    public int ItemId { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public decimal Price { get; set; }

    public string ItemType { get; set; } = null!;

    public bool IsActive { get; set; }

    public virtual ICollection<Purchase> Purchases { get; set; } = new List<Purchase>();
}