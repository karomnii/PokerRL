namespace TexasHoldemPoker.API.Models
{
    public class LeaderboardEntry
    {
        public int UserId { get; set; }
        public string Username { get; set; }
        public int ChipsBalance { get; set; }
        public string AvatarImage { get; set; }
        public int GamesWon { get; set; }
        public int GamesPlayed { get; set; }
    }
}