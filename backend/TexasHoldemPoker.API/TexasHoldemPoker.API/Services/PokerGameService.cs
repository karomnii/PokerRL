using TexasHoldemPoker.API.Models;
using TexasHoldemPoker.API.Repositories;

namespace TexasHoldemPoker.API.Services
{
    public class PokerGameService : IPokerGameService
    {
        private readonly IGameRepository _gameRepository;
        private readonly IGamePlayerRepository _gamePlayerRepository;
        private readonly ICardRepository _cardRepository;
        private readonly IMoveRepository _moveRepository;
        private readonly IChipTransactionRepository _chipTransactionRepository;
        private readonly Random _random = new Random();

        public PokerGameService(
            IGameRepository gameRepository,
            IGamePlayerRepository gamePlayerRepository,
            ICardRepository cardRepository,
            IMoveRepository moveRepository,
            IChipTransactionRepository chipTransactionRepository)
        {
            _gameRepository = gameRepository;
            _gamePlayerRepository = gamePlayerRepository;
            _cardRepository = cardRepository;
            _moveRepository = moveRepository;
            _chipTransactionRepository = chipTransactionRepository;
        }

        public async Task<Game> CreateGameAsync(int tableId)
        {
            return await _gameRepository.CreateGameAsync(new Game { TableId = tableId });
        }

        public async Task<bool> JoinGameAsync(int gameId, int userId, int seatPosition, int buyInAmount)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "Waiting")
                return false;

