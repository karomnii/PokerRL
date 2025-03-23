namespace TexasHoldemPoker.API.Models
{
    public class PlayerState
    {
        public int UserId { get; set; }
        public string Username { get; set; }
        public int SeatPosition { get; set; }
        public int ChipCount { get; set; }
        public bool IsActive { get; set; }
        public bool IsDealer { get; set; }
        public bool IsSmallBlind { get; set; }
        public bool IsBigBlind { get; set; }
        public List<Card> Cards { get; set; }
    }
}
