using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions;

using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class PurchaseRepository : IPurchaseRepository
    {
        private readonly ApplicationDbContext _context;
        public PurchaseRepository(ApplicationDbContext context) => _context = context;

        public async Task<Purchase?> GetByIdAsync(int purchaseId) =>
            await _context.Purchases
                .Include(p => p.Item)
                .FirstOrDefaultAsync(p => p.PurchaseId == purchaseId);

        public async Task<IEnumerable<Purchase>> GetPurchasesByUserIdAsync(int userId)
        => await _context.Purchases
                .Where(p => p.UserId == userId)
                .Include(p => p.Item)
                .OrderByDescending(p => p.PurchaseDate)
                .ToListAsync();
        

        public async Task<Purchase> CreatePurchaseAsync(int userId, int itemId, string paymentMethod,
            string transactionId)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var item = await _context.ShopItems.FindAsync(itemId) 
                           ?? throw new InvalidOperationException($"Item id = {itemId} not found");
                var user = await _context.Users.FindAsync(userId) 
                           ?? throw new InvalidOperationException($"User with id = {userId}not found");
                
                var purchase = new Purchase
                {
                    UserId = userId,
                    ItemId = itemId,
                    PurchaseDate = DateTime.UtcNow,
                    Price = item.Price,
                    PaymentMethod = paymentMethod,
                    TransactionId = transactionId
                };

                _context.Purchases.Add(purchase);

                if (item.ItemType == "Chips")
                {
                    int chipAmount = ParseChipAmount(item.Name, item.Description);
                    user.ChipsBalance += chipAmount;

                    var chipTransaction = new ChipTransaction
                    {
                        UserId = userId,
                        Amount = chipAmount,
                        TransactionType = "Purchase",
                        ReferenceId = purchase.PurchaseId,
                        TransactionDate = DateTime.UtcNow,
                        Description = $"Purchased {chipAmount} chips"
                    };

                    _context.ChipTransactions.Add(chipTransaction);
                }

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();

                return purchase;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        private int ParseChipAmount(string name, string description)
        {
            string textToSearch = name + " " + description;
            var match = Regex.Match(textToSearch, @"(\d{1,3}(,\d{3})*)\s*chips", RegexOptions.IgnoreCase);

            if (match.Success)
            {
                string amountStr = match.Groups[1].Value.Replace(",", "");
                if (int.TryParse(amountStr, out int amount))
                    return amount;
            }

            return 1000;
        }
    }
}