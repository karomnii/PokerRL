using System;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Repositories;
using Xunit;

namespace TexasHoldemPoker.Tests
{
    public class GameRepositoryTests
    {
        private DbContextOptions<PokerDbContext> GetDbContextOptions()
        {
            return new DbContextOptionsBuilder<PokerDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;
        }

        [Fact]
        public async Task GetByIdAsync_ReturnsGame_WhenGameExists()
        {
            // Arrange
            var options = GetDbContextOptions();
            var gameId = 1;

            using (var context = new PokerDbContext(options))
            {
                context.PokerTables.Add(TestHelper.CreateTestTable());
                context.Games.Add(TestHelper.CreateTestGame(gameId));
                await context.SaveChangesAsync();
            }

            // Act
            using (var context = new PokerDbContext(options))
            {
                var repository = new GameRepository(context);
                var game = await repository.GetByIdAsync(gameId);

                // Assert
                Assert.NotNull(game);
                Assert.Equal(gameId, game.GameId);
            }
        }

        [Fact]
        public async Task SetCurrentTurnAsync_UpdatesCurrentTurnUserId()
        {
            // Arrange
            var options = GetDbContextOptions();
            var gameId = 1;
            var userId = 5;

            using (var context = new PokerDbContext(options))
            {
                context.Games.Add(TestHelper.CreateTestGame(gameId, currentState: "PreFlop"));
                await context.SaveChangesAsync();
            }

            // Act
            using (var context = new PokerDbContext(options))
            {
                var repository = new GameRepository(context);
                var result = await repository.SetCurrentTurnAsync(gameId, userId);

                // Assert
                Assert.True(result);
                var game = await context.Games.FindAsync(gameId);
                Assert.Equal(userId, game.CurrentTurnUserId);
            }
        }

        [Fact]
        public async Task GetCurrentTurnUserIdAsync_ReturnsCorrectUserId()
        {
            // Arrange
            var options = GetDbContextOptions();
            var gameId = 1;
            var userId = 5;

            using (var context = new PokerDbContext(options))
            {
                context.Games.Add(TestHelper.CreateTestGameWithCurrentTurn(gameId, currentTurnUserId: userId));
                await context.SaveChangesAsync();
            }

            // Act
            using (var context = new PokerDbContext(options))
            {
                var repository = new GameRepository(context);
                var result = await repository.GetCurrentTurnUserIdAsync(gameId);

                // Assert
                Assert.Equal(userId, result);
            }
        }

        [Fact]
        public async Task UpdateGameStateAsync_ChangesGameState()
        {
            // Arrange
            var options = GetDbContextOptions();
            var gameId = 1;
            var initialState = "PreFlop";
            var newState = "Flop";

            using (var context = new PokerDbContext(options))
            {
                context.Games.Add(TestHelper.CreateTestGame(gameId, currentState: initialState));
                await context.SaveChangesAsync();
            }

            // Act
            using (var context = new PokerDbContext(options))
            {
                var repository = new GameRepository(context);
                var result = await repository.UpdateGameStateAsync(gameId, newState);

                // Assert
                Assert.True(result);
                var game = await context.Games.FindAsync(gameId);
                Assert.Equal(newState, game.CurrentState);
            }
        }
    }
}
