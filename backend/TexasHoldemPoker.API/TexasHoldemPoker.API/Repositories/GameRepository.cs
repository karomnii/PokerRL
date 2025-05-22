using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class GameRepository : IGameRepository
    {
        private readonly PokerDbContext context;

        public GameRepository(PokerDbContext context)
        {
            this.context = context;
        }

        public async Task<Game> GetByIdAsync(int gameId)
        {
            return await context.Games
                .Include(g => g.Table)
                .Include(g => g.GamePlayers)
                .ThenInclude(gp => gp.User)
                .Include(g => g.CommunityCards)
                .ThenInclude(cc => cc.Card)
                .Include(g => g.GameRounds)
                .ThenInclude(gr => gr.Winners)
                .FirstOrDefaultAsync(g => g.GameId == gameId);
        }

        public async Task<IEnumerable<Game>> GetActiveGamesAsync()
        {
            var games = await context.Games
                .Where(g => g.CurrentState != "Completed")
                .Include(g => g.Table)
                .ToListAsync();
            foreach (var game in games)
            {
                // Usuń null z relacji Games w Table
                game.Table.Games = [];
            }

            return games;
        }

        public async Task<IEnumerable<Game>> GetGamesByTableIdAsync(int tableId)
        {
            return await context.Games
                .Where(g => g.TableId == tableId)
                .Include(g => g.GamePlayers)
                .ToListAsync();
        }

        public async Task<IEnumerable<Game>> GetGamesByUserIdAsync(int userId)
        {
            return await context.Games
                .Where(g => g.GamePlayers.Any(gp => gp.UserId == userId))
                .Include(g => g.Table)
                .ToListAsync();
        }

        public async Task<Game> CreateGameAsync(Game game)
        {
            game.StartTime = DateTime.UtcNow;
            game.CurrentState = "Waiting";
            game.PotSize = 0;

            context.Games.Add(game);
            await context.SaveChangesAsync();

            return game;
        }

        public async Task UpdateGameAsync(Game game)
        {
            context.Entry(game).State = EntityState.Modified;
            await context.SaveChangesAsync();
        }

        public async Task<bool> UpdatePotSizeAsync(int gameId, int amount)
        {
            var game = await context.Games.FindAsync(gameId);
            var gameRound = await context.GameRounds
                .Where(gr => gr.GameId == gameId)
                .OrderByDescending(gr => gr.RoundNumber)
                .FirstOrDefaultAsync();
            if (game == null)
                return false;
            if (gameRound == null)
                return false;

            gameRound.PotSize = amount;
            game.PotSize = amount;
            await context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpdateGameStateAsync(int gameId, string newState)
        {
            var game = await context.Games.FindAsync(gameId);
            if (game == null)
                return false;

            game.CurrentState = newState;
            await context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> SetCurrentTurnAsync(int gameId, int? userId)
        {
            var game = await context.Games.FindAsync(gameId);
            if (game == null)
                return false;

            game.CurrentTurnUserId = userId;
            await context.SaveChangesAsync();
            return true;
        }

        public async Task<int?> GetCurrentTurnUserIdAsync(int gameId)
        {
            var game = await context.Games.FindAsync(gameId);
            return game?.CurrentTurnUserId;
        }

        public async Task<bool> EndGameAsync(int gameId)
        {
            var game = await context.Games.FindAsync(gameId);
            if (game == null)
                return false;

            game.EndTime = DateTime.UtcNow;
            game.CurrentState = "Completed";

            await context.SaveChangesAsync();
            return true;
        }

        public async Task<PokerTable> GetGameTableAsync(int gameId)
        {
            var game = await context.Games
                .Include(g => g.Table)
                .FirstOrDefaultAsync(g => g.GameId == gameId);

            return game?.Table;
        }

        public async Task<int> GetPotSizeAsync(int gameId)
        {
            var game = await context.Games.FindAsync(gameId);
            return game?.PotSize ?? 0;
        }

        public async Task<string> GetGameStateAsync(int gameId)
        {
            var game = await context.Games.FindAsync(gameId);
            return game?.CurrentState;
        }

        public async Task<bool> SaveChangesAsync()
        {
            return await context.SaveChangesAsync() > 0;
        }
    }
}