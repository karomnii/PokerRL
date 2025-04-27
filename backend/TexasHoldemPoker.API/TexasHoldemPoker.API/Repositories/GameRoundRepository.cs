using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class GameRoundRepository : IGameRoundRepository
    {
        private readonly PokerDbContext _context;

        public GameRoundRepository(PokerDbContext context)
        {
            _context = context;
        }

        public async Task<GameRound> GetByIdAsync(int gameRoundId)
        {
            return await _context.GameRounds
                .Include(gr => gr.Winners)
                .FirstOrDefaultAsync(gr => gr.GameRoundId == gameRoundId);
        }

        public async Task<IEnumerable<GameRound>> GetByGameIdAsync(int gameId)
        {
            return await _context.GameRounds
                .Include(gr => gr.Winners)
                .Where(gr => gr.GameId == gameId)
                .ToListAsync();
        }

        public async Task<GameRound> GetCurrentRoundAsync(int gameId)
        {
            return await _context.GameRounds
                .Where(gr => gr.GameId == gameId)
                .OrderByDescending(gr => gr.GameRoundId)
                .FirstOrDefaultAsync();
        }

        public async Task<GameRound> CreateAsync(GameRound gameRound)
        {
            gameRound.StartTime = DateTime.UtcNow;
            _context.GameRounds.Add(gameRound);
            await _context.SaveChangesAsync();
            return gameRound;
        }

        public async Task<GameRound> StartNewRoundAsync(int gameId)
        {
            // Get the last round number for this game
            var lastRound = await _context.GameRounds
                .Where(gr => gr.GameId == gameId)
                .OrderByDescending(gr => gr.RoundNumber)
                .FirstOrDefaultAsync();

            int roundNumber = (lastRound?.RoundNumber ?? 0) + 1;

            var newRound = new GameRound
            {
                GameId = gameId,
                RoundNumber = roundNumber,
                StartTime = DateTime.UtcNow,
                PotSize = 0
            };

            _context.GameRounds.Add(newRound);
            await _context.SaveChangesAsync();

            return newRound;
        }

        public async Task<bool> EndRoundAsync(int gameRoundId)
        {
            var round = await _context.GameRounds.FindAsync(gameRoundId);
            if (round == null)
                return false;

            round.EndTime = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> UpdatePotSizeAsync(int gameRoundId, int potSize)
        {
            var round = await _context.GameRounds.FindAsync(gameRoundId);
            if (round == null)
                return false;

            round.PotSize = potSize;
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> SaveChangesAsync()
        {
            return await _context.SaveChangesAsync() > 0;
        }
    }
}