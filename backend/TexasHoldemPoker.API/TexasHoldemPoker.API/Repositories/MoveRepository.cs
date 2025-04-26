using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class MoveRepository : IMoveRepository
    {
        private readonly PokerDbContext _context;

        public MoveRepository(PokerDbContext context)
        {
            _context = context;
        }

        public async Task<Move> RecordMoveAsync(int gameId, int gameRoundId, int playerId, string actionType, int amount, string round)
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
                    Round = round
                };

                _context.Moves.Add(move);

                if (actionType == "Bet" || actionType == "Call" || actionType == "Raise" || actionType == "AllIn")
                {
                    var game = await _context.Games.FindAsync(gameId);
                    game.PotSize += amount;

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

        public async Task<IEnumerable<Move>> GetLastRoundMovesAsync(int gameId, int gameRoundId, string round)
        {
            return await _context.Moves
                .Where(m => m.GameId == gameId && m.Round == round && m.GameRoundId == gameRoundId)
                .OrderBy(m => m.MoveTime)
                .ToListAsync();
        }

        public async Task<Dictionary<int, int>> GetPlayerContributionsForRoundAsync(int gameId, int gameRoundId, string round)
        {
            var moves = await _context.Moves
                .Where(m => m.GameId == gameId && m.Round == round && m.GameRoundId == gameRoundId)
                .ToListAsync();

            var contributions = new Dictionary<int, int>();

            foreach (var move in moves)
            {
                if (contributions.ContainsKey(move.PlayerId) &&
                    (move.ActionType == "Bet" || move.ActionType == "Call" ||
                     move.ActionType == "Raise" || move.ActionType == "AllIn"))
                {
                    contributions[move.PlayerId] += move.Amount;
                }
                else if (!contributions.ContainsKey(move.PlayerId))
                {
                    contributions[move.PlayerId] = 0;

                    if (move.ActionType == "Bet" || move.ActionType == "Call" ||
                        move.ActionType == "Raise" || move.ActionType == "AllIn")
                    {
                        contributions[move.PlayerId] = move.Amount;
                    }
                }
            }

            return contributions;
        }

        public async Task<int> GetHighestContributionForRoundAsync(int gameId, int gameRoundId, string round)
        {
            var contributions = await GetPlayerContributionsForRoundAsync(gameId, gameRoundId, round);
            return contributions.Any() ? contributions.Values.Max() : 0;
        }

        public async Task<bool> HasPlayerActedInRoundAsync(int gameId, int gameRoundId, int playerId, string round)
        {
            return await _context.Moves
                .AnyAsync(m => m.GameId == gameId && m.PlayerId == playerId && m.Round == round && m.GameRoundId == gameRoundId);
        }

        public async Task<Move> GetLastMoveAsync(int gameId)
        {
            return await _context.Moves
                .Where(m => m.GameId == gameId)
                .OrderByDescending(m => m.MoveTime)
                .FirstOrDefaultAsync();
        }

        public async Task<IEnumerable<Move>> GetMovesByGameRoundAsync(int gameId, int gameRoundId)
        {
            return await _context.Moves
                .Where(m => m.GameId == gameId && m.GameRoundId == gameRoundId)
                .OrderByDescending(m => m.MoveTime)
                .ToListAsync();
        }
    }
}