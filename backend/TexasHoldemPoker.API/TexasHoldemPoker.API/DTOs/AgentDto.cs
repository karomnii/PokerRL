namespace TexasHoldemPoker.API.DTOs
{
    public class AgentDto
    {
        public string Name { get; set; } = null!;

        public string? Difficulty { get; set; }

        public int UserId { get; set; }

        public string Username { get; set; } = null!;
    }
}