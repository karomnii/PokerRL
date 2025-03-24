using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IMoveRepository
    {
        Task<Move> GetByIdAsync(int moveId);
        Task<IEnumerable<Move>> GetMovesByGameIdAsync(int gameId);
        Task<IEnumerable<Move>> GetMovesByPlayerIdAsync(int gameId, int playerId);
        Task<Move> RecordMoveAsync(int gameId, int playerId, string actionType, int amount, string round);
        Task<IEnumerable<Move>> GetLastRoundMovesAsync(int gameId, string round);
    }
}
