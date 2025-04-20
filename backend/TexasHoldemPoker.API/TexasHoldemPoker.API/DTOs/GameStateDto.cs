namespace TexasHoldemPoker.API.DTOs
{
    public class GameStateDto
    {
        public int GameId { get; set; }
        public int TableId { get; set; }
        public string TableName { get; set; }
        public string CurrentState { get; set; }
        public int PotSize { get; set; }
        public List<CardDto> CommunityCards { get; set; }
        public List<PlayerStateDto> Players { get; set; }
        public List<CardDto> PlayerCards { get; set; } // Only populated for the requesting player
        public List<MoveDto> LastMoves { get; set; }
        public int? WinnerId { get; set; }
    }
}
