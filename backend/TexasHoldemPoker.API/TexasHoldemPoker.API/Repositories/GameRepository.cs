using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class GameRepository : IGameRepository
    {
        private readonly PokerDbContext _context;

        public GameRepository(PokerDbContext context)
        {
            _context = context;
        }

        public async Task<Game> GetByIdAsync(int gameId)
        {
            return await _context.Games
                .Include(g => g.Table)
                .Include(g => g.GamePlayers)
                    .ThenInclude(gp => gp.User)
                .Include(g => g.CommunityCards)
                    .ThenInclude(cc => cc.Card)
                .FirstOrDefaultAsync(g => g.GameId == gameId);
        }

        public async Task<IEnumerable<Game>> GetActiveGamesAsync()
        {
            return await _context.Games
                .Where(g => g.EndTime == null)
                .Include(g => g.Table)
                .ToListAsync();
        }

        public async Task<IEnumerable<Game>> GetGamesByTableIdAsync(int tableId)
        {
            return await _context.Games
                .Where(g => g.TableId == tableId)
                .Include(g => g.GamePlayers)
                .ToListAsync();
        }

        public async Task<IEnumerable<Game>> GetGamesByUserIdAsync(int userId)
        {
            return await _context.Games
                .Where(g => g.GamePlayers.Any(gp => gp.UserId == userId))
                .Include(g => g.Table)
                .ToListAsync();
        }

        public async Task<Game> CreateGameAsync(Game game)
        {
            game.StartTime = DateTime.UtcNow;
            game.CurrentState = "Waiting";
            game.PotSize = 0;

            _context.Games.Add(game);
            await _context.SaveChangesAsync();
            return game;
        }

        public async Task UpdateGameAsync(Game game)
        {
            _context.Entry(game).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<bool> EndGameAsync(int gameId, int winnerId)
        {
            using (var transaction = await _context.Database.BeginTransactionAsync())
            {
                try
                {
                    var game = await _context.Games.FindAsync(gameId);
                    if (game == null) return false;

                    var winner = await _context.Users.FindAsync(winnerId);
                    if (winner == null) return false;

                    game.EndTime = DateTime.UtcNow;
                    game.CurrentState = "Completed";
                    game.WinnerId = winnerId;

                    // Update winner's chips
                    winner.ChipsBalance += game.PotSize;

                    // Log transaction
                    var chipTransaction = new ChipTransaction
                    {
                        UserId = winnerId,
                        Amount = game.PotSize,
                        TransactionType = "GameWin",
                        ReferenceId = gameId,
                        TransactionDate = DateTime.UtcNow,
                        Description = $"Winnings from game {gameId}"
                    };

                    _context.ChipTransactions.Add(chipTransaction);
                    await _context.SaveChangesAsync();

                    await transaction.CommitAsync();
                    return true;
                }
                catch
                {
                    await transaction.RollbackAsync();
                    throw;
                }
            }
        }

        public async Task<bool> UpdatePotSizeAsync(int gameId, int amount)
        {
            var game = await _context.Games.FindAsync(gameId);
            if (game == null) return false;

            game.PotSize += amount;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpdateGameStateAsync(int gameId, string newState)
        {
            var game = await _context.Games.FindAsync(gameId);
            if (game == null) return false;

            game.CurrentState = newState;
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
