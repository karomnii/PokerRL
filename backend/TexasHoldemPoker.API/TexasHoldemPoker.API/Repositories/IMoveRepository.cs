using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IMoveRepository
    {
        Task<Move> RecordMoveAsync(
            int gameRoundId,
            int playerId,
            string actionType,
            int amount,
            string state
        );
        

        Task<IEnumerable<Move>> GetMovesByGameIdAsync(int gameId);
        Task<IEnumerable<Move>> GetMovesByGameRoundAsync(int gameRoundId, string state);
        Task<Dictionary<int, int>> GetPlayerContributionsForRoundAsync(int gameRoundId, string state);
        Task<int> GetHighestContributionForRoundAsync(int gameRoundId, string state);
        Task<bool> HasPlayerActedInRoundAsync(int gameRoundId, int playerId, string state);
        Task<Move> GetLastMoveAsync(int gameRoundId);
        
    }
}