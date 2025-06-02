using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IGameRoundRepository
    {
        Task<GameRound> GetByIdAsync(int gameRoundId);
        Task<IEnumerable<GameRound>> GetByGameIdAsync(int gameId);
        Task<GameRound> GetCurrentRoundAsync(int gameId);
        Task<GameRound> CreateAsync(GameRound gameRound);
        Task<GameRound> StartNewRoundAsync(int gameId);
        Task<bool> EndRoundAsync(int gameRoundId);
        Task<bool> UpdatePotSizeAsync(int gameRoundId, int potSize);
        Task<bool> SaveChangesAsync();
    }
}