using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IMoveRepository
    {
        Task<Move> RecordMoveAsync(int gameId, int gameRoundId, int playerId, string actionType, int amount, string round);
        Task<IEnumerable<Move>> GetMovesByGameIdAsync(int gameId);
        Task<IEnumerable<Move>> GetLastRoundMovesAsync(int gameId, int gameRoundId, string round);
        Task<Dictionary<int, int>> GetPlayerContributionsForRoundAsync(int gameId, int gameRoundId, string round);
        Task<int> GetHighestContributionForRoundAsync(int gameId, int gameRoundId, string round);
        Task<bool> HasPlayerActedInRoundAsync(int gameId, int gameRoundId, int playerId, string round);
        Task<Move> GetLastMoveAsync(int gameId);
        Task<IEnumerable<Move>> GetMovesByGameRoundAsync(int gameId, int gameRoundId);
    }
}