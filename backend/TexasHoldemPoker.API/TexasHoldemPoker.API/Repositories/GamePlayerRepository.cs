using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class GamePlayerRepository : IGamePlayerRepository
    {
        private readonly PokerDbContext _context;

        public GamePlayerRepository(PokerDbContext context)
        {
            _context = context;
        }

        public async Task<GamePlayer> GetByIdAsync(int gamePlayerId)
        {
            return await _context.GamePlayers
                .Include(gp => gp.User)
                .Include(gp => gp.PlayerCards)
                    .ThenInclude(pc => pc.Card)
                .FirstOrDefaultAsync(gp => gp.GamePlayerId == gamePlayerId);
        }

        public async Task<IEnumerable<GamePlayer>> GetPlayersByGameIdAsync(int gameId)
        {
            return await _context.GamePlayers
                .Where(gp => gp.GameId == gameId)
                .Include(gp => gp.User)
                .OrderBy(gp => gp.SeatPosition)
                .ToListAsync();
        }

        public async Task<GamePlayer> GetPlayerByGameAndUserAsync(int gameId, int userId)
        {
            return await _context.GamePlayers
                .Include(gp => gp.PlayerCards)
                    .ThenInclude(pc => pc.Card)
                .FirstOrDefaultAsync(gp => gp.GameId == gameId && gp.UserId == userId);
        }

        public async Task<GamePlayer> AddPlayerToGameAsync(int gameId, int userId, int seatPosition, int buyInAmount)
        {
            using (var transaction = await _context.Database.BeginTransactionAsync())
            {
                try
                {
                    // Check if user has enough chips
                    var user = await _context.Users.FindAsync(userId);
                    if (user == null || user.ChipsBalance < buyInAmount)
                        throw new InvalidOperationException("User doesn't have enough chips for buy-in");

                    // Check if seat is available
                    var seatTaken = await _context.GamePlayers
                        .AnyAsync(gp => gp.GameId == gameId && gp.SeatPosition == seatPosition);
                    if (seatTaken)
                        throw new InvalidOperationException("Seat position is already taken");

                    // Deduct chips from user balance
                    user.ChipsBalance -= buyInAmount;

                    // Add player to game
                    var gamePlayer = new GamePlayer
                    {
                        GameId = gameId,
                        UserId = userId,
                        SeatPosition = seatPosition,
                        InitialChips = buyInAmount,
                        CurrentChips = buyInAmount,
                        IsActive = true,
                        IsDealer = false,
                        IsSmallBlind = false,
                        IsBigBlind = false
                    };

                    _context.GamePlayers.Add(gamePlayer);

                    // Log transaction
                    var chipTransaction = new ChipTransaction
                    {
                        UserId = userId,
                        Amount = -buyInAmount,
                        TransactionType = "GameLoss",
                        ReferenceId = gameId,
                        TransactionDate = DateTime.UtcNow,
                        Description = $"Buy-in for game {gameId}"
                    };

                    _context.ChipTransactions.Add(chipTransaction);
                    await _context.SaveChangesAsync();

                    await transaction.CommitAsync();
                    return gamePlayer;
                }
                catch
                {
                    await transaction.RollbackAsync();
                    throw;
                }
            }
        }

        public async Task<bool> UpdatePlayerChipsAsync(int gamePlayerId, int amount)
        {
            var gamePlayer = await _context.GamePlayers.FindAsync(gamePlayerId);
            if (gamePlayer == null) return false;

            gamePlayer.CurrentChips += amount;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> SetPlayerStatusAsync(int gamePlayerId, bool isActive)
        {
            var gamePlayer = await _context.GamePlayers.FindAsync(gamePlayerId);
            if (gamePlayer == null) return false;

            gamePlayer.IsActive = isActive;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> SetDealerPositionAsync(int gameId, int gamePlayerId)
        {
            using (var transaction = await _context.Database.BeginTransactionAsync())
            {
                try
                {
                    // Reset all dealer positions for this game
                    var players = await _context.GamePlayers
                        .Where(gp => gp.GameId == gameId)
                        .ToListAsync();

                    foreach (var player in players)
                    {
                        player.IsDealer = false;
                    }

                    // Set new dealer
                    var newDealer = players.FirstOrDefault(p => p.GamePlayerId == gamePlayerId);
                    if (newDealer == null) return false;

                    newDealer.IsDealer = true;
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
        }

        public async Task<bool> SetBlindPositionsAsync(int gameId, int smallBlindPlayerId, int bigBlindPlayerId)
        {
            using (var transaction = await _context.Database.BeginTransactionAsync())
            {
                try
                {
                    // Reset all blind positions for this game
                    var players = await _context.GamePlayers
                        .Where(gp => gp.GameId == gameId)
                        .ToListAsync();

                    foreach (var player in players)
                    {
                        player.IsSmallBlind = false;
                        player.IsBigBlind = false;
                    }

                    // Set new small blind
                    var smallBlindPlayer = players.FirstOrDefault(p => p.GamePlayerId == smallBlindPlayerId);
                    if (smallBlindPlayer == null) return false;
                    smallBlindPlayer.IsSmallBlind = true;

                    // Set new big blind
                    var bigBlindPlayer = players.FirstOrDefault(p => p.GamePlayerId == bigBlindPlayerId);
                    if (bigBlindPlayer == null) return false;
                    bigBlindPlayer.IsBigBlind = true;

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
        }

        public async Task<bool> RemovePlayerFromGameAsync(int gamePlayerId)
        {
            var gamePlayer = await _context.GamePlayers
                .Include(gp => gp.Game)
                .FirstOrDefaultAsync(gp => gp.GamePlayerId == gamePlayerId);

            if (gamePlayer == null) return false;

            // Only allow removal if game is in Waiting state
            if (gamePlayer.Game.CurrentState != "Waiting")
                return false;

            using (var transaction = await _context.Database.BeginTransactionAsync())
            {
                try
                {
                    // Return chips to user
                    var user = await _context.Users.FindAsync(gamePlayer.UserId);
                    user.ChipsBalance += gamePlayer.InitialChips;

                    // Log transaction
                    var chipTransaction = new ChipTransaction
                    {
                        UserId = gamePlayer.UserId,
                        Amount = gamePlayer.InitialChips,
                        TransactionType = "Refund",
                        ReferenceId = gamePlayer.GameId,
                        TransactionDate = DateTime.UtcNow,
                        Description = $"Refund from leaving game {gamePlayer.GameId}"
                    };

                    _context.ChipTransactions.Add(chipTransaction);

                    // Remove player from game
                    _context.GamePlayers.Remove(gamePlayer);
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
        }
    }
}