            await _gamePlayerRepository.AddPlayerToGameAsync(gameId, userId, seatPosition, buyInAmount);
            return true;
        }

        public async Task<bool> LeaveGameAsync(int gameId, int userId)
        {
            var gamePlayer = await _gamePlayerRepository.GetPlayerByGameAndUserAsync(gameId, userId);
            if (gamePlayer == null)
                return false;

            return await _gamePlayerRepository.RemovePlayerFromGameAsync(gamePlayer.GamePlayerId);
        }

        public async Task<bool> StartGameAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "Waiting")
                return false;

            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            if (players.Count() < 2)
                return false;

            // Randomly select dealer
            int dealerIndex = _random.Next(players.Count());
            var dealer = players.ElementAt(dealerIndex);
            await _gamePlayerRepository.SetDealerPositionAsync(gameId, dealer.GamePlayerId);

            // Deal cards
            await DealCardsAsync(gameId);

            // Set small and big blinds
            int smallBlindIndex = (dealerIndex + 1) % players.Count();
            int bigBlindIndex = (dealerIndex + 2) % players.Count();

            var smallBlindPlayer = players.ElementAt(smallBlindIndex);
            var bigBlindPlayer = players.ElementAt(bigBlindIndex);

            await _gamePlayerRepository.SetBlindPositionsAsync(
                gameId,
                smallBlindPlayer.GamePlayerId,
                bigBlindPlayer.GamePlayerId);

            // Get table to determine blind amounts
            var table = game.Table;

            // Place blind bets
            await _moveRepository.RecordMoveAsync(
                gameId,
                smallBlindPlayer.UserId,
                "Bet",
                table.SmallBlind,
                "PreFlop");

            await _moveRepository.RecordMoveAsync(
                gameId,
                bigBlindPlayer.UserId,
                "Bet",
                table.BigBlind,
                "PreFlop");

            // Update game state
            await _gameRepository.UpdateGameStateAsync(gameId, "PreFlop");

            return true;
        }

        public async Task<bool> DealCardsAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "PreFlop")
                return false;

            // Clear any existing cards
            await _cardRepository.ClearGameCardsAsync(gameId);

            // Get all cards and shuffle
            var allCards = await _cardRepository.GetAllCardsAsync();
            var shuffledCards = allCards.OrderBy(c => Guid.NewGuid()).ToList();

            // Get all active players
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();

            int cardIndex = 0;

            // Deal two cards to each player
            foreach (var player in activePlayers)
            {
                await _cardRepository.DealPlayerCardAsync(player.GamePlayerId, shuffledCards[cardIndex++].CardId, 1);
                await _cardRepository.DealPlayerCardAsync(player.GamePlayerId, shuffledCards[cardIndex++].CardId, 2);
            }

            return true;
        }

        public async Task<bool> PlaceBetAsync(int gameId, int userId, string actionType, int amount)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.EndTime != null)
                return false;

            var gamePlayer = await _gamePlayerRepository.GetPlayerByGameAndUserAsync(gameId, userId);
            if (gamePlayer == null || !gamePlayer.IsActive)
                return false;

            // Validate action
            if (actionType == "Fold")
            {
                await _gamePlayerRepository.SetPlayerStatusAsync(gamePlayer.GamePlayerId, false);
                await _moveRepository.RecordMoveAsync(gameId, userId, actionType, 0, game.CurrentState);
            }
            else if (actionType == "Check")
            {
                await _moveRepository.RecordMoveAsync(gameId, userId, actionType, 0, game.CurrentState);
            }
            else if (actionType == "Call" || actionType == "Bet" || actionType == "Raise")
            {
                if (amount <= 0 || amount > gamePlayer.CurrentChips)
                    return false;

                await _moveRepository.RecordMoveAsync(gameId, userId, actionType, amount, game.CurrentState);
            }
            else if (actionType == "AllIn")
            {
                int allInAmount = gamePlayer.CurrentChips;
                await _moveRepository.RecordMoveAsync(gameId, userId, actionType, allInAmount, game.CurrentState);
            }
            else
            {
                return false;
            }

            // Check if round is complete (all active players have acted)
            var activePlayers = (await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId))
                .Where(p => p.IsActive)
                .ToList();

            var roundMoves = await _moveRepository.GetLastRoundMovesAsync(gameId, game.CurrentState);

            bool roundComplete = true;
            foreach (var player in activePlayers)
            {
                // Check if player has made a move in this round
                bool hasActed = roundMoves.Any(m => m.PlayerId == player.UserId);
                if (!hasActed)
                {
                    roundComplete = false;
                    break;
                }
            }

            // If round is complete, advance to next stage
            if (roundComplete)
            {
                if (game.CurrentState == "PreFlop")
                {
                    await DealFlopAsync(gameId);
                }
                else if (game.CurrentState == "Flop")
                {
                    await DealTurnAsync(gameId);
                }
                else if (game.CurrentState == "Turn")
                {
                    await DealRiverAsync(gameId);
                }
                else if (game.CurrentState == "River")
                {
                    await DetermineWinnerAsync(gameId);
                }
            }

            return true;
        }

        public async Task<bool> DealFlopAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "PreFlop")
                return false;

            // Get all cards that are not already dealt
            var allCards = await _cardRepository.GetAllCardsAsync();
            var dealtCards = new List<Card>();

            // Get player cards
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            foreach (var player in players)
            {
                var playerCards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);
                dealtCards.AddRange(playerCards);
            }

            // Get available cards
            var availableCards = allCards
                .Where(c => !dealtCards.Any(dc => dc.CardId == c.CardId))
                .OrderBy(c => Guid.NewGuid())
                .ToList();

            // Deal flop (3 community cards)
            await _cardRepository.DealCommunityCardAsync(gameId, availableCards[0].CardId, 1);
            await _cardRepository.DealCommunityCardAsync(gameId, availableCards[1].CardId, 2);
            await _cardRepository.DealCommunityCardAsync(gameId, availableCards[2].CardId, 3);

            // Update game state
            await _gameRepository.UpdateGameStateAsync(gameId, "Flop");

            return true;
        }

        public async Task<bool> DealTurnAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "Flop")
                return false;

            // Get all cards that are not already dealt
            var allCards = await _cardRepository.GetAllCardsAsync();
            var dealtCards = new List<Card>();

            // Get player cards
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            foreach (var player in players)
            {
                var playerCards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);
                dealtCards.AddRange(playerCards);
            }

            // Get community cards
            var communityCards = await _cardRepository.GetCommunityCardsByGameIdAsync(gameId);
            dealtCards.AddRange(communityCards);

            // Get available cards
            var availableCards = allCards
                .Where(c => !dealtCards.Any(dc => dc.CardId == c.CardId))
                .OrderBy(c => Guid.NewGuid())
                .ToList();

            // Deal turn (4th community card)
            await _cardRepository.DealCommunityCardAsync(gameId, availableCards[0].CardId, 4);

            // Update game state
            await _gameRepository.UpdateGameStateAsync(gameId, "Turn");

            return true;
        }

        public async Task<bool> DealRiverAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "Turn")
                return false;

            // Get all cards that are not already dealt
            var allCards = await _cardRepository.GetAllCardsAsync();
            var dealtCards = new List<Card>();

            // Get player cards
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            foreach (var player in players)
            {
                var playerCards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);
                dealtCards.AddRange(playerCards);
            }

            // Get community cards
            var communityCards = await _cardRepository.GetCommunityCardsByGameIdAsync(gameId);
            dealtCards.AddRange(communityCards);

            // Get available cards
            var availableCards = allCards
                .Where(c => !dealtCards.Any(dc => dc.CardId == c.CardId))
                .OrderBy(c => Guid.NewGuid())
                .ToList();

            // Deal river (5th community card)
            await _cardRepository.DealCommunityCardAsync(gameId, availableCards[0].CardId, 5);

            // Update game state
            await _gameRepository.UpdateGameStateAsync(gameId, "River");

            return true;
        }

        public async Task<bool> DetermineWinnerAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "River")
                return false;

            // Update game state to showdown
            await _gameRepository.UpdateGameStateAsync(gameId, "Showdown");

            // Get active players
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();

            // If only one active player remains, they win by default
            if (activePlayers.Count == 1)
            {
                var winner = activePlayers.First();
                await _gameRepository.EndGameAsync(gameId, winner.UserId);
                return true;
            }

            // Get community cards
            var communityCards = await _cardRepository.GetCommunityCardsByGameIdAsync(gameId);

            // Evaluate each player's hand and determine winner
            var playerHandRankings = new List<(int UserId, int HandRank)>();

            foreach (var player in activePlayers)
            {
                var playerCards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);

                // Combine player's hole cards with community cards
                var allCards = playerCards.Concat(communityCards).ToList();

                // Evaluate hand strength (simplified for this example)
                int handRank = PokerHandEvaluator.EvaluateHand(allCards);

                playerHandRankings.Add((player.UserId, handRank));
            }

            // Find player with highest hand rank
            var winningPlayer = playerHandRankings.OrderByDescending(p => p.HandRank).First();

            // End game with winner
            await _gameRepository.EndGameAsync(gameId, winningPlayer.UserId);

            return true;
        }

        public async Task<GameState> GetGameStateAsync(int gameId, int userId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null)
                return null;

            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var currentPlayer = players.FirstOrDefault(p => p.UserId == userId);

            // Get community cards
            var communityCards = await _cardRepository.GetCommunityCardsByGameIdAsync(gameId);

            // Get player's cards
            List<Card> playerCards = new List<Card>();
            if (currentPlayer != null)
            {
                playerCards = (await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(currentPlayer.GamePlayerId)).ToList();
            }

            // Get last moves
            var lastMoves = await _moveRepository.GetMovesByGameIdAsync(gameId);

            // Create player state objects
            var playerStates = players.Select(p => new PlayerState
            {
                UserId = p.UserId,
                Username = p.User.Username,
                SeatPosition = p.SeatPosition,
                ChipCount = p.CurrentChips,
                IsActive = p.IsActive,
                IsDealer = p.IsDealer,
                IsSmallBlind = p.IsSmallBlind,
                IsBigBlind = p.IsBigBlind,
                // Only include cards for the current player or if game is in showdown
                Cards = p.UserId == userId || game.CurrentState == "Showdown"
                    ? _cardRepository.GetPlayerCardsByGamePlayerIdAsync(p.GamePlayerId).Result.ToList()
                    : new List<Card>()
            }).ToList();

            return new GameState
            {
                GameId = game.GameId,
                TableId = game.TableId,
                TableName = game.Table.Name,
                CurrentState = game.CurrentState,
                PotSize = game.PotSize,
                CommunityCards = communityCards.ToList(),
                PlayerCards = playerCards,
                Players = playerStates,
                LastMoves = lastMoves.OrderByDescending(m => m.MoveTime).Take(10).ToList(),
                WinnerId = game.WinnerId
            };
        }
    }
}
