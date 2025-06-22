namespace TexasHoldemPoker.API.DTOs
{
    public class ActiveGameDto
    {
        public int GameId { get; set; }
        public string TableName { get; set; }
        public string TableDifficulty { get; set; }
    }
}