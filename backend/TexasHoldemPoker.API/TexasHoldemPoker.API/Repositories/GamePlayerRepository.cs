using Microsoft.EntityFrameworkCore;

using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class GamePlayerRepository : IGamePlayerRepository
    {
        private readonly ApplicationDbContext context;
        private readonly IChipTransactionRepository chipTransactionRepository;

        public GamePlayerRepository(ApplicationDbContext context, IChipTransactionRepository chipTransactionRepository)
        {
            this.context = context;
            this.chipTransactionRepository = chipTransactionRepository;
        }

        public async Task<GamePlayer> GetByIdAsync(int gamePlayerId)
        {
            return await context.GamePlayers
                .Include(gp => gp.User)
                .Include(gp => gp.PlayerCards)
                .ThenInclude(pc => pc.Card)
                .FirstOrDefaultAsync(gp => gp.GamePlayerId == gamePlayerId);
        }

        public async Task<IEnumerable<GamePlayer>> GetPlayersByGameIdAsync(int gameId)
        {
            return await context.GamePlayers
                .Where(gp => gp.GameId == gameId)
                .Include(gp => gp.User)
                .OrderBy(gp => gp.SeatPosition)
                .ToListAsync();
        }

        public async Task<GamePlayer> GetPlayerByGameAndUserAsync(int gameId, int userId)
        {
            return await context.GamePlayers
                .Include(gp => gp.PlayerCards)
                .ThenInclude(pc => pc.Card)
                .FirstOrDefaultAsync(gp => gp.GameId == gameId && gp.UserId == userId);
        }

        public async Task<GamePlayer> AddPlayerToGameAsync(int gameId, int userId, int seatPosition, int buyInAmount)
        {
            using var transaction = await context.Database.BeginTransactionAsync();

            try
            {
                var user = await context.Users.FindAsync(userId);
                if (user == null || user.ChipsBalance < buyInAmount)
                    throw new InvalidOperationException("User doesn't have enough chips for buy-in");

                var seatTaken = await context.GamePlayers
                    .AnyAsync(gp => gp.GameId == gameId && gp.SeatPosition == seatPosition);

                if (seatTaken)
                    throw new InvalidOperationException("Seat position is already taken");

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

                context.GamePlayers.Add(gamePlayer);

                await chipTransactionRepository.RecordGameBuyInAsync(userId, gameId, buyInAmount);

                await context.SaveChangesAsync();
                await transaction.CommitAsync();

                return gamePlayer;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        // TODO: create logic for adding a model
        public async Task<GamePlayer> AddModelToGameAsync(int gameId, int userId, int seatPosition, int buyInAmount)
        {
            return new GamePlayer
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
        }

        public async Task<bool> UpdatePlayerChipsAsync(int gamePlayerId, int amount)
        {
            var gamePlayer = await context.GamePlayers.FindAsync(gamePlayerId);
            if (gamePlayer == null)
                return false;

            gamePlayer.CurrentChips = amount;
            await context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> SetPlayerStatusAsync(int gamePlayerId, bool isActive)
        {
            var gamePlayer = await context.GamePlayers.FindAsync(gamePlayerId);
            if (gamePlayer == null)
                return false;

            gamePlayer.IsActive = isActive;
            await context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> SetDealerPositionAsync(int gameId, int gamePlayerId)
        {
            using var transaction = await context.Database.BeginTransactionAsync();

            try
            {
                var players = await context.GamePlayers
                    .Where(gp => gp.GameId == gameId)
                    .ToListAsync();

                foreach (var player in players)
                {
                    player.IsDealer = false;
                }

                var newDealer = players.FirstOrDefault(p => p.GamePlayerId == gamePlayerId);
                if (newDealer == null)
                    return false;

                newDealer.IsDealer = true;

                await context.SaveChangesAsync();
                await transaction.CommitAsync();

                return true;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task<bool> SetBlindPositionsAsync(int gameId, int smallBlindPlayerId, int bigBlindPlayerId)
        {
            using var transaction = await context.Database.BeginTransactionAsync();

            try
            {
                var players = await context.GamePlayers
                    .Where(gp => gp.GameId == gameId)
                    .ToListAsync();

                foreach (var player in players)
                {
                    player.IsSmallBlind = false;
                    player.IsBigBlind = false;
                }

                var smallBlindPlayer = players.FirstOrDefault(p => p.GamePlayerId == smallBlindPlayerId);
                if (smallBlindPlayer == null)
                    return false;

                smallBlindPlayer.IsSmallBlind = true;

                var bigBlindPlayer = players.FirstOrDefault(p => p.GamePlayerId == bigBlindPlayerId);
                if (bigBlindPlayer == null)
                    return false;

                bigBlindPlayer.IsBigBlind = true;

                await context.SaveChangesAsync();
                await transaction.CommitAsync();

                return true;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task<bool> RemovePlayerFromGameAsync(int gamePlayerId)
        {
            var gamePlayer = await context.GamePlayers
                .FirstOrDefaultAsync(gp => gp.GamePlayerId == gamePlayerId);

            var gameRound = await context.GameRounds
                .Where(gr => gr.GameId == gamePlayer.GameId)
                .OrderByDescending(gr => gr.RoundNumber)
                .FirstOrDefaultAsync();

            if (gamePlayer == null)
                return false;

            if (gameRound.CurrentState != "Waiting" && gameRound.CurrentState != "Completed")
                return false;

            using var transaction = await context.Database.BeginTransactionAsync();

            try
            {
                var user = await context.Users.FindAsync(gamePlayer.UserId);
                user.ChipsBalance += gamePlayer.InitialChips;

                await chipTransactionRepository.RecordGameRefundAsync(gamePlayer.UserId, gamePlayer.GameId,
                    gamePlayer.InitialChips);

                context.GamePlayers.Remove(gamePlayer);

                await context.SaveChangesAsync();
                await transaction.CommitAsync();

                return true;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        // TODO: create logic for removing a model

        public async Task<bool> RemoveModelFromGameAsync(int gamePlayerId)
        {
            return true;
        }

        // TODO: might need to change logic to skip models

        public async Task<int> GetNextActivePlayerPositionAsync(int gameId, int currentPosition)
        {
            var players = await context.GamePlayers
                .Where(gp => gp.GameId == gameId && gp.IsActive)
                .OrderBy(gp => gp.SeatPosition)
                .ToListAsync();

            if (players.Count <= 1)
                return -1;

            var nextPlayer = players.FirstOrDefault(p => p.SeatPosition > currentPosition);

            if (nextPlayer == null)
                return players.First().SeatPosition;

            return nextPlayer.SeatPosition;
        }

        public async Task<int> GetNextActiveHumanPlayerPositionAsync(int gameId, int currentPosition)
        {
            var players = await context.GamePlayers
                .Include(gp => gp.User)
                .Where(gp => gp.GameId == gameId && gp.IsActive)
                .Where(gp => gp.User.IsBot != true)
                .OrderBy(gp => gp.SeatPosition)
                .ToListAsync();

            if (players.Count <= 1)
                return -1;

            var nextPlayer = players.FirstOrDefault(p => p.SeatPosition > currentPosition);

            if (nextPlayer == null)
                return players.First().SeatPosition;

            return nextPlayer.SeatPosition;
        }

        public async Task<GamePlayer> GetPlayerBySeatPositionAsync(int gameId, int seatPosition)
        {
            return await context.GamePlayers
                .FirstOrDefaultAsync(gp => gp.GameId == gameId && gp.SeatPosition == seatPosition);
        }
    }
}