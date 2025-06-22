namespace TexasHoldemPoker.API.DTOs
{
    public class UserDto
    {
        public int UserId { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public int ChipsBalance { get; set; }
        public string? AvatarImage { get; set; }
        public string? DeckStyle { get; set; }
        public string Token { get; set; }
    }
}