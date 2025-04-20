using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Moq;
using TexasHoldemPoker.API.Models;
using TexasHoldemPoker.API.Repositories;
using TexasHoldemPoker.API.Services;
using Xunit;

namespace TexasHoldemPoker.Tests
{
    public class PokerGameServiceTests
    {
        private readonly Mock<IGameRepository> _mockGameRepository;
        private readonly Mock<IGamePlayerRepository> _mockGamePlayerRepository;
        private readonly Mock<ICardRepository> _mockCardRepository;
        private readonly Mock<IMoveRepository> _mockMoveRepository;
        private readonly Mock<IChipTransactionRepository> _mockChipTransactionRepository;
        private readonly PokerGameService _gameService;

        public PokerGameServiceTests()
        {
            _mockGameRepository = new Mock<IGameRepository>();
            _mockGamePlayerRepository = new Mock<IGamePlayerRepository>();
            _mockCardRepository = new Mock<ICardRepository>();
            _mockMoveRepository = new Mock<IMoveRepository>();
            _mockChipTransactionRepository = new Mock<IChipTransactionRepository>();

            _gameService = new PokerGameService(
                _mockGameRepository.Object,
                _mockGamePlayerRepository.Object,
                _mockCardRepository.Object,
                _mockMoveRepository.Object,
                _mockChipTransactionRepository.Object
            );
        }

        [Fact]
        public async Task PlaceBetAsync_ReturnsFalse_WhenNotPlayersTurn()
        {
            // Arrange
            int gameId = 1;
            int userId = 2;
            int currentTurnUserId = 3; // Different user's turn

            var game = TestHelper.CreateTestGameWithCurrentTurn(gameId, currentTurnUserId: currentTurnUserId);
            var gamePlayer = TestHelper.CreateTestGamePlayer(gameId, userId);

            _mockGameRepository.Setup(r => r.GetByIdAsync(gameId)).ReturnsAsync(game);
            _mockGamePlayerRepository.Setup(r => r.GetPlayerByGameAndUserAsync(gameId, userId)).ReturnsAsync(gamePlayer);

            // Act
            var result = await _gameService.PlaceBetAsync(gameId, userId, "Call", 100);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public async Task PlaceBetAsync_ReturnsTrue_WhenPlayersTurn()
        {
            // Arrange
            int gameId = 1;
            int userId = 2;

            var game = TestHelper.CreateTestGameWithCurrentTurn(gameId, currentTurnUserId: userId);
            var gamePlayer = TestHelper.CreateTestGamePlayer(gameId, userId);

            var activePlayers = new List<GamePlayer>
            {
                gamePlayer,
                TestHelper.CreateTestGamePlayer(gameId, 3, seatPosition: 2)
            };

            _mockGameRepository.Setup(r => r.GetByIdAsync(gameId)).ReturnsAsync(game);
            _mockGamePlayerRepository.Setup(r => r.GetPlayerByGameAndUserAsync(gameId, userId)).ReturnsAsync(gamePlayer);
            _mockGamePlayerRepository.Setup(r => r.GetPlayersByGameIdAsync(gameId)).ReturnsAsync(activePlayers);
            _mockMoveRepository.Setup(r => r.RecordMoveAsync(gameId, userId, "Call", 100, "PreFlop")).ReturnsAsync(new Move());
            _mockGameRepository.Setup(r => r.SetCurrentTurnAsync(gameId, It.IsAny<int>())).ReturnsAsync(true);
            _mockMoveRepository.Setup(r => r.GetLastRoundMovesAsync(gameId, "PreFlop")).ReturnsAsync(new List<Move>());

            // Act
            var result = await _gameService.PlaceBetAsync(gameId, userId, "Call", 100);

            // Assert
            Assert.True(result);
            _mockMoveRepository.Verify(r => r.RecordMoveAsync(gameId, userId, "Call", 100, "PreFlop"), Times.Once);
            _mockGameRepository.Verify(r => r.SetCurrentTurnAsync(gameId, It.IsAny<int>()), Times.Once);
        }

        [Fact]
        public async Task StartGameAsync_SetsInitialTurn_AfterBigBlind()
        {
            // Arrange
            int gameId = 1;
            var table = TestHelper.CreateTestTable();
            var game = TestHelper.CreateTestGame(gameId);
            game.Table = table;

            var players = new List<GamePlayer>
            {
                TestHelper.CreateTestGamePlayer(gameId, 101, seatPosition: 1),
                TestHelper.CreateTestGamePlayer(gameId, 102, seatPosition: 2),
                TestHelper.CreateTestGamePlayer(gameId, 103, seatPosition: 3)
            };

            _mockGameRepository.Setup(r => r.GetByIdAsync(gameId)).ReturnsAsync(game);
            _mockGamePlayerRepository.Setup(r => r.GetPlayersByGameIdAsync(gameId)).ReturnsAsync(players);
            _mockGamePlayerRepository.Setup(r => r.SetDealerPositionAsync(gameId, It.IsAny<int>())).ReturnsAsync(true);
            _mockCardRepository.Setup(r => r.ClearGameCardsAsync(gameId)).ReturnsAsync(true);
            _mockCardRepository.Setup(r => r.GetAllCardsAsync()).ReturnsAsync(TestHelper.CreateTestDeck());
            _mockGamePlayerRepository.Setup(r => r.SetBlindPositionsAsync(gameId, It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(true);
            _mockMoveRepository.Setup(r => r.RecordMoveAsync(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>())).ReturnsAsync(new Move());
            _mockGameRepository.Setup(r => r.SetCurrentTurnAsync(gameId, It.IsAny<int>())).ReturnsAsync(true);
            _mockGameRepository.Setup(r => r.UpdateGameStateAsync(gameId, "PreFlop")).ReturnsAsync(true);
            _mockCardRepository.Setup(r => r.DealPlayerCardAsync(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(true);

            // Act
            var result = await _gameService.StartGameAsync(gameId);

            // Assert
            Assert.True(result);
            _mockGameRepository.Verify(r => r.SetCurrentTurnAsync(gameId, It.IsAny<int>()), Times.Once);
            _mockGameRepository.Verify(r => r.UpdateGameStateAsync(gameId, "PreFlop"), Times.Once);
        }

        [Fact]
        public async Task PlaceBetAsync_ReturnsFalse_WhenGameDoesNotExist()
        {
            // Arrange
            int gameId = 999;
            int userId = 1;

            _mockGameRepository.Setup(r => r.GetByIdAsync(gameId)).ReturnsAsync((Game)null);

            // Act
            var result = await _gameService.PlaceBetAsync(gameId, userId, "Call", 100);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public async Task PlaceBetAsync_ReturnsFalse_WhenGameHasEnded()
        {
            // Arrange
            int gameId = 1;
            int userId = 1;

            var game = TestHelper.CreateTestGame(gameId);
            game.EndTime = DateTime.UtcNow;

            _mockGameRepository.Setup(r => r.GetByIdAsync(gameId)).ReturnsAsync(game);

            // Act
            var result = await _gameService.PlaceBetAsync(gameId, userId, "Call", 100);

            // Assert
            Assert.False(result);
        }
    }
}
