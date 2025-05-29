namespace TexasHoldemPoker.API.DTOs
{
    public class MoveDto
    {
        public int PlayerId { get; set; }
        public string ActionType { get; set; } // Fold, Check, Call, Bet, Raise, AllIn
        public int Amount { get; set; }
        public DateTime MoveTime { get; set; }
    }
}