using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;
using TexasHoldemPoker.API.Repositories;
using TexasHoldemPoker.API.Services;
using Xunit;

namespace TexasHoldemPoker.Tests
{
    public class TurnLogicIntegrationTests
    {
        private DbContextOptions<PokerDbContext> GetDbContextOptions()
        {
            return new DbContextOptionsBuilder<PokerDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .ConfigureWarnings(w => w.Ignore(InMemoryEventId.TransactionIgnoredWarning))
                .Options;
        }


        private async Task<PokerDbContext> SetupGameWithPlayersAsync(DbContextOptions<PokerDbContext> options)
        {
            var context = new PokerDbContext(options);

            // Add a poker table
            context.PokerTables.Add(TestHelper.CreateTestTable());

            // Add users
            var users = new List<User>
            {
                TestHelper.CreateTestUser(1, "Player1"),
                TestHelper.CreateTestUser(2, "Player2"),
                TestHelper.CreateTestUser(3, "Player3")
            };
            context.Users.AddRange(users);

            // Add a game
            context.Games.Add(TestHelper.CreateTestGame());

            await context.SaveChangesAsync();

            return context;
        }

        [Fact]
        public async Task FullGameFlow_TurnLogicWorks_ForPreFlopRound()
        {
            // Arrange
            var options = GetDbContextOptions();
            var context = await SetupGameWithPlayersAsync(options);

            // Add players to the game
            var gamePlayers = new List<GamePlayer>
            {
                TestHelper.CreateTestGamePlayer(1, 1, 1),
                TestHelper.CreateTestGamePlayer(1, 2, 2),
                TestHelper.CreateTestGamePlayer(1, 3, 3)
            };
            context.GamePlayers.AddRange(gamePlayers);

            context.Cards.AddRange(TestHelper.CreateTestDeck());

            await context.SaveChangesAsync();

            // Create repositories
            var gameRepository = new GameRepository(context);
            var gamePlayerRepository = new GamePlayerRepository(context);
            var cardRepository = new CardRepository(context);
            var moveRepository = new MoveRepository(context);
            var chipTransactionRepository = new ChipTransactionRepository(context);

            // Create service
            var gameService = new PokerGameService(
                gameRepository,
                gamePlayerRepository,
                cardRepository,
                moveRepository,
                chipTransactionRepository
            );

            // Act - Start the game
            var startResult = await gameService.StartGameAsync(1);

            // Assert
            Assert.True(startResult);

            // Verify game state
            var game = await gameRepository.GetByIdAsync(1);
            Assert.Equal("PreFlop", game.CurrentState);
            Assert.NotNull(game.CurrentTurnUserId);

            // Find out whose turn it is
            var currentTurnUserId = game.CurrentTurnUserId.Value;

            // Act - Make a move with the wrong player (not their turn)
            var wrongPlayerId = currentTurnUserId == 1 ? 2 : 1;
            var wrongMoveResult = await gameService.PlaceBetAsync(1, wrongPlayerId, "Call", 20);

            // Assert - Move should fail
            Assert.False(wrongMoveResult);

            // Act - Make a valid move with the correct player
            var correctMoveResult = await gameService.PlaceBetAsync(1, currentTurnUserId, "Call", 20);

            // Assert - Move should succeed
            Assert.True(correctMoveResult);

            // Verify turn has moved to next player
            game = await gameRepository.GetByIdAsync(1);
            Assert.NotEqual(currentTurnUserId, game.CurrentTurnUserId);
        }

        [Fact]
        public async Task FullGameFlow_TurnAdvances_ThroughAllPlayers()
        {
            // Arrange
            var options = GetDbContextOptions();
            var context = await SetupGameWithPlayersAsync(options);

            // Add players to the game
            var gamePlayers = new List<GamePlayer>
            {
                TestHelper.CreateTestGamePlayer(1, 1, 1),
                TestHelper.CreateTestGamePlayer(1, 2, 2),
                TestHelper.CreateTestGamePlayer(1, 3, 3)
            };
            context.GamePlayers.AddRange(gamePlayers);

            // Add cards to the database
            context.Cards.AddRange(TestHelper.CreateTestDeck());

            await context.SaveChangesAsync();

            // Create repositories
            var gameRepository = new GameRepository(context);
            var gamePlayerRepository = new GamePlayerRepository(context);
            var cardRepository = new CardRepository(context);
            var moveRepository = new MoveRepository(context);
            var chipTransactionRepository = new ChipTransactionRepository(context);

            // Create service
            var gameService = new PokerGameService(
                gameRepository,
                gamePlayerRepository,
                cardRepository,
                moveRepository,
                chipTransactionRepository
            );

            // Act - Start the game
            await gameService.StartGameAsync(1);

            // Get the initial turn
            var game = await gameRepository.GetByIdAsync(1);
            var firstTurn = game.CurrentTurnUserId.Value;

            // Act - Make moves for all players
            var seenTurns = new HashSet<int>();
            seenTurns.Add(firstTurn);

            // First player makes a move
            await gameService.PlaceBetAsync(1, firstTurn, "Call", 20);

            // Get next player's turn
            game = await gameRepository.GetByIdAsync(1);
            var secondTurn = game.CurrentTurnUserId.Value;
            seenTurns.Add(secondTurn);

            // Second player makes a move
            await gameService.PlaceBetAsync(1, secondTurn, "Call", 20);

            // Get next player's turn
            game = await gameRepository.GetByIdAsync(1);
            var thirdTurn = game.CurrentTurnUserId.Value;
            seenTurns.Add(thirdTurn);

            // Assert - All players should have had a turn
            Assert.Equal(3, seenTurns.Count);
            Assert.Contains(1, seenTurns);
            Assert.Contains(2, seenTurns);
            Assert.Contains(3, seenTurns);
        }

        [Fact]
        public async Task FullGameFlow_PlayerFolds_IsSkippedInNextRound()
        {
            // Arrange
            var options = GetDbContextOptions();
            var context = await SetupGameWithPlayersAsync(options);

            // Add players to the game
            var gamePlayers = new List<GamePlayer>
    {
        TestHelper.CreateTestGamePlayer(1, 1, 1),
        TestHelper.CreateTestGamePlayer(1, 2, 2),
        TestHelper.CreateTestGamePlayer(1, 3, 3)
    };

            context.GamePlayers.AddRange(gamePlayers);

            // Add cards to the database
            context.Cards.AddRange(TestHelper.CreateTestDeck());
            await context.SaveChangesAsync();

            // Create repositories
            var gameRepository = new GameRepository(context);
            var gamePlayerRepository = new GamePlayerRepository(context);
            var cardRepository = new CardRepository(context);
            var moveRepository = new MoveRepository(context);
            var chipTransactionRepository = new ChipTransactionRepository(context);

            // Create service
            var gameService = new PokerGameService(
                gameRepository,
                gamePlayerRepository,
                cardRepository,
                moveRepository,
                chipTransactionRepository);

            // Act - Start the game
            await gameService.StartGameAsync(1);

            // Get the initial turn
            var game = await gameRepository.GetByIdAsync(1);
            var firstTurn = game.CurrentTurnUserId.Value;

            // First player folds
            await gameService.PlaceBetAsync(1, firstTurn, "Fold", 0);

            // No need to manually set player status - the service should handle this

            // Get next player's turn
            game = await gameRepository.GetByIdAsync(1);
            var secondTurn = game.CurrentTurnUserId.Value;

            // Second player calls
            await gameService.PlaceBetAsync(1, secondTurn, "Call", 20);

            // Get next player's turn
            game = await gameRepository.GetByIdAsync(1);
            var thirdTurn = game.CurrentTurnUserId.Value;

            // Third player calls
            await gameService.PlaceBetAsync(1, thirdTurn, "Call", 20);

            // Advance to the Flop round
            await gameService.DealFlopAsync(1);
            await gameService.SetFirstPlayerInRoundAsync(1);

            // Assert - The folded player should be skipped in next round
            game = await gameRepository.GetByIdAsync(1);

            // The active players should continue to take turns
            var activePlayers = await gamePlayerRepository.GetPlayersByGameIdAsync(1);
            var activePlayerIds = activePlayers.Where(p => p.IsActive).Select(p => p.UserId).ToList();

            Assert.Contains(game.CurrentTurnUserId.Value, activePlayerIds);
            Assert.DoesNotContain(firstTurn, activePlayerIds);

            // Simulate a complete betting round in the Flop
            var currentTurn = game.CurrentTurnUserId.Value;

            // First active player bets
            await gameService.PlaceBetAsync(1, currentTurn, "Bet", 20);

            // Get next active player
            game = await gameRepository.GetByIdAsync(1);
            var nextTurn = game.CurrentTurnUserId.Value;

            // Second active player calls
            await gameService.PlaceBetAsync(1, nextTurn, "Call", 20);

            // Verify the folded player was never given a turn
            var allMoves = await moveRepository.GetMovesByGameIdAsync(1);
            var flopMoves = allMoves.Where(m => m.Round == "Flop").ToList();

            Assert.DoesNotContain(flopMoves, m => m.PlayerId == firstTurn);
        }
    }
}
