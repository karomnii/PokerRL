using Microsoft.AspNetCore.SignalR;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Hubs;
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
        private readonly IGameRoundRepository _gameRoundRepository;
        private readonly IGameRoundWinnerRepository _gameRoundWinnerRepository;
        private readonly IHubContext<GameHub> _hubContext;
        private readonly Random _random = new Random();
        private Dictionary<int, HashSet<int>> _gameResultAcknowledgments = new Dictionary<int, HashSet<int>>();

        public PokerGameService(
            IGameRepository gameRepository,
            IGamePlayerRepository gamePlayerRepository,
            ICardRepository cardRepository,
            IMoveRepository moveRepository,
            IChipTransactionRepository chipTransactionRepository,
            IGameRoundRepository gameRoundRepository,
            IGameRoundWinnerRepository gameRoundWinnerRepository,
            IHubContext<GameHub> hubContext)
        {
            _gameRepository = gameRepository;
            _gamePlayerRepository = gamePlayerRepository;
            _cardRepository = cardRepository;
            _moveRepository = moveRepository;
            _chipTransactionRepository = chipTransactionRepository;
            _gameRoundRepository = gameRoundRepository;
            _gameRoundWinnerRepository = gameRoundWinnerRepository;
            _hubContext = hubContext;
        }

        public async Task<Game> CreateGameAsync(int tableId)
        {
            var game = await _gameRepository.CreateGameAsync(new Game
            {
                TableId = tableId,
                CurrentState = "Waiting"
            });

            return game;
        }

        public async Task<bool> JoinGameAsync(int gameId, int userId, int seatPosition, int buyInAmount)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "Waiting")
                return false;

            try
            {
                await _gamePlayerRepository.AddPlayerToGameAsync(gameId, userId, seatPosition, buyInAmount);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public async Task<bool> LeaveGameAsync(int gameId, int userId)
        {
            var gamePlayer = await _gamePlayerRepository.GetPlayerByGameAndUserAsync(gameId, userId);
            if (gamePlayer == null)
                return false;

            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null)
                return false;

            // Only allow leaving if game is in Waiting state
            if (game.CurrentState != "Waiting")
                return false;

            var result = await _gamePlayerRepository.RemovePlayerFromGameAsync(gamePlayer.GamePlayerId);

            return result;
        }

        public async Task<bool> StartGameAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "Waiting")
                return false;

            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();

            // Need at least 2 players to start
            if (activePlayers.Count < 2)
                return false;

            // Clear any cards from previous games
            await _cardRepository.ClearGameCardsAsync(gameId);

            // Set dealer and blinds
            await SetInitialDealerAndBlindsAsync(gameId, activePlayers);

            // Deal cards to players
            await DealCardsAsync(gameId);

            // Create a new game round
            var gameRound = await _gameRoundRepository.StartNewRoundAsync(gameId);

            // Set game state to PreFlop
            await _gameRepository.UpdateGameStateAsync(gameId, "PreFlop");

            // Collect blinds
            await CollectBlindsAsync(gameId, activePlayers);

            // Set first player to act (after big blind)
            await SetFirstPlayerToActAsync(gameId);

            // Notify all clients about game start
            await _hubContext.Clients.Group($"Game{gameId}")
                .SendAsync("ReceiveGameUpdate", await GetGameStateAsync(gameId, 0));

            return true;
        }

        private async Task SetInitialDealerAndBlindsAsync(int gameId, List<GamePlayer> activePlayers)
        {
            // Randomly select dealer for first game
            int dealerIndex = _random.Next(activePlayers.Count);
            var dealer = activePlayers[dealerIndex];

            // Set dealer position
            await _gamePlayerRepository.SetDealerPositionAsync(gameId, dealer.GamePlayerId);

            // Set small blind (next player after dealer)
            int sbIndex = (dealerIndex + 1) % activePlayers.Count;

            // Set big blind (next player after small blind)
            int bbIndex = (dealerIndex + 2) % activePlayers.Count;

            // Set blind positions
            await _gamePlayerRepository.SetBlindPositionsAsync(
                gameId,
                activePlayers[sbIndex].GamePlayerId,
                activePlayers[bbIndex].GamePlayerId);
        }

        private async Task CollectBlindsAsync(int gameId, List<GamePlayer> activePlayers)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null) return;

            var table = await _gameRepository.GetGameTableAsync(gameId);
            if (table == null) return;

            // Find small blind player
            var sbPlayer = activePlayers.FirstOrDefault(p => p.IsSmallBlind);
            if (sbPlayer != null)
            {
                int sbAmount = Math.Min(table.SmallBlind, sbPlayer.CurrentChips);

                // Record small blind move
                await _moveRepository.RecordMoveAsync(
                    gameId,
                    sbPlayer.UserId,
                    "Bet",
                    sbAmount,
                    "PreFlop");

                // Update player chips
                await _gamePlayerRepository.UpdatePlayerChipsAsync(
                    sbPlayer.GamePlayerId,
                    sbPlayer.CurrentChips - sbAmount);

                // Update pot size
                await _gameRepository.UpdatePotSizeAsync(gameId, game.PotSize + sbAmount);

                // Update round pot size
                var currentRound = await _gameRoundRepository.GetCurrentRoundAsync(gameId);
                if (currentRound != null)
                {
                    await _gameRoundRepository.UpdatePotSizeAsync(currentRound.GameRoundId,
                        currentRound.PotSize + sbAmount);
                }
            }

            // Find big blind player
            var bbPlayer = activePlayers.FirstOrDefault(p => p.IsBigBlind);
            if (bbPlayer != null)
            {
                int bbAmount = Math.Min(table.BigBlind, bbPlayer.CurrentChips);

                // Record big blind move
                await _moveRepository.RecordMoveAsync(
                    gameId,
                    bbPlayer.UserId,
                    "Bet",
                    bbAmount,
                    "PreFlop");

                // Update player chips
                await _gamePlayerRepository.UpdatePlayerChipsAsync(
                    bbPlayer.GamePlayerId,
                    bbPlayer.CurrentChips - bbAmount);

                // Update pot size
                await _gameRepository.UpdatePotSizeAsync(gameId, game.PotSize + bbAmount);

                // Update round pot size
                var currentRound = await _gameRoundRepository.GetCurrentRoundAsync(gameId);
                if (currentRound != null)
                {
                    await _gameRoundRepository.UpdatePotSizeAsync(currentRound.GameRoundId,
                        currentRound.PotSize + bbAmount);
                }
            }
        }

        private async Task SetFirstPlayerToActAsync(int gameId)
        {
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).OrderBy(p => p.SeatPosition).ToList();

            if (activePlayers.Count <= 2)
            {
                // In heads-up (2 players), small blind acts first pre-flop
                var smallBlind = activePlayers.FirstOrDefault(p => p.IsSmallBlind);
                if (smallBlind != null)
                {
                    await _gameRepository.SetCurrentTurnAsync(gameId, smallBlind.UserId);
                    await _hubContext.Clients.User(smallBlind.UserId.ToString()).SendAsync("YourTurn", gameId);
                    return;
                }
            }

            // Find big blind player
            var bbPlayer = activePlayers.FirstOrDefault(p => p.IsBigBlind);
            if (bbPlayer == null) return;

            // Find the player after big blind
            int bbIndex = activePlayers.IndexOf(bbPlayer);
            int nextPlayerIndex = (bbIndex + 1) % activePlayers.Count;

            var nextPlayer = activePlayers[nextPlayerIndex];

            // Set next player as current turn
            await _gameRepository.SetCurrentTurnAsync(gameId, nextPlayer.UserId);
        }

        public async Task<bool> DealCardsAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "Waiting")
                return false;

            // Clear any existing cards
            await _cardRepository.ClearGameCardsAsync(gameId);

            // Get all cards
            var allCards = await _cardRepository.GetAllCardsAsync();

            // Shuffle cards
            var shuffledCards = ShuffleCards(allCards.ToList());

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

        private List<Card> ShuffleCards(List<Card> cards)
        {
            Random rng = new Random();
            int n = cards.Count;

            // Fisher-Yates shuffle algorithm
            while (n > 1)
            {
                n--;
                int k = rng.Next(n + 1);
                Card temp = cards[k];
                cards[k] = cards[n];
                cards[n] = temp;
            }

            return cards;
        }

        public async Task<bool> PlaceBetAsync(int gameId, int userId, string actionType, int amount)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentTurnUserId != userId)
                return false;

            var gamePlayer = await _gamePlayerRepository.GetPlayerByGameAndUserAsync(gameId, userId);
            if (gamePlayer == null || !gamePlayer.IsActive)
                return false;

            // Get current round
            var currentRound = await _gameRoundRepository.GetCurrentRoundAsync(gameId);
            if (currentRound == null)
                return false;

            // Get table for blinds info
            var table = await _gameRepository.GetGameTableAsync(gameId);
            if (table == null)
                return false;

            // Get all players' contributions in current round
            var playerContributions =
                await _moveRepository.GetPlayerContributionsForRoundAsync(gameId, game.CurrentState);

            // Calculate how much this player has contributed so far
            int currentPlayerContribution = playerContributions.GetValueOrDefault(userId, 0);

            // Get highest contribution in the round
            int highestContributionInRound =
                await _moveRepository.GetHighestContributionForRoundAsync(gameId, game.CurrentState);

            // Calculate how much player needs to call
            int amountToCall = highestContributionInRound - currentPlayerContribution;

            // Get active players
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();

            // Find the size of the last raise/bet for minimum raise calculation
            var roundMoves = await _moveRepository.GetLastRoundMovesAsync(gameId, game.CurrentState);
            var lastAggressiveMove = roundMoves
                .Where(m => m.ActionType == "Bet" || m.ActionType == "Raise")
                .OrderByDescending(m => m.MoveTime)
                .FirstOrDefault();

            int minRaiseAmount = lastAggressiveMove?.Amount ?? table.BigBlind; // Default to BB if no prior aggression

            // Validate the move based on action type
            bool isValidMove = false;
            int effectiveAmount = amount;

            switch (actionType)
            {
                case "Fold":
                    // Fold is always allowed
                    isValidMove = true;
                    effectiveAmount = 0;
                    break;

                case "Check":
                    // Check is only allowed if there's nothing to call
                    if (amountToCall == 0)
                    {
                        isValidMove = true;
                        effectiveAmount = 0;
                    }

                    break;

                case "Call":
                    // Call is only allowed if there's something to call
                    if (amountToCall > 0)
                    {
                        // Adjust for all-in situations
                        int callAmount = Math.Min(amountToCall, gamePlayer.CurrentChips);

                        // Allow the call if amount matches or player is all-in
                        if (amount == callAmount || callAmount == gamePlayer.CurrentChips)
                        {
                            isValidMove = true;
                            effectiveAmount = callAmount;
                        }
                    }

                    break;

                case "Bet":
                    // Bet is only allowed if no one has bet yet
                    if (highestContributionInRound == 0)
                    {
                        // Bet must be at least the big blind
                        if (amount >= table.BigBlind && amount <= gamePlayer.CurrentChips)
                        {
                            isValidMove = true;
                            effectiveAmount = amount;
                        }
                    }

                    break;

                case "Raise":
                    // Raise is only allowed if there was a prior bet/raise
                    if (highestContributionInRound > 0)
                    {
                        // Calculate total amount player would be putting in
                        int totalBetSize = currentPlayerContribution + amount;

                        // Calculate minimum required total bet size
                        int requiredTotalSize = highestContributionInRound + minRaiseAmount;

                        // Ensure raise is sufficient or player is all-in
                        if (totalBetSize >= requiredTotalSize || amount == gamePlayer.CurrentChips)
                        {
                            isValidMove = true;
                            effectiveAmount = amount;
                        }
                    }

                    break;

                case "AllIn":
                    // All-in is always allowed if player has chips
                    if (gamePlayer.CurrentChips > 0)
                    {
                        isValidMove = true;
                        effectiveAmount = gamePlayer.CurrentChips;
                    }

                    break;
            }

            if (!isValidMove)
                return false;

            // Execute the move
            if (actionType == "Fold")
            {
                // Mark player as inactive
                await _gamePlayerRepository.SetPlayerStatusAsync(gamePlayer.GamePlayerId, false);

                // Record the fold move
                await _moveRepository.RecordMoveAsync(gameId, userId, actionType, 0, game.CurrentState);
            }
            else
            {
                // For all other actions, update chips and pot
                if (effectiveAmount > 0)
                {
                    // Update player chips
                    await _gamePlayerRepository.UpdatePlayerChipsAsync(gamePlayer.GamePlayerId,
                        gamePlayer.CurrentChips - effectiveAmount);

                    // Update pot size
                    await _gameRepository.UpdatePotSizeAsync(gameId, game.PotSize + effectiveAmount);

                    // Update round pot size
                    await _gameRoundRepository.UpdatePotSizeAsync(currentRound.GameRoundId,
                        currentRound.PotSize + effectiveAmount);
                }

                // Record the move
                await _moveRepository.RecordMoveAsync(gameId, userId, actionType, effectiveAmount, game.CurrentState);
            }

            // Check if round is complete after this move
            bool roundComplete = await CheckRoundCompleteAsync(gameId);

            if (roundComplete)
            {
                // Advance to next stage
                await AdvanceGameStateAsync(gameId);
            }
            else
            {
                // Find next active player
                await SetNextPlayerTurnAsync(gameId);
            }

            return true;
        }

        private async Task<bool> CheckRoundCompleteAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null) return false;

            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();

            // If only one active player remains, round is complete
            if (activePlayers.Count <= 1)
                return true;

            // Get all moves in the current round
            var roundMoves = await _moveRepository.GetLastRoundMovesAsync(gameId, game.CurrentState);

            // Get player contributions
            var playerContributions =
                await _moveRepository.GetPlayerContributionsForRoundAsync(gameId, game.CurrentState);

            // Get highest contribution
            int highestContributionInRound = playerContributions.Any() ? playerContributions.Values.Max() : 0;

            // Find the last aggressive action (bet or raise)
            var lastAggressiveMove = roundMoves
                .Where(m => m.ActionType == "Bet" || m.ActionType == "Raise")
                .OrderByDescending(m => m.MoveTime)
                .FirstOrDefault();

            int lastAggressivePlayerId = lastAggressiveMove?.PlayerId ?? 0;
            bool hasAggressiveAction = lastAggressiveMove != null;

            // Check if all active players have acted at least once since the last aggressive action
            bool allPlayersActed = true;

            if (hasAggressiveAction)
            {
                // Get all moves that happened after the last aggressive action
                var movesAfterLastAggressive = roundMoves
                    .Where(m => m.MoveTime > lastAggressiveMove.MoveTime)
                    .ToList();

                // Check if each active player has acted since the last aggressive action
                foreach (var player in activePlayers)
                {
                    // Skip the player who made the last aggressive action
                    if (player.UserId == lastAggressivePlayerId)
                        continue;

                    // Check if this player has acted since the last aggressive action
                    bool hasActed = movesAfterLastAggressive.Any(m => m.PlayerId == player.UserId);

                    if (!hasActed)
                    {
                        allPlayersActed = false;
                        break;
                    }
                }
            }
            else
            {
                // If no aggressive action, check if all players have acted at least once
                foreach (var player in activePlayers)
                {
                    bool hasActed = roundMoves.Any(m => m.PlayerId == player.UserId);

                    if (!hasActed)
                    {
                        allPlayersActed = false;
                        break;
                    }
                }
            }

            // Check if all active players have matched the highest bet or folded
            bool allBetsMatched = true;
            foreach (var player in activePlayers)
            {
                // Get this player's contribution
                int contribution = playerContributions.GetValueOrDefault(player.UserId, 0);

                // If this player's contribution is less than the highest, the bets are not matched
                if (contribution < highestContributionInRound)
                {
                    allBetsMatched = false;
                    break;
                }
            }

            // Round is complete if all players have acted and all bets are matched
            return allPlayersActed && allBetsMatched;
        }

        private async Task AdvanceGameStateAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null) return;

            // Get active players
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();

            // If only one player remains active, they win the pot
            if (activePlayers.Count == 1)
            {
                await DetermineWinnerAsync(gameId);
                return;
            }

            // Advance to next stage based on current state
            switch (game.CurrentState)
            {
                case "PreFlop":
                    await DealFlopAsync(gameId);
                    break;
                case "Flop":
                    await DealTurnAsync(gameId);
                    break;
                case "Turn":
                    await DealRiverAsync(gameId);
                    break;
                case "River":
                    await DetermineWinnerAsync(gameId);
                    break;
            }

            // Set first player to act in the new round
            if (game.CurrentState != "Completed")
            {
                await SetFirstPlayerInRoundAsync(gameId);
            }
        }

        private async Task SetFirstPlayerInRoundAsync(int gameId)
        {
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).OrderBy(p => p.SeatPosition).ToList();

            if (activePlayers.Count == 0) return;

            // Find dealer
            var dealer = activePlayers.FirstOrDefault(p => p.IsDealer);
            if (dealer == null) return;

            // First active player after dealer acts first
            int dealerIndex = activePlayers.IndexOf(dealer);
            int firstToActIndex = (dealerIndex + 1) % activePlayers.Count;

            // Set first player to act
            var firstToActPlayer = activePlayers[firstToActIndex];
            await _gameRepository.SetCurrentTurnAsync(gameId, firstToActPlayer.UserId);
        }

        private async Task SetNextPlayerTurnAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null) return;

            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).OrderBy(p => p.SeatPosition).ToList();

            if (activePlayers.Count == 0) return;

            // Find current player
            var currentPlayer = activePlayers.FirstOrDefault(p => p.UserId == game.CurrentTurnUserId);
            if (currentPlayer == null)
            {
                // If no current player, set first active player
                await _gameRepository.SetCurrentTurnAsync(gameId, activePlayers.First().UserId);
                return;
            }

            // Find next active player
            int currentIndex = activePlayers.IndexOf(currentPlayer);
            int nextIndex = (currentIndex + 1) % activePlayers.Count;

            var nextPlayer = activePlayers[nextIndex];

            // Set next player as current turn
            await _gameRepository.SetCurrentTurnAsync(gameId, nextPlayer.UserId);
        }

        public async Task<bool> DealFlopAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "PreFlop")
                return false;

            // Get all cards
            var allCards = await _cardRepository.GetAllCardsAsync();

            // Get cards already in use
            var usedCardIds = new HashSet<int>();

            // Get community cards (should be empty at this point)
            var communityCards = await _cardRepository.GetCommunityCardsByGameIdAsync(gameId);
            foreach (var card in communityCards)
            {
                usedCardIds.Add(card.CardId);
            }

            // Get player cards
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            foreach (var player in players)
            {
                var playerCards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);
                foreach (var card in playerCards)
                {
                    usedCardIds.Add(card.CardId);
                }
            }

            // Get available cards
            var availableCards = allCards.Where(c => !usedCardIds.Contains(c.CardId)).ToList();

            // Shuffle available cards
            availableCards = ShuffleCards(availableCards);

            // Deal 3 cards for the flop
            for (int i = 0; i < 3; i++)
            {
                await _cardRepository.DealCommunityCardAsync(gameId, availableCards[i].CardId, i + 1);
            }

            // Update game state
            await _gameRepository.UpdateGameStateAsync(gameId, "Flop");

            // Notify all clients
            await _hubContext.Clients.Group($"Game{gameId}")
                .SendAsync("ReceiveGameUpdate", await GetGameStateAsync(gameId, 0));

            return true;
        }

        public async Task<bool> DealTurnAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "Flop")
                return false;

            // Get all cards
            var allCards = await _cardRepository.GetAllCardsAsync();

            // Get cards already in use
            var usedCardIds = new HashSet<int>();

            // Get community cards
            var communityCards = await _cardRepository.GetCommunityCardsByGameIdAsync(gameId);
            foreach (var card in communityCards)
            {
                usedCardIds.Add(card.CardId);
            }

            // Get player cards
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            foreach (var player in players)
            {
                var playerCards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);
                foreach (var card in playerCards)
                {
                    usedCardIds.Add(card.CardId);
                }
            }

            // Get available cards
            var availableCards = allCards.Where(c => !usedCardIds.Contains(c.CardId)).ToList();

            // Shuffle available cards
            availableCards = ShuffleCards(availableCards);

            // Deal turn card (4th community card)
            await _cardRepository.DealCommunityCardAsync(gameId, availableCards[0].CardId, 4);

            // Update game state
            await _gameRepository.UpdateGameStateAsync(gameId, "Turn");

            // Notify all clients
            await _hubContext.Clients.Group($"Game{gameId}")
                .SendAsync("ReceiveGameUpdate", await GetGameStateAsync(gameId, 0));

            return true;
        }

        public async Task<bool> DealRiverAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "Turn")
                return false;

            // Get all cards
            var allCards = await _cardRepository.GetAllCardsAsync();

            // Get cards already in use
            var usedCardIds = new HashSet<int>();

            // Get community cards
            var communityCards = await _cardRepository.GetCommunityCardsByGameIdAsync(gameId);
            foreach (var card in communityCards)
            {
                usedCardIds.Add(card.CardId);
            }

            // Get player cards
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            foreach (var player in players)
            {
                var playerCards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);
                foreach (var card in playerCards)
                {
                    usedCardIds.Add(card.CardId);
                }
            }

            // Get available cards
            var availableCards = allCards.Where(c => !usedCardIds.Contains(c.CardId)).ToList();

            // Shuffle available cards
            availableCards = ShuffleCards(availableCards);

            // Deal river card (5th community card)
            await _cardRepository.DealCommunityCardAsync(gameId, availableCards[0].CardId, 5);

            // Update game state
            await _gameRepository.UpdateGameStateAsync(gameId, "River");

            // Notify all clients
            await _hubContext.Clients.Group($"Game{gameId}")
                .SendAsync("ReceiveGameUpdate", await GetGameStateAsync(gameId, 0));

            return true;
        }

        public async Task<bool> DetermineWinnerAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null) return false;

            // Get current round
            var currentRound = await _gameRoundRepository.GetCurrentRoundAsync(gameId);
            if (currentRound == null) return false;

            // Get all players
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();

            // If only one player is active, they win automatically
            if (activePlayers.Count == 1)
            {
                var winner = activePlayers.First();

                // Award pot to the winner
                await _gameRoundWinnerRepository.AddWinnerAsync(currentRound.GameRoundId, winner.UserId,
                    currentRound.PotSize);

                // End the round
                await _gameRoundRepository.EndRoundAsync(currentRound.GameRoundId);

                // Update game state to showdown (to show cards)
                await _gameRepository.UpdateGameStateAsync(gameId, "Showdown");

                // Start a new hand after a delay
                await Task.Delay(5000);
                await StartNewHandAsync(gameId);

                return true;
            }

            // Get community cards
            var communityCards = await _cardRepository.GetCommunityCardsByGameIdAsync(gameId);

            // Evaluate each player's hand and determine winner(s)
            var playerHandRankings = new Dictionary<int, int>(); // UserId -> Hand Rank

            foreach (var player in activePlayers)
            {
                var playerCards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);

                // Combine player's cards with community cards
                var allCards = new List<Card>();
                allCards.AddRange(playerCards);
                allCards.AddRange(communityCards);

                // Evaluate hand
                int handRank = PokerHandEvaluator.EvaluateHand(allCards);

                playerHandRankings[player.UserId] = handRank;
            }

            // Find the highest hand rank
            int highestRank = playerHandRankings.Values.Max();

            // Find all players with the highest rank (could be multiple in case of a tie)
            var winners = playerHandRankings
                .Where(kvp => kvp.Value == highestRank)
                .Select(kvp => kvp.Key)
                .ToList();

            // Update game state to showdown
            await _gameRepository.UpdateGameStateAsync(gameId, "Showdown");

            // Handle pot distribution
            if (winners.Count == 1)
            {
                // Single winner gets the whole pot
                await _gameRoundWinnerRepository.AddWinnerAsync(currentRound.GameRoundId, winners[0],
                    currentRound.PotSize);
            }
            else
            {
                // Split pot among winners
                int potPerWinner = currentRound.PotSize / winners.Count;
                int remainingChips = currentRound.PotSize % winners.Count;

                // Create a dictionary to hold winner amounts
                var winnerAmounts = new Dictionary<int, int>();

                foreach (var winnerId in winners)
                {
                    winnerAmounts[winnerId] = potPerWinner;
                }

                // Distribute remaining chips based on position relative to dealer
                if (remainingChips > 0)
                {
                    // Find dealer
                    var dealer = players.FirstOrDefault(p => p.IsDealer);
                    if (dealer != null)
                    {
                        // Sort winners by seat position relative to dealer (clockwise)
                        var orderedWinners = new List<(int UserId, int RelativePosition)>();

                        foreach (var winnerId in winners)
                        {
                            var winnerPlayer = players.FirstOrDefault(p => p.UserId == winnerId);
                            if (winnerPlayer != null)
                            {
                                // Calculate relative position from dealer (clockwise)
                                int relativePos = (winnerPlayer.SeatPosition - dealer.SeatPosition + players.Count()) %
                                                  players.Count();
                                orderedWinners.Add((winnerId, relativePos));
                            }
                        }

                        // Sort by relative position
                        orderedWinners = orderedWinners.OrderBy(w => w.RelativePosition).ToList();

                        // Distribute odd chips to the first N winners
                        for (int i = 0; i < remainingChips && i < orderedWinners.Count; i++)
                        {
                            winnerAmounts[orderedWinners[i].UserId]++;
                        }
                    }
                }

                // Record all winners with their amounts
                await _gameRoundWinnerRepository.AddMultipleWinnersAsync(currentRound.GameRoundId, winnerAmounts);
            }

            // End the round
            await _gameRoundRepository.EndRoundAsync(currentRound.GameRoundId);

            // Notify all clients
            await _hubContext.Clients.Group($"Game{gameId}")
                .SendAsync("ReceiveGameUpdate", await GetGameStateAsync(gameId, 0));

            // Start a new hand after a delay
            await Task.Delay(5000);
            await StartNewHandAsync(gameId);

            return true;
        }

        private async Task<bool> StartNewHandAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null) return false;

            // Get all players
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);

            // Check if we have enough players to continue
            var playersWithChips = players.Where(p => p.CurrentChips > 0).ToList();
            if (playersWithChips.Count < 2)
            {
                // End the game if not enough players
                await _gameRepository.EndGameAsync(gameId);

                return false;
            }

            // Reset all players to active state
            foreach (var player in playersWithChips)
            {
                await _gamePlayerRepository.SetPlayerStatusAsync(player.GamePlayerId, true);
            }

            // Rotate dealer position
            await RotateDealerPositionAsync(gameId);

            // Clear any cards from the previous hand
            await _cardRepository.ClearGameCardsAsync(gameId);

            // Reset pot size
            await _gameRepository.UpdatePotSizeAsync(gameId, 0);

            // Create a new game round
            await _gameRoundRepository.StartNewRoundAsync(gameId);

            // Update game state to PreFlop
            await _gameRepository.UpdateGameStateAsync(gameId, "PreFlop");

            // Deal new cards
            await DealCardsAsync(gameId);

            // Collect blinds
            await CollectBlindsAsync(gameId, playersWithChips);

            // Set first player to act
            await SetFirstPlayerToActAsync(gameId);

            return true;
        }

        private async Task RotateDealerPositionAsync(int gameId)
        {
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.CurrentChips > 0).OrderBy(p => p.SeatPosition).ToList();

            if (activePlayers.Count < 2) return;

            // Find current dealer
            var currentDealer = activePlayers.FirstOrDefault(p => p.IsDealer);

            // If no dealer set, set the first player as dealer
            if (currentDealer == null)
            {
                await _gamePlayerRepository.SetDealerPositionAsync(gameId, activePlayers[0].GamePlayerId);

                // Set blinds
                int sbIndex = 1 % activePlayers.Count;
                int bbIndex = 2 % activePlayers.Count;

                await _gamePlayerRepository.SetBlindPositionsAsync(
                    gameId,
                    activePlayers[sbIndex].GamePlayerId,
                    activePlayers[bbIndex].GamePlayerId);
            }
            else
            {
                // Find the next active player after the current dealer
                int currentDealerPosition = currentDealer.SeatPosition;

                // Find the next active player clockwise
                GamePlayer nextDealer = null;

                // First try to find a player with higher seat position
                nextDealer = activePlayers.FirstOrDefault(p => p.SeatPosition > currentDealerPosition);

                // If not found, wrap around to the lowest seat position
                if (nextDealer == null)
                {
                    nextDealer = activePlayers.FirstOrDefault();
                }

                if (nextDealer != null)
                {
                    // Set the new dealer
                    await _gamePlayerRepository.SetDealerPositionAsync(gameId, nextDealer.GamePlayerId);

                    // Find the next two active players for small blind and big blind
                    int dealerIndex = activePlayers.FindIndex(p => p.GamePlayerId == nextDealer.GamePlayerId);
                    int sbIndex = (dealerIndex + 1) % activePlayers.Count;
                    int bbIndex = (dealerIndex + 2) % activePlayers.Count;

                    await _gamePlayerRepository.SetBlindPositionsAsync(
                        gameId,
                        activePlayers[sbIndex].GamePlayerId,
                        activePlayers[bbIndex].GamePlayerId);
                }
            }
        }

        public async Task<GameStateDto> GetGameStateAsync(int gameId, int userId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null) return null;

            var table = await _gameRepository.GetGameTableAsync(gameId);
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var communityCards = await _cardRepository.GetCommunityCardsByGameIdAsync(gameId);
            var moves = await _moveRepository.GetMovesByGameIdAsync(gameId);
            var rounds = await _gameRoundRepository.GetByGameIdAsync(gameId);

            // Get current round
            var currentRound = await _gameRoundRepository.GetCurrentRoundAsync(gameId);

            // Get player contributions for the current round
            var playerContributions = new Dictionary<int, int>();
            if (currentRound != null)
            {
                playerContributions =
                    await _moveRepository.GetPlayerContributionsForRoundAsync(gameId, game.CurrentState);
            }

            // Calculate call amount and min raise
            int highestContribution = playerContributions.Any() ? playerContributions.Values.Max() : 0;
            int currentPlayerContribution = playerContributions.GetValueOrDefault(userId, 0);
            int callAmount = highestContribution - currentPlayerContribution;

            // Find the size of the last raise/bet for minimum raise calculation
            var roundMoves = await _moveRepository.GetLastRoundMovesAsync(gameId, game.CurrentState);
            var lastAggressiveMove = roundMoves
                .Where(m => m.ActionType == "Bet" || m.ActionType == "Raise")
                .OrderByDescending(m => m.MoveTime)
                .FirstOrDefault();

            int minRaiseAmount =
                lastAggressiveMove?.Amount ?? (table?.BigBlind ?? 20); // Default to BB if no prior aggression

            // Build player state DTOs
            var playerStateDtos = new List<PlayerStateDto>();
            var playerCards = new List<CardDto>(); // Cards for the requesting player

            bool showAllCards = game.CurrentState == "Showdown" || game.CurrentState == "Completed";

            foreach (var player in players)
            {
                var playerStateDto = new PlayerStateDto
                {
                    UserId = player.UserId,
                    Username = player.User?.Username ?? $"Player {player.UserId}",
                    CurrentChips = player.CurrentChips,
                    IsActive = player.IsActive,
                    IsDealer = player.IsDealer,
                    IsSmallBlind = player.IsSmallBlind,
                    IsBigBlind = player.IsBigBlind,
                    SeatPosition = player.SeatPosition
                };

                // Include cards if:
                // 1. This is the requesting player, OR
                // 2. It's showdown/completed state AND the player was active at the end
                if (player.UserId == userId || (showAllCards && player.IsActive))
                {
                    var cards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);
                    playerStateDto.Cards = cards.Select(c => new CardDto
                    {
                        Suit = c.Suit,
                        Value = c.Value
                    }).ToList();
                }
                else
                {
                    playerStateDto.Cards = new List<CardDto>(); // Empty by default
                }

                playerStateDtos.Add(playerStateDto);
            }

            // Get the requesting player's cards
            if (userId > 0)
            {
                var userGamePlayer = players.FirstOrDefault(p => p.UserId == userId);
                if (userGamePlayer != null)
                {
                    var cards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(userGamePlayer.GamePlayerId);
                    playerCards = cards.Select(c => new CardDto
                    {
                        Suit = c.Suit,
                        Value = c.Value
                    }).ToList();
                }
            }

            // Get last few moves for context
            var lastMoves = moves
                .OrderByDescending(m => m.MoveTime)
                .Take(10)
                .Select(m => new MoveDto
                {
                    PlayerId = m.PlayerId,
                    ActionType = m.ActionType,
                    Amount = m.Amount,
                    MoveTime = m.MoveTime
                })
                .ToList();

            // Get round winners
            var roundWinners = new List<RoundWinnerDto>();
            foreach (var round in rounds.Where(r => r.EndTime.HasValue))
            {
                foreach (var winner in round.Winners)
                {
                    roundWinners.Add(new RoundWinnerDto
                    {
                        UserId = winner.UserId,
                        Username = winner.User?.Username ?? $"Player {winner.UserId}",
                        AmountWon = winner.AmountWon
                    });
                }
            }

            // Build the game state DTO
            var gameStateDto = new GameStateDto
            {
                GameId = game.GameId,
                TableId = game.TableId,
                TableName = table?.Name,
                CurrentState = game.CurrentState,
                PotSize = game.PotSize,
                CurrentTurnUserId = game.CurrentTurnUserId,
                CommunityCards = communityCards.Select(c => new CardDto
                {
                    Suit = c.Suit,
                    Value = c.Value
                }).ToList(),
                Players = playerStateDtos,
                PlayerCards = playerCards,
                LastMoves = lastMoves,
                RoundWinners = roundWinners,
                PlayerRoundContributions = playerContributions,
                CallAmount = callAmount,
                MinRaiseAmount = minRaiseAmount
            };

            return gameStateDto;
        }

        public async Task<bool> AcknowledgeGameResultAsync(int gameId, int userId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "Showdown")
                return false;

            if (!_gameResultAcknowledgments.ContainsKey(gameId))
            {
                _gameResultAcknowledgments[gameId] = new HashSet<int>();
            }

            _gameResultAcknowledgments[gameId].Add(userId);

            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);

            if (players.All(p => _gameResultAcknowledgments[gameId].Contains(p.UserId)))
            {
                _gameResultAcknowledgments.Remove(gameId);
                await StartNewHandAsync(gameId);
            }

            return true;
        }
    }
}