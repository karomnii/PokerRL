namespace TexasHoldemPoker.API.Models
{
    public class GameState
    {
        public int GameId { get; set; }
        public int TableId { get; set; }
        public string TableName { get; set; }
        public string CurrentState { get; set; }
        public int PotSize { get; set; }
        public List<Card> CommunityCards { get; set; }
        public List<Card> PlayerCards { get; set; }
        public List<PlayerState> Players { get; set; }
        public List<Move> LastMoves { get; set; }
        public int? WinnerId { get; set; }
    }
}
