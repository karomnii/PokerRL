namespace TexasHoldemPoker.API.DTOs
{
    public class MoveDto
    {
        public int PlayerId { get; set; }
        public string ActionType { get; set; }
        public int Amount { get; set; }
        public string Round { get; set; }
        public DateTime MoveTime { get; set; }
    }
}
