using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IMoveRepository
    {
        Task<Move> RecordMoveAsync(int gameId, int playerId, string actionType, int amount, string round);
        Task<IEnumerable<Move>> GetMovesByGameIdAsync(int gameId);
        Task<IEnumerable<Move>> GetLastRoundMovesAsync(int gameId, string round);
        Task<Dictionary<int, int>> GetPlayerContributionsForRoundAsync(int gameId, string round);
        Task<int> GetHighestContributionForRoundAsync(int gameId, string round);
        Task<bool> HasPlayerActedInRoundAsync(int gameId, int playerId, string round);
        Task<Move> GetLastMoveAsync(int gameId);
    }
}