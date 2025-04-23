using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class MoveRepository : IMoveRepository
    {
        private readonly PokerDbContext context;

        public MoveRepository(PokerDbContext context)
        {
            this.context = context;
        }

        public async Task<Move> GetByIdAsync(int moveId)
        {
            return await context.Moves.FindAsync(moveId);
        }

        public async Task<IEnumerable<Move>> GetMovesByGameIdAsync(int gameId)
        {
            return await context.Moves
                .Where(m => m.GameId == gameId)
                .OrderBy(m => m.MoveTime)
                .ToListAsync();
        }

        public async Task<IEnumerable<Move>> GetMovesByPlayerIdAsync(int gameId, int playerId)
        {
            return await context.Moves
                .Where(m => m.GameId == gameId && m.PlayerId == playerId)
                .OrderBy(m => m.MoveTime)
                .ToListAsync();
        }

        public async Task<Move> RecordMoveAsync(int gameId, int playerId, string actionType, int amount, string round)
        {
            using var transaction = await context.Database.BeginTransactionAsync();

            try
            {
                // Create move record
                var move = new Move
                {
                    GameId = gameId,
                    PlayerId = playerId,
                    ActionType = actionType,
                    Amount = amount,
                    MoveTime = DateTime.UtcNow,
                    Round = round
                };

                context.Moves.Add(move);

                // Update game pot and player chips if needed
                if (actionType == "Bet" || actionType == "Call" || actionType == "Raise" || actionType == "AllIn")
                {
                    // Update pot size
                    var game = await context.Games.FindAsync(gameId);
                    game.PotSize += amount;

                    // Update player's current chips
                    var gamePlayer = await context.GamePlayers
                        .FirstOrDefaultAsync(gp => gp.GameId == gameId && gp.UserId == playerId);

                    gamePlayer.CurrentChips -= amount;
                }

                await context.SaveChangesAsync();
                await transaction.CommitAsync();

                return move;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task<IEnumerable<Move>> GetLastRoundMovesAsync(int gameId, string round)
        {
            return await context.Moves
                .Where(m => m.GameId == gameId && m.Round == round)
                .OrderBy(m => m.MoveTime)
                .ToListAsync();
        }

        public async Task<Dictionary<int, int>> GetPlayerContributionsForRoundAsync(int gameId, string round)
        {
            var moves = await context.Moves
                .Where(m => m.GameId == gameId && m.Round == round)
                .ToListAsync();

            var contributions = new Dictionary<int, int>();

            foreach (var move in moves)
            {
                if (move.ActionType == "Bet" || move.ActionType == "Call" || move.ActionType == "Raise" || move.ActionType == "AllIn")
                {
                    if (!contributions.ContainsKey(move.PlayerId))
                    {
                        contributions[move.PlayerId] = 0;
                    }

                    contributions[move.PlayerId] += move.Amount;
                }
            }

            return contributions;
        }

        public async Task<int> GetHighestContributionForRoundAsync(int gameId, string round)
        {
            var contributions = await GetPlayerContributionsForRoundAsync(gameId, round);
            return contributions.Any() ? contributions.Values.Max() : 0;
        }

        public async Task<bool> HasPlayerActedInRoundAsync(int gameId, int playerId, string round)
        {
            return await context.Moves
                .AnyAsync(m => m.GameId == gameId && m.PlayerId == playerId && m.Round == round);
        }

        public async Task<Move> GetLastMoveAsync(int gameId)
        {
            return await context.Moves
                .Where(m => m.GameId == gameId)
                .OrderByDescending(m => m.MoveTime)
                .FirstOrDefaultAsync();
        }
    }
}
