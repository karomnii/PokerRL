using Microsoft.EntityFrameworkCore;

using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class MoveRepository : IMoveRepository
    {
        private readonly ApplicationDbContext _context;
        public MoveRepository(ApplicationDbContext context) => _context = context;

        public async Task<Move> RecordMoveAsync(int gameRoundId, int playerId,
            string actionType, int amount, string state)
        {
            await using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var move = new Move
                {
                    GameRoundId = gameRoundId,
                    PlayerId = playerId,
                    ActionType = actionType,
                    Amount = amount,
                    MoveTime = DateTime.UtcNow,
                    Round = state
                };

                await _context.Moves.AddAsync(move);

                if (actionType is "Bet" or "Call" or "Raise" or "AllIn" or "Blind")
                {
                    var gameRound = await _context.GameRounds
                        .Include(gr => gr.Game)
                        .FirstAsync(gr => gr.GameRoundId == gameRoundId);
                    
                    gameRound.PotSize += amount;
                    
                    var gamePlayer = await _context.GamePlayers
                        .FirstAsync(gp => gp.GameId == gameRound.GameId && gp.UserId == playerId);
                    
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
        
        public async Task<IEnumerable<Move>> GetMovesByGameIdAsync(int gameId) =>
            await _context.Moves
                .Include(m => m.GameRound)
                .Where(m => m.GameRound.GameId == gameId)
                .OrderBy(m => m.MoveTime)
                .ToListAsync();
        
        public async Task<IEnumerable<Move>> GetMovesByGameRoundAsync(int gameRoundId, string state) =>
            await _context.Moves
                .Where(m => m.GameRoundId == gameRoundId && m.Round == state)
                .OrderByDescending(m => m.MoveTime)
                .ToListAsync();

        public async Task<Dictionary<int, int>> GetPlayerContributionsForRoundAsync(int gameRoundId,
            string state)
        {
            var moves = await _context.Moves
                .Where(m => m.GameRoundId == gameRoundId && m.Round == state)
                .ToListAsync();

            var contributions = new Dictionary<int, int>();

            foreach (var move in moves)
            {
                bool hasMoved = move.ActionType is "Bet" or "Call" or "Raise" or "AllIn" or "Blind";
                
                if (contributions.ContainsKey(move.PlayerId) && hasMoved)
                    contributions[move.PlayerId] += move.Amount;
                
                if (!contributions.ContainsKey(move.PlayerId))
                {
                    contributions[move.PlayerId] = 0;
                    if (hasMoved)
                        contributions[move.PlayerId] = move.Amount;
                }
            }
            return contributions;
        }

        public async Task<int> GetHighestContributionForRoundAsync(int gameRoundId, string state)
        {
            var contributions = await GetPlayerContributionsForRoundAsync(gameRoundId, state);
            return contributions.Any() ? contributions.Values.Max() : 0;
        }

        public async Task<bool> HasPlayerActedInRoundAsync(int gameRoundId, int playerId, string state) =>
            await _context.Moves.AnyAsync(m =>
                m.GameRoundId == gameRoundId &&
                m.PlayerId == playerId &&
                m.Round == state);

        public async Task<Move> GetLastMoveAsync(int gameRoundId)
        {
            var move = await _context.Moves
                .Where(m => m.GameRoundId == gameRoundId)
                .OrderByDescending(m => m.MoveTime)
                .FirstOrDefaultAsync();
            
            return move ?? throw new InvalidOperationException(
                $"W rundzie {gameRoundId} nie ma ruchow");
        }
    }
}