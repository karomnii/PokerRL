using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class PurchaseRepository : IPurchaseRepository
    {
        private readonly PokerDbContext context;

        public PurchaseRepository(PokerDbContext context)
        {
            this.context = context;
        }

        public async Task<Purchase> GetByIdAsync(int purchaseId)
        {
            return await context.Purchases
                .Include(p => p.ShopItem)
                .FirstOrDefaultAsync(p => p.PurchaseId == purchaseId);
        }

        public async Task<IEnumerable<Purchase>> GetPurchasesByUserIdAsync(int userId)
        {
            return await context.Purchases
                .Where(p => p.UserId == userId)
                .Include(p => p.ShopItem)
                .OrderByDescending(p => p.PurchaseDate)
                .ToListAsync();
        }

        public async Task<Purchase> CreatePurchaseAsync(int userId, int itemId, string paymentMethod,
            string transactionId)
        {
            using var transaction = await context.Database.BeginTransactionAsync();

            try
            {
                var item = await context.ShopItems.FindAsync(itemId);
                if (item == null)
                    throw new InvalidOperationException("Item not found");

                var user = await context.Users.FindAsync(userId);
                if (user == null)
                    throw new InvalidOperationException("User not found");

                var purchase = new Purchase
                {
                    UserId = userId,
                    ItemId = itemId,
                    PurchaseDate = DateTime.UtcNow,
                    Price = item.Price,
                    PaymentMethod = paymentMethod,
                    TransactionId = transactionId
                };

                context.Purchases.Add(purchase);

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

                    context.ChipTransactions.Add(chipTransaction);
                }

                await context.SaveChangesAsync();
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