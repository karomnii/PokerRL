using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class PurchaseRepository : IPurchaseRepository
    {
        private readonly PokerDbContext _context;

        public PurchaseRepository(PokerDbContext context)
        {
            _context = context;
        }

        public async Task<Purchase> GetByIdAsync(int purchaseId)
        {
            return await _context.Purchases
                .Include(p => p.Item)
                .FirstOrDefaultAsync(p => p.PurchaseId == purchaseId);
        }

        public async Task<IEnumerable<Purchase>> GetPurchasesByUserIdAsync(int userId)
        {
            return await _context.Purchases
                .Where(p => p.UserId == userId)
                .Include(p => p.Item)
                .OrderByDescending(p => p.PurchaseDate)
                .ToListAsync();
        }

        public async Task<Purchase> CreatePurchaseAsync(int userId, int itemId, string paymentMethod, string transactionId)
        {
            using (var transaction = await _context.Database.BeginTransactionAsync())
            {
                try
                {
                    var item = await _context.ShopItems.FindAsync(itemId);
                    if (item == null)
                        throw new InvalidOperationException("Item not found");

                    var user = await _context.Users.FindAsync(userId);
                    if (user == null)
                        throw new InvalidOperationException("User not found");

                    // Create the purchase record
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

                    // If purchasing chips, update user's chip balance
                    if (item.ItemType == "Chips")
                    {
                        // Parse the chip amount from the item name or description
                        int chipAmount = ParseChipAmount(item.Name, item.Description);
                        user.ChipsBalance += chipAmount;

                        // Log the chip transaction
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
        }

        private int ParseChipAmount(string name, string description)
        {
            // This is a simplified implementation
            // In a real app, you might store the chip amount directly in the database
            // or have a more sophisticated parsing logic

            string textToSearch = name + " " + description;
            var match = Regex.Match(textToSearch, @"(\d{1,3}(,\d{3})*|\d+)\s*chips", RegexOptions.IgnoreCase);

            if (match.Success)
            {
                string amountStr = match.Groups[1].Value.Replace(",", "");
                if (int.TryParse(amountStr, out int amount))
                    return amount;
            }

            // Default fallback value if parsing fails
            return 1000;
        }
    }
}
