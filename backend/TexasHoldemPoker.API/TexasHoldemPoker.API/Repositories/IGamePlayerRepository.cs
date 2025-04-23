using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IGamePlayerRepository
    {
        Task<GamePlayer> GetByIdAsync(int gamePlayerId);
        Task<IEnumerable<GamePlayer>> GetPlayersByGameIdAsync(int gameId);
        Task<GamePlayer> GetPlayerByGameAndUserAsync(int gameId, int userId);
        Task<GamePlayer> AddPlayerToGameAsync(int gameId, int userId, int seatPosition, int buyInAmount);
        Task<bool> UpdatePlayerChipsAsync(int gamePlayerId, int amount);
        Task<bool> SetPlayerStatusAsync(int gamePlayerId, bool isActive);
        Task<bool> SetDealerPositionAsync(int gameId, int gamePlayerId);
        Task<bool> SetBlindPositionsAsync(int gameId, int smallBlindPlayerId, int bigBlindPlayerId);
        Task<bool> RemovePlayerFromGameAsync(int gamePlayerId);
        Task<int> GetNextActivePlayerPositionAsync(int gameId, int currentPosition);
        Task<GamePlayer> GetPlayerBySeatPositionAsync(int gameId, int seatPosition);
    }
}