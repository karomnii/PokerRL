namespace TexasHoldemPoker.API.DTOs
{
    public class PlayerStateDto
    {
        public int UserId { get; set; }
        public string Username { get; set; }
        public int SeatPosition { get; set; }
        public int ChipCount { get; set; }
        public bool IsActive { get; set; }
        public bool IsDealer { get; set; }
        public bool IsSmallBlind { get; set; }
        public bool IsBigBlind { get; set; }
        public List<CardDto> Cards { get; set; } // Only populated for the requesting player or at showdown
    }
}
