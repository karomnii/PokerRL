using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class GameRoundWinnerRepository : IGameRoundWinnerRepository
    {
        private readonly PokerDbContext _context;
        private readonly IChipTransactionRepository _chipTransactionRepository;

        public GameRoundWinnerRepository(
            PokerDbContext context,
            IChipTransactionRepository chipTransactionRepository)
        {
            _context = context;
            _chipTransactionRepository = chipTransactionRepository;
        }

        public async Task<GameRoundWinner> GetByIdAsync(int gameRoundWinnerId)
        {
            return await _context.GameRoundWinners
                .Include(grw => grw.User)
                .FirstOrDefaultAsync(grw => grw.GameRoundWinnerId == gameRoundWinnerId);
        }

        public async Task<IEnumerable<GameRoundWinner>> GetByGameRoundIdAsync(int gameRoundId)
        {
            return await _context.GameRoundWinners
                .Include(grw => grw.User)
                .Where(grw => grw.GameRoundId == gameRoundId)
                .ToListAsync();
        }

        public async Task<GameRoundWinner> CreateAsync(GameRoundWinner gameRoundWinner)
        {
            _context.GameRoundWinners.Add(gameRoundWinner);
            await _context.SaveChangesAsync();
            return gameRoundWinner;
        }

        public async Task<bool> AddWinnerAsync(int gameRoundId, int userId, int amountWon)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var gameRound = await _context.GameRounds.FindAsync(gameRoundId);
                if (gameRound == null)
                    return false;

                var winner = new GameRoundWinner
                {
                    GameRoundId = gameRoundId,
                    UserId = userId,
                    AmountWon = amountWon
                };

                _context.GameRoundWinners.Add(winner);

                var gamePlayer = await _context.GamePlayers
                    .FirstOrDefaultAsync(gp => gp.GameId == gameRound.GameId && gp.UserId == userId);

                if (gamePlayer != null)
                {
                    gamePlayer.CurrentChips += amountWon;
                }

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

        public async Task<bool> AddMultipleWinnersAsync(int gameRoundId, Dictionary<int, int> winnerAmounts)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var gameRound = await _context.GameRounds.FindAsync(gameRoundId);
                if (gameRound == null)
                    return false;

                foreach (var entry in winnerAmounts)
                {
                    int userId = entry.Key;
                    int amountWon = entry.Value;

                    var winner = new GameRoundWinner
                    {
                        GameRoundId = gameRoundId,
                        UserId = userId,
                        AmountWon = amountWon
                    };

                    _context.GameRoundWinners.Add(winner);

                    var gamePlayer = await _context.GamePlayers
                        .FirstOrDefaultAsync(gp => gp.GameId == gameRound.GameId && gp.UserId == userId);

                    if (gamePlayer != null)
                    {
                        gamePlayer.CurrentChips += amountWon;
                    }
                }

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

        public async Task<bool> SaveChangesAsync()
        {
            return await _context.SaveChangesAsync() > 0;
        }
    }
}