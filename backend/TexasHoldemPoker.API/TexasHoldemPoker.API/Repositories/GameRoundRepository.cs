using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class GameRoundRepository : IGameRoundRepository
    {
        private readonly PokerDbContext context;

        public GameRoundRepository(PokerDbContext context)
        {
            this.context = context;
        }

        public async Task<GameRound> GetByIdAsync(int gameRoundId)
        {
            return await context.GameRounds
                .Include(gr => gr.Winners)
                .FirstOrDefaultAsync(gr => gr.GameRoundId == gameRoundId);
        }

        public async Task<IEnumerable<GameRound>> GetByGameIdAsync(int gameId)
        {
            return await context.GameRounds
                .Include(gr => gr.Winners)
                .Where(gr => gr.GameId == gameId)
                .ToListAsync();
        }

        public async Task<GameRound> GetCurrentRoundAsync(int gameId)
        {
            return await context.GameRounds
                .Where(gr => gr.GameId == gameId && gr.EndTime == null)
                .FirstOrDefaultAsync();
        }

        public async Task<GameRound> CreateAsync(GameRound gameRound)
        {
            gameRound.StartTime = DateTime.UtcNow;
            context.GameRounds.Add(gameRound);
            await context.SaveChangesAsync();
            return gameRound;
        }

        public async Task<GameRound> StartNewRoundAsync(int gameId)
        {
            // Get the last round number for this game
            var lastRound = await context.GameRounds
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

            context.GameRounds.Add(newRound);
            await context.SaveChangesAsync();

            return newRound;
        }

        public async Task<bool> EndRoundAsync(int gameRoundId)
        {
            var round = await context.GameRounds.FindAsync(gameRoundId);
            if (round == null)
                return false;

            round.EndTime = DateTime.UtcNow;
            await context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> UpdatePotSizeAsync(int gameRoundId, int potSize)
        {
            var round = await context.GameRounds.FindAsync(gameRoundId);
            if (round == null)
                return false;

            round.PotSize = potSize;
            await context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> SaveChangesAsync()
        {
            return await context.SaveChangesAsync() > 0;
        }
    }
}
