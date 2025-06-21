namespace TexasHoldemPoker.API.DTOs
{
    public class ShopItemDto
    {
        public int ItemId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public string ItemType { get; set; } // e.g., "Avatar", "CardDeck"
        public string Currency { get; set; } // e.g., "PLN", "CHIPS"
    }
}
