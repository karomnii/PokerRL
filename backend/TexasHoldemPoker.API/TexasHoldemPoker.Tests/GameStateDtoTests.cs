using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Moq;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Models;
using TexasHoldemPoker.API.Repositories;
using TexasHoldemPoker.API.Services;
using Xunit;

namespace TexasHoldemPoker.Tests
{
    public class GameStateDtoTests
    {
        private readonly Mock<IGameRepository> _mockGameRepository;
        private readonly Mock<IGamePlayerRepository> _mockGamePlayerRepository;
        private readonly Mock<ICardRepository> _mockCardRepository;
        private readonly Mock<IMoveRepository> _mockMoveRepository;
        private readonly Mock<IChipTransactionRepository> _mockChipTransactionRepository;
        private readonly PokerGameService _gameService;

        public GameStateDtoTests()
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
        public async Task GetGameStateAsync_IncludesCurrentTurnUserId()
        {
            // Arrange
            int gameId = 1;
            int userId = 2;
            int currentTurnUserId = 3;

            var game = TestHelper.CreateTestGameWithCurrentTurn(gameId, currentTurnUserId: currentTurnUserId);
            game.Table = TestHelper.CreateTestTable();

            var user = TestHelper.CreateTestUser(userId, "TestUser");
            var gamePlayer = TestHelper.CreateTestGamePlayer(gameId, userId);
            gamePlayer.User = user;

            var players = new List<GamePlayer> { gamePlayer };

            _mockGameRepository.Setup(r => r.GetByIdAsync(gameId)).ReturnsAsync(game);
            _mockGamePlayerRepository.Setup(r => r.GetPlayersByGameIdAsync(gameId)).ReturnsAsync(players);
            _mockCardRepository.Setup(r => r.GetCommunityCardsByGameIdAsync(gameId)).ReturnsAsync(new List<Card>());
            _mockMoveRepository.Setup(r => r.GetMovesByGameIdAsync(gameId)).ReturnsAsync(new List<Move>());
            _mockCardRepository.Setup(r => r.GetPlayerCardsByGamePlayerIdAsync(It.IsAny<int>())).ReturnsAsync(new List<Card>());

            // Act
            var result = await _gameService.GetGameStateAsync(gameId, userId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(currentTurnUserId, result.CurrentTurnUserId);
        }

        [Fact]
        public async Task GetGameStateAsync_ReturnsCorrectPlayerCards_ForRequestingUser()
        {
            // Arrange
            int gameId = 1;
            int userId = 2;

            var game = TestHelper.CreateTestGame(gameId);
            game.Table = TestHelper.CreateTestTable();

            var user = TestHelper.CreateTestUser(userId, "TestUser");
            var gamePlayer = TestHelper.CreateTestGamePlayer(gameId, userId);
            gamePlayer.User = user;

            var players = new List<GamePlayer> { gamePlayer };

            var playerCards = new List<Card>
            {
                TestHelper.CreateTestCard(1, "Hearts", "A"),
                TestHelper.CreateTestCard(2, "Spades", "K")
            };

            _mockGameRepository.Setup(r => r.GetByIdAsync(gameId)).ReturnsAsync(game);
            _mockGamePlayerRepository.Setup(r => r.GetPlayersByGameIdAsync(gameId)).ReturnsAsync(players);
            _mockCardRepository.Setup(r => r.GetCommunityCardsByGameIdAsync(gameId)).ReturnsAsync(new List<Card>());
            _mockMoveRepository.Setup(r => r.GetMovesByGameIdAsync(gameId)).ReturnsAsync(new List<Move>());
            _mockCardRepository.Setup(r => r.GetPlayerCardsByGamePlayerIdAsync(It.IsAny<int>())).ReturnsAsync(playerCards);

            // Act
            var result = await _gameService.GetGameStateAsync(gameId, userId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(2, result.PlayerCards.Count);
            Assert.Contains(result.PlayerCards, c => c.Suit == "Hearts" && c.Value == "A");
            Assert.Contains(result.PlayerCards, c => c.Suit == "Spades" && c.Value == "K");
        }
    }
}
