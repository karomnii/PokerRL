using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Models;

// TODO: change TransactionType = "Refund", "GameLoss", "GameWin" to some other transaction types, it needs to be changed in database constraints(buy-in, pull-out?)
namespace TexasHoldemPoker.API.Repositories
{
    public class ChipTransactionRepository : IChipTransactionRepository
    {
        private readonly ApplicationDbContext context;

        public ChipTransactionRepository(ApplicationDbContext context)
        {
            this.context = context;
        }

        public async Task<ChipTransaction> GetByIdAsync(int transactionId)
        {
            return await context.ChipTransactions.FindAsync(transactionId);
        }

        public async Task<IEnumerable<ChipTransaction>> GetTransactionsByUserIdAsync(int userId)
        {
            return await context.ChipTransactions
                .Where(t => t.UserId == userId)
                .OrderByDescending(t => t.TransactionDate)
                .ToListAsync();
        }

        public async Task<ChipTransaction> CreateTransactionAsync(ChipTransaction chipTransaction)
        {
            var existingTransaction = context.Database.CurrentTransaction;
            if (existingTransaction != null)
            {
                var user = await context.Users.FindAsync(chipTransaction.UserId);
                if (user == null)
                    throw new InvalidOperationException("User not found");

                user.ChipsBalance += chipTransaction.Amount;

                chipTransaction.TransactionDate = DateTime.UtcNow;
                context.ChipTransactions.Add(chipTransaction);

                return chipTransaction;
            }

            using var dbTransaction = await context.Database.BeginTransactionAsync();

            try
            {
                var user = await context.Users.FindAsync(chipTransaction.UserId);
                if (user == null)
                    throw new InvalidOperationException("User not found");

                user.ChipsBalance += chipTransaction.Amount;

                chipTransaction.TransactionDate = DateTime.UtcNow;
                context.ChipTransactions.Add(chipTransaction);

                await context.SaveChangesAsync();
                await dbTransaction.CommitAsync();

                return chipTransaction;
            }
            catch
            {
                await dbTransaction.RollbackAsync();
                throw;
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
                Amount = -amount,
                TransactionType = "GameLoss",
                ReferenceId = gameId,
                TransactionDate = DateTime.UtcNow,
                Description = $"Loss from game {gameId}"
            };

            return await CreateTransactionAsync(chipTransaction);
        }

        public async Task<ChipTransaction> RecordGameBuyInAsync(int userId, int gameId, int amount)
        {
            var chipTransaction = new ChipTransaction
            {
                UserId = userId,
                Amount = -amount,
                TransactionType = "GameLoss",
                ReferenceId = gameId,
                TransactionDate = DateTime.UtcNow,
                Description = $"Buy-in for game {gameId}"
            };

            return await CreateTransactionAsync(chipTransaction);
        }

        public async Task<ChipTransaction> RecordGameRefundAsync(int userId, int gameId, int amount)
        {
            var chipTransaction = new ChipTransaction
            {
                UserId = userId,
                Amount = amount,
                TransactionType = "Refund",
                ReferenceId = gameId,
                TransactionDate = DateTime.UtcNow,
                Description = $"Refund from leaving game {gameId}"
            };

            return await CreateTransactionAsync(chipTransaction);
        }
    }
}