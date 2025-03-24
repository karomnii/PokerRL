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
        Task<bool> EndGameAsync(int gameId, int winnerId);
        Task<bool> UpdatePotSizeAsync(int gameId, int amount);
        Task<bool> UpdateGameStateAsync(int gameId, string newState);
    }
}
