using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IChipTransactionRepository
    {
        Task<ChipTransaction> GetByIdAsync(int transactionId);
        Task<IEnumerable<ChipTransaction>> GetTransactionsByUserIdAsync(int userId);
        Task<ChipTransaction> CreateTransactionAsync(ChipTransaction transaction);
        Task<ChipTransaction> RecordBonusChipsAsync(int userId, int amount, string description);
        Task<ChipTransaction> RecordGameWinningsAsync(int userId, int gameId, int amount);
        Task<ChipTransaction> RecordGameLossAsync(int userId, int gameId, int amount);
        Task<ChipTransaction> RecordGameBuyInAsync(int userId, int gameId, int amount);
        Task<ChipTransaction> RecordGameRefundAsync(int userId, int gameId, int amount);
    }
}