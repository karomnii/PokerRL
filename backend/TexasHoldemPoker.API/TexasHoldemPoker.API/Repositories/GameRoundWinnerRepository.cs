using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class GameRoundWinnerRepository : IGameRoundWinnerRepository
    {
        private readonly PokerDbContext context;
        private readonly IChipTransactionRepository chipTransactionRepository;

        public GameRoundWinnerRepository(PokerDbContext context, IChipTransactionRepository chipTransactionRepository)
        {
            this.context = context;
            this.chipTransactionRepository = chipTransactionRepository;
        }

        public async Task<GameRoundWinner> GetByIdAsync(int gameRoundWinnerId)
        {
            return await context.GameRoundWinners
                .Include(grw => grw.User)
                .FirstOrDefaultAsync(grw => grw.GameRoundWinnerId == gameRoundWinnerId);
        }

        public async Task<IEnumerable<GameRoundWinner>> GetByGameRoundIdAsync(int gameRoundId)
        {
            return await context.GameRoundWinners
                .Include(grw => grw.User)
                .Where(grw => grw.GameRoundId == gameRoundId)
                .ToListAsync();
        }

        public async Task<GameRoundWinner> CreateAsync(GameRoundWinner gameRoundWinner)
        {
            context.GameRoundWinners.Add(gameRoundWinner);
            await context.SaveChangesAsync();
            return gameRoundWinner;
        }

        public async Task<bool> AddWinnerAsync(int gameRoundId, int userId, int amountWon)
        {
            using var transaction = await context.Database.BeginTransactionAsync();

            try
            {
                // Get the game ID for the transaction
                var gameRound = await context.GameRounds.FindAsync(gameRoundId);
                if (gameRound == null)
                    return false;

                // Create the winner record
                var winner = new GameRoundWinner
                {
                    GameRoundId = gameRoundId,
                    UserId = userId,
                    AmountWon = amountWon
                };

                context.GameRoundWinners.Add(winner);

                // Record the chip transaction
                await chipTransactionRepository.RecordGameWinningsAsync(userId, gameRound.GameId, amountWon);

                // Update the player's chips in the game
                var gamePlayer = await context.GamePlayers
                    .FirstOrDefaultAsync(gp => gp.GameId == gameRound.GameId && gp.UserId == userId);

                if (gamePlayer != null)
                {
                    gamePlayer.CurrentChips += amountWon;
                }

                await context.SaveChangesAsync();
                await transaction.CommitAsync();

                return true;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task<bool> AddMultipleWinnersAsync(int gameRoundId, Dictionary<int, int> winnerAmounts)
        {
            using var transaction = await context.Database.BeginTransactionAsync();

            try
            {
                // Get the game ID for the transaction
                var gameRound = await context.GameRounds.FindAsync(gameRoundId);
                if (gameRound == null)
                    return false;

                foreach (var entry in winnerAmounts)
                {
                    int userId = entry.Key;
                    int amountWon = entry.Value;

                    // Create the winner record
                    var winner = new GameRoundWinner
                    {
                        GameRoundId = gameRoundId,
                        UserId = userId,
                        AmountWon = amountWon
                    };

                    context.GameRoundWinners.Add(winner);

                    // Record the chip transaction
                    await chipTransactionRepository.RecordGameWinningsAsync(userId, gameRound.GameId, amountWon);

                    // Update the player's chips in the game
                    var gamePlayer = await context.GamePlayers
                        .FirstOrDefaultAsync(gp => gp.GameId == gameRound.GameId && gp.UserId == userId);

                    if (gamePlayer != null)
                    {
                        gamePlayer.CurrentChips += amountWon;
                    }
                }

                await context.SaveChangesAsync();
                await transaction.CommitAsync();

                return true;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task<bool> SaveChangesAsync()
        {
            return await context.SaveChangesAsync() > 0;
        }
    }
}
