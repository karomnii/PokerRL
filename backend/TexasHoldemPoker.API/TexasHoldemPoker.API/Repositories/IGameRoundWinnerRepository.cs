using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IGameRoundWinnerRepository
    {
        Task<GameRoundWinner> GetByIdAsync(int gameRoundWinnerId);
        Task<IEnumerable<GameRoundWinner>> GetByGameRoundIdAsync(int gameRoundId);
        Task<GameRoundWinner> CreateAsync(GameRoundWinner gameRoundWinner);
        Task<bool> AddWinnerAsync(int gameRoundId, int userId, int amountWon);
        Task<bool> AddMultipleWinnersAsync(int gameRoundId, Dictionary<int, int> winnerAmounts);
        Task<bool> SaveChangesAsync();
    }
}