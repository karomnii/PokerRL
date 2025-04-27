namespace TexasHoldemPoker.API.DTOs
{
    public class GameStateDto
    {
        public int GameId { get; set; }
        public int TableId { get; set; }
        public string TableName { get; set; }
        public string CurrentState { get; set; } // Waiting, PreFlop, Flop, Turn, River, Showdown, Completed
        public int PotSize { get; set; }
        public int? CurrentTurnUserId { get; set; }
        public List<CardDto> CommunityCards { get; set; }
        public List<PlayerStateDto> Players { get; set; }
        public List<CardDto> PlayerCards { get; set; }
        public List<MoveDto> LastMoves { get; set; }
        public List<RoundWinnerDto> RoundWinners { get; set; }
        public Dictionary<int, int> PlayerRoundContributions { get; set; }
        public int CallAmount { get; set; }
        public int MinRaiseAmount { get; set; }
    }
}