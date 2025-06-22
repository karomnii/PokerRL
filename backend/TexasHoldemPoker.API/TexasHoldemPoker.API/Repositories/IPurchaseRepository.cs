using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IPurchaseRepository
    {
        Task<Purchase?> GetByIdAsync(int purchaseId);
        Task<IEnumerable<Purchase>> GetPurchasesByUserIdAsync(int userId);
        Task<Purchase> CreatePurchaseAsync(int userId, int itemId, string paymentMethod, string transactionId);
        Task<bool> AddInitialUserItems(int userId);
    }
}