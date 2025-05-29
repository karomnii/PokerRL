namespace TexasHoldemPoker.API.DTOs
{
    public class CardDto
    {
        public string Suit { get; set; } // "Hearts", "Diamonds", "Clubs", "Spades"
        public string Value { get; set; } // "2"-"10", "J", "Q", "K", "A"
    }
}