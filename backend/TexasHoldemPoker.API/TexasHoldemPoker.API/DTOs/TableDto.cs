namespace TexasHoldemPoker.API.DTOs
{
    public class TableDto
    {
        public int TableId { get; set; }
        public required string Name { get; set; }
        public required string DifficultyLevel { get; set; }
        public int MaxPlayers { get; set; }
        public int MinBuyIn { get; set; }
        public int MaxBuyIn { get; set; }
        public int SmallBlind { get; set; }
        public int BigBlind { get; set; }
    }
}