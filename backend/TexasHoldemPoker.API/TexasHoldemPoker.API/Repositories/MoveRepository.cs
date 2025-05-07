using Microsoft.EntityFrameworkCore;

using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class MoveRepository : IMoveRepository
    {
        private readonly ApplicationDbContext _context;

        public MoveRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<Move> RecordMoveAsync(int gameId, int gameRoundId, int playerId, string actionType,
            int amount, string state)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var move = new Move
                {
                    GameId = gameId,
                    GameRoundId = gameRoundId,
                    PlayerId = playerId,
                    ActionType = actionType,
                    Amount = amount,
                    MoveTime = DateTime.UtcNow,
                    Round = state
                };

                _context.Moves.Add(move);

                if (actionType == "Bet" || actionType == "Call" || actionType == "Raise" || actionType == "AllIn" ||
                    actionType == "Blind")
                {
                    var game = await _context.Games.FindAsync(gameId);
                    game.PotSize += amount;

                    var gameRound = await _context.GameRounds.FindAsync(gameRoundId);
                    gameRound.PotSize += amount;

                    var gamePlayer = await _context.GamePlayers
                        .FirstOrDefaultAsync(gp => gp.GameId == gameId && gp.UserId == playerId);
                    gamePlayer.CurrentChips -= amount;
                }

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();

                return move;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task<IEnumerable<Move>> GetMovesByGameIdAsync(int gameId)
        {
            return await _context.Moves
                .Where(m => m.GameId == gameId)
                .OrderBy(m => m.MoveTime)
                .ToListAsync();
        }

        public async Task<IEnumerable<Move>> GetLastRoundMovesAsync(int gameId, int gameRoundId, string state)
        {
            return await _context.Moves
                .Where(m => m.GameId == gameId && m.Round == state && m.GameRoundId == gameRoundId)
                .OrderBy(m => m.MoveTime)
                .ToListAsync();
        }

        public async Task<Dictionary<int, int>> GetPlayerContributionsForRoundAsync(int gameId, int gameRoundId,
            string state)
        {
            var moves = await _context.Moves
                .Where(m => m.GameId == gameId && m.Round == state && m.GameRoundId == gameRoundId)
                .ToListAsync();

            var contributions = new Dictionary<int, int>();

            foreach (var move in moves)
            {
                if (contributions.ContainsKey(move.PlayerId) &&
                    (move.ActionType == "Bet" || move.ActionType == "Call" ||
                     move.ActionType == "Raise" || move.ActionType == "AllIn" || move.ActionType == "Blind"))
                {
                    contributions[move.PlayerId] += move.Amount;
                }
                else if (!contributions.ContainsKey(move.PlayerId))
                {
                    contributions[move.PlayerId] = 0;

                    if (move.ActionType == "Bet" || move.ActionType == "Call" ||
                        move.ActionType == "Raise" || move.ActionType == "AllIn" || move.ActionType == "Blind")
                    {
                        contributions[move.PlayerId] = move.Amount;
                    }
                }
            }

            return contributions;
        }

        public async Task<int> GetHighestContributionForRoundAsync(int gameId, int gameRoundId, string state)
        {
            var contributions = await GetPlayerContributionsForRoundAsync(gameId, gameRoundId, state);
            return contributions.Any() ? contributions.Values.Max() : 0;
        }

        public async Task<bool> HasPlayerActedInRoundAsync(int gameId, int gameRoundId, int playerId, string state)
        {
            return await _context.Moves
                .AnyAsync(m =>
                    m.GameId == gameId && m.PlayerId == playerId && m.Round == state && m.GameRoundId == gameRoundId);
        }

        public async Task<Move> GetLastMoveAsync(int gameId)
        {
            return await _context.Moves
                .Where(m => m.GameId == gameId)
                .OrderByDescending(m => m.MoveTime)
                .FirstOrDefaultAsync();
        }

        public async Task<IEnumerable<Move>> GetMovesByGameRoundAsync(int gameId, int gameRoundId, string state)
        {
            return await _context.Moves
                .Where(m => m.GameId == gameId && m.GameRoundId == gameRoundId && m.Round == state)
                .OrderByDescending(m => m.MoveTime)
                .ToListAsync();
        }
    }
}