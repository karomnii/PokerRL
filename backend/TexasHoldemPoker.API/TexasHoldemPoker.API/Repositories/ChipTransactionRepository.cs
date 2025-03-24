using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class ChipTransactionRepository : IChipTransactionRepository
    {
        private readonly PokerDbContext _context;

        public ChipTransactionRepository(PokerDbContext context)
        {
            _context = context;
        }

        public async Task<ChipTransaction> GetByIdAsync(int transactionId)
        {
            return await _context.ChipTransactions.FindAsync(transactionId);
        }

        public async Task<IEnumerable<ChipTransaction>> GetTransactionsByUserIdAsync(int userId)
        {
            return await _context.ChipTransactions
                .Where(t => t.UserId == userId)
                .OrderByDescending(t => t.TransactionDate)
                .ToListAsync();
        }

        public async Task<ChipTransaction> CreateTransactionAsync(ChipTransaction chipTransaction)
        {
            using (var dbTransaction = await _context.Database.BeginTransactionAsync())
            {
                try
                {
                    var user = await _context.Users.FindAsync(chipTransaction.UserId);
                    if (user == null)
                        throw new InvalidOperationException("User not found");

                    // Update user's chip balance
                    user.ChipsBalance += chipTransaction.Amount;

                    // Add transaction record
                    chipTransaction.TransactionDate = DateTime.UtcNow;
                    _context.ChipTransactions.Add(chipTransaction);

                    await _context.SaveChangesAsync();
                    await dbTransaction.CommitAsync();

                    return chipTransaction;
                }
                catch
                {
                    await dbTransaction.RollbackAsync();
                    throw;
                }
            }
        }

        public async Task<ChipTransaction> RecordBonusChipsAsync(int userId, int amount, string description)
        {
            var chipTransaction = new ChipTransaction
            {
                UserId = userId,
                Amount = amount,
                TransactionType = "Bonus",
                TransactionDate = DateTime.UtcNow,
                Description = description
            };

            return await CreateTransactionAsync(chipTransaction);
        }

        public async Task<ChipTransaction> RecordGameWinningsAsync(int userId, int gameId, int amount)
        {
            var chipTransaction = new ChipTransaction
            {
                UserId = userId,
                Amount = amount,
                TransactionType = "GameWin",
                ReferenceId = gameId,
                TransactionDate = DateTime.UtcNow,
                Description = $"Winnings from game {gameId}"
            };

            return await CreateTransactionAsync(chipTransaction);
        }

        public async Task<ChipTransaction> RecordGameLossAsync(int userId, int gameId, int amount)
        {
            var chipTransaction = new ChipTransaction
            {
                UserId = userId,
                Amount = -amount, // Negative amount for loss
                TransactionType = "GameLoss",
                ReferenceId = gameId,
                TransactionDate = DateTime.UtcNow,
                Description = $"Loss from game {gameId}"
            };

            return await CreateTransactionAsync(chipTransaction);
        }
    }
}
