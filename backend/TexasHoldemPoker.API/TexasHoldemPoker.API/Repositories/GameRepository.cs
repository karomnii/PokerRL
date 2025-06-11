using Microsoft.EntityFrameworkCore;

using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class GameRepository : IGameRepository
    {
        private readonly ApplicationDbContext context;
       public GameRepository(ApplicationDbContext context)
        {
            this.context = context;
        }

        public async Task<Game> GetByIdAsync(int gameId)
        {
            return await context.Games
                .Include(g => g.Table)
                .Include(g => g.GamePlayers)
                .ThenInclude(gp => gp.User)
                .Include(g => g.GameRounds.OrderByDescending(gr => gr.RoundNumber).Take(1))
                .ThenInclude(gr => gr.CommunityCards)
                .Include(g => g.GameRounds.OrderByDescending(gr => gr.RoundNumber).Take(1))
                .ThenInclude(gr => gr.GameRoundWinners) // Include winners of the most recent round
                .FirstOrDefaultAsync(g => g.GameId == gameId);
        }

        public async Task<IEnumerable<Game>> GetActiveGamesAsync()
        {
            return await context.Games
                .Include(g => g.Table)
                .Include(g => g.GameRounds)
                .Where(g => !g.GameRounds.Any() || g.GameRounds
                    .OrderByDescending(gr => gr.RoundNumber)
                    .FirstOrDefault().CurrentState == "Waiting")
                .Include(g => g.GamePlayers)
                .ToListAsync();
        }

        public async Task<IEnumerable<Game>> GetGamesByTableIdAsync(int tableId)
        {
            return await context.Games
                .Where(g => g.TableId == tableId)
                .Include(g => g.GamePlayers)
                .Include(g => g.GameRounds.OrderByDescending(gr => gr.RoundNumber).Take(1))
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
            //game.CurrentState = "Waiting";
            game.PotSize = 0;

            context.Games.Add(game);
            await context.SaveChangesAsync();

            return game;
        }

        // TODO: Check if it works with GameRound modifications
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

            var gameRound = await context.GameRounds
                .Where(gr => gr.GameId == gameId)
                .OrderByDescending(gr => gr.RoundNumber)
                .FirstOrDefaultAsync();

            gameRound.CurrentState = newState;
            await context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> SetCurrentTurnAsync(int gameId, int? userId)
        {
            var game = await context.Games.FindAsync(gameId);
            if (game == null)
                return false;
            
            if (userId == null)
            {
                game.CurrentTurnPlayerId = null;
                await context.SaveChangesAsync();
                return true;
            }
            
            var gamePlayer = await context.GamePlayers
                .FirstOrDefaultAsync(gp => gp.GameId == gameId && gp.UserId == userId);
            if (gamePlayer == null)
                return false;

            game.CurrentTurnPlayerId = gamePlayer.GamePlayerId;
            await context.SaveChangesAsync();
            return true;
        }

        //TODO: Handle change to GamePlayerId
        public async Task<int?> GetCurrentTurnUserIdAsync(int gameId)
        {
            var game = await context.Games.FindAsync(gameId);
            return game?.CurrentTurnPlayerId;
        }

        public async Task<bool> EndGameAsync(int gameId)
        {
            var game = await context.Games.FindAsync(gameId);
            if (game == null)
                return false;

            var gameRound = await context.GameRounds.
                Where(gr => gr.GameId == gameId)
                .OrderByDescending(gr => gr.RoundNumber)
                .FirstOrDefaultAsync();
            if (gameRound == null)
                return false;

            gameRound.CurrentState = "Completed";
            gameRound.EndTime = DateTime.UtcNow;
            
            game.CurrentTurnPlayer = null;
            game.EndTime = DateTime.UtcNow;

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
            if(game == null)
                return string.Empty;
            var gameRound = await context.GameRounds
                .Where(gr => gr.GameId == gameId)
                .OrderByDescending(gr => gr.RoundNumber)
                .FirstOrDefaultAsync();
            if (gameRound == null)
                return string.Empty;

            return gameRound.CurrentState;
        }

        public async Task<bool> SaveChangesAsync()
        {
            return await context.SaveChangesAsync() > 0;
        }
    }
}
