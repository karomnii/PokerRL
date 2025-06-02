using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IGameRepository
    {
        Task<Game> GetByIdAsync(int gameId);
        Task<IEnumerable<Game>> GetActiveGamesAsync();
        Task<IEnumerable<Game>> GetGamesByTableIdAsync(int tableId);
        Task<IEnumerable<Game>> GetGamesByUserIdAsync(int userId);
        Task<Game> CreateGameAsync(Game game);
        Task UpdateGameAsync(Game game);
        Task<bool> UpdatePotSizeAsync(int gameId, int amount);
        Task<bool> UpdateGameStateAsync(int gameId, string newState);
        Task<bool> SetCurrentTurnAsync(int gameId, int? userId);
        Task<int?> GetCurrentTurnUserIdAsync(int gameId);
        Task<bool> EndGameAsync(int gameId);
        Task<PokerTable> GetGameTableAsync(int gameId);
        Task<int> GetPotSizeAsync(int gameId);
        Task<string> GetGameStateAsync(int gameId);
        Task<bool> SaveChangesAsync();
    }
}
