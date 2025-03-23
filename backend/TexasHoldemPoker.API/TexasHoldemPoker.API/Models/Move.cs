using System.ComponentModel.DataAnnotations;

namespace TexasHoldemPoker.API.Models
{
    public class Move
    {
        [Key]
        public int MoveId { get; set; }
        public int GameId { get; set; }
        public int PlayerId { get; set; }
        public string ActionType { get; set; }
        public int Amount { get; set; }
        public DateTime MoveTime { get; set; }
        public string Round { get; set; }

        // Navigation properties
        public Game Game { get; set; }
        public User Player { get; set; }
    }
}
