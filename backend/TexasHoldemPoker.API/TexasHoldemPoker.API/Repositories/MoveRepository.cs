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

        public async Task<Move> GetByIdAsync(int moveId)
        {
            return await _context.Moves.FindAsync(moveId);
        }

        public async Task<IEnumerable<Move>> GetMovesByGameIdAsync(int gameId)
        {
            return await _context.Moves
                .Where(m => m.GameId == gameId)
                .OrderBy(m => m.MoveTime)
                .ToListAsync();
        }

        public async Task<IEnumerable<Move>> GetMovesByPlayerIdAsync(int gameId, int playerId)
        {
            return await _context.Moves
                .Where(m => m.GameId == gameId && m.PlayerId == playerId)
                .OrderBy(m => m.MoveTime)
                .ToListAsync();
        }

        public async Task<Move> RecordMoveAsync(int gameId, int playerId, string actionType, int amount, string round)
        {
            using (var transaction = await _context.Database.BeginTransactionAsync())
            {
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

                    _context.Moves.Add(move);

                    // Update game pot and player chips if needed
                    if (actionType == "Bet" || actionType == "Call" || actionType == "Raise" || actionType == "AllIn")
                    {
                        // Update pot size
                        var game = await _context.Games.FindAsync(gameId);
                        game.PotSize += amount;

                        // Update player's current chips
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
        }

        public async Task<IEnumerable<Move>> GetLastRoundMovesAsync(int gameId, string round)
        {
            return await _context.Moves
                .Where(m => m.GameId == gameId && m.Round == round)
                .OrderBy(m => m.MoveTime)
                .ToListAsync();
        }
    }
}
