using System;
using TexasHoldemPoker.API.DTOs;
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
            if (game == null || game.CurrentState != "Waiting") return false;

            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            if (players.Count() < 2) return false;

            // If this is the first hand or we need to rotate positions
            if (!players.Any(p => p.IsDealer))
            {
                await PrepareNextHandAsync(gameId);
            }

            // Deal cards
            await DealCardsAsync(gameId);

            // Get the table to determine blind amounts
            var table = game.Table;

            // Find small blind and big blind players
            var smallBlindPlayer = players.FirstOrDefault(p => p.IsSmallBlind);
            var bigBlindPlayer = players.FirstOrDefault(p => p.IsBigBlind);

            if (smallBlindPlayer == null || bigBlindPlayer == null)
            {
                return false;
            }

            // Place blind bets
            await _moveRepository.RecordMoveAsync(
                gameId, smallBlindPlayer.UserId, "Bet", table.SmallBlind, "PreFlop");

            await _moveRepository.RecordMoveAsync(
                gameId, bigBlindPlayer.UserId, "Bet", table.BigBlind, "PreFlop");

            // Set the first player to act after big blind
            var activePlayers = players.Where(p => p.IsActive).OrderBy(p => p.SeatPosition).ToList();
            int bbIndex = activePlayers.FindIndex(p => p.UserId == bigBlindPlayer.UserId);
            int firstToActIndex = (bbIndex + 1) % activePlayers.Count;

            var firstToActPlayer = activePlayers[firstToActIndex];

            await _gameRepository.SetCurrentTurnAsync(gameId, firstToActPlayer.UserId);

            // Update game state
            await _gameRepository.UpdateGameStateAsync(gameId, "PreFlop");

            return true;
        }

        public async Task<bool> DealCardsAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "Waiting") return false;

            // Clear any existing cards
            await _cardRepository.ClearGameCardsAsync(gameId);

            // Get all cards
            var allCards = await _cardRepository.GetAllCardsAsync();

            // Implement Fisher-Yates shuffle
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
            if (game == null || game.EndTime != null)
                return false;

            var gamePlayer = await _gamePlayerRepository.GetPlayerByGameAndUserAsync(gameId, userId);
            if (gamePlayer == null || !gamePlayer.IsActive)
                return false;

            // Check if it's this player's turn
            if (game.CurrentTurnUserId != userId)
                return false; // Not this player's turn

            var roundMoves = await _moveRepository.GetLastRoundMovesAsync(gameId, game.CurrentState);
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();

            // Calculate contributions this round
            var playerContributions = new Dictionary<int, int>();
            foreach (var p in activePlayers)
            {
                playerContributions[p.UserId] = 0;
            }

            foreach (var move in roundMoves)
            {
                if (playerContributions.ContainsKey(move.PlayerId) && (move.ActionType == "Bet" ||
                                                                       move.ActionType == "Call" ||
                                                                       move.ActionType == "Raise" ||
                                                                       move.ActionType == "AllIn"))
                {
                    playerContributions[move.PlayerId] += move.Amount;
                }
            }

            int highestContributionInRound = playerContributions.Any() ? playerContributions.Values.Max() : 0;
            int currentPlayerContribution = playerContributions.GetValueOrDefault(userId, 0);
            int amountToCall = highestContributionInRound - currentPlayerContribution;

            // Find the size of the last raise/bet for minimum raise calculation
            var lastAggressiveMove = roundMoves
                .Where(m => m.ActionType == "Bet" || m.ActionType == "Raise")
                .OrderByDescending(m => m.MoveTime)
                .FirstOrDefault();
            int minRaiseAmount =
                lastAggressiveMove?.Amount ?? game.Table.BigBlind; // Default to BB if no prior aggression


            // --- PERFORM VALIDATION BASED ON actionType ---

            if (actionType == "Fold")
            {
                // Fold is always allowed
            }
            else if (actionType == "Check")
            {
                // Check is only allowed if amountToCall is 0
                if (amountToCall > 0)
                {
                    // Log error: Cannot check, must call amountToCall
                    return false; // Invalid move
                }

                // Ensure amount passed is 0 for check
                if (amount != 0) amount = 0;
            }
            else if (actionType == "Call")
            {
                // Call is only allowed if there is something to call (amountToCall > 0)
                if (amountToCall <= 0)
                {
                    // Log error: Nothing to call, must Check or Bet
                    return false; // Invalid move
                }

                // Amount must be the exact amount to call, unless player is all-in
                int callAmount = Math.Min(amountToCall, gamePlayer.CurrentChips); // Effective call amount if all-in
                if (amount != callAmount)
                {
                    // Log error: Incorrect call amount. Expected callAmount
                    // Allow the move if amount matches effective call amount (covers all-in case)
                    // If client sent wrong amount but it wasn't all-in, reject
                    if (amount != callAmount && callAmount != gamePlayer.CurrentChips) return false;
                    amount = callAmount; // Correct the amount if it was an all-in situation misreported by client
                }
            }
            else if (actionType == "Bet")
            {
                // Bet is only allowed if no one has bet yet (highestContributionInRound == 0)
                if (highestContributionInRound > 0)
                {
                    // Log error: Cannot Bet, must Call, Raise, or Fold
                    return false; // Invalid move
                }

                // Bet amount must be >= Big Blind (or a minimum bet size)
                if (amount < game.Table.BigBlind)
                {
                    // Log error: Bet amount too small
                    return false;
                }

                if (amount > gamePlayer.CurrentChips) return false; // Not enough chips
            }
            else if (actionType == "Raise")
            {
                // Raise is only allowed if there was a prior bet/raise (highestContributionInRound > 0)
                if (highestContributionInRound <= 0)
                {
                    // Log error: Cannot Raise, must Bet or Check/Fold
                    return false;
                }

                // The total amount the player is putting in (contribution + raise amount) must be >= highest + minRaise
                int totalBetSize = currentPlayerContribution + amount;
                int requiredTotalSize = highestContributionInRound + minRaiseAmount;

                // Ensure the total size of the raise is sufficient
                if (totalBetSize < requiredTotalSize &&
                    (currentPlayerContribution + amount) < gamePlayer.CurrentChips) // Allow smaller raise if all-in
                {
                    // Log error: Raise amount too small. Min total is requiredTotalSize
                    return false;
                }

                if (amount > gamePlayer.CurrentChips) return false; // Not enough chips

                // Adjust amount if it's effectively an all-in raise that's less than the minimum
                if (amount == gamePlayer.CurrentChips && totalBetSize < requiredTotalSize)
                {
                    // It's a valid all-in, even if less than min raise. Keep amount as is.
                }
                else if (totalBetSize < requiredTotalSize)
                {
                    // This case should ideally be caught above, but double-check logic.
                    return false;
                }
            }
            else if (actionType == "AllIn")
            {
                amount = gamePlayer.CurrentChips; // Ensure amount is exactly player's chips
                // Determine if this AllIn acts as a Call or a Raise based on context
                if (amount + currentPlayerContribution <= highestContributionInRound)
                {
                    actionType = "Call"; // It's an all-in call (for less than full amount)
                }
                else
                {
                    // Check if it meets min-raise requirements IF it's more than a call
                    int totalBetSize = currentPlayerContribution + amount;
                    int requiredTotalSize = highestContributionInRound + minRaiseAmount;
                    if (totalBetSize < requiredTotalSize)
                    {
                        // It's an all-in raise, but less than min-raise. Still valid as an all-in.
                        actionType = "Raise"; // Still considered a raise action type for betting purposes
                    }
                    else
                    {
                        actionType = "Raise"; // A full all-in raise
                    }

                    // Note: The RecordMove should just store "AllIn" maybe, or maybe store the effective action ("Call" or "Raise")?
                    // Storing "AllIn" is likely clearer. The validation ensures it's *contextually* a call or raise.
                    actionType = "AllIn"; // Keep original actionType for clarity in DB? Needs decision.
                }
            }
            else
            {
                return false; // Unknown action type
            }

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

            // Move to the next player's turn
            await SetNextPlayerTurnAsync(gameId, userId);

            // Check if round is complete (all active players have acted)
            await CheckAndAdvanceRoundAsync(gameId);

            return true;
        }

        private async Task<bool> SetNextPlayerTurnAsync(int gameId, int currentUserId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null)
                return false;

            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).OrderBy(p => p.SeatPosition).ToList();

            if (activePlayers.Count <= 1)
                return true; // Only one player left, no need to set next turn

            // Find the current player's index
            int currentIndex = activePlayers.FindIndex(p => p.UserId == currentUserId);

            // Get the next player (wrap around to the beginning if needed)
            int nextIndex = (currentIndex + 1) % activePlayers.Count;
            int nextUserId = activePlayers[nextIndex].UserId;

            // Set the next player's turn
            return await _gameRepository.SetCurrentTurnAsync(gameId, nextUserId);
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
                .ToList();

            // Shuffle available cards
            availableCards = ShuffleCards(availableCards);

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
                .ToList();

            // Shuffle available cards
            availableCards = ShuffleCards(availableCards);

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
                .ToList();

            // Shuffle available cards
            availableCards = ShuffleCards(availableCards);

            // Deal river (5th community card)
            await _cardRepository.DealCommunityCardAsync(gameId, availableCards[0].CardId, 5);

            // Update game state
            await _gameRepository.UpdateGameStateAsync(gameId, "River");

            return true;
        }

        public async Task<bool> DetermineWinnerAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null || game.CurrentState != "River") return false;

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

            // Evaluate each player's hand and determine winner(s)
            var playerHandRankings = new List<(int UserId, int HandRank)>();

            foreach (var player in activePlayers)
            {
                var playerCards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);

                // Combine player's hole cards with community cards
                var allCards = playerCards.Concat(communityCards).ToList();

                // Evaluate hand strength with detailed card values
                var handRank = PokerHandEvaluator.EvaluateHand(allCards);

                playerHandRankings.Add((player.UserId, handRank));
            }

            // Sort by hand rank (descending) and then by card values
            playerHandRankings = playerHandRankings
                .OrderByDescending(p => p.HandRank)
                .ToList();

            // Find all players with the highest hand rank
            var highestRank = playerHandRankings.First().HandRank;

            var winners = playerHandRankings.Where(p => p.HandRank == highestRank)
                .Select(p => p.UserId)
                .ToList();

            // If there's only one winner, use the existing method
            if (winners.Count == 1)
            {
                await _gameRepository.EndGameAsync(gameId, winners[0]);
            }
            else
            {
                // Handle split pot
                await EndGameWithSplitPotAsync(gameId, winners);
            }

            return true;
        }

        private async Task<bool> EndGameWithSplitPotAsync(int gameId, List<int> winnerIds)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null) return false;

            // Calculate the pot amount each winner gets
            int potPerWinner = game.PotSize / winnerIds.Count;

            // Handle odd chips - give to the player closest to dealer button
            int remainingChips = game.PotSize % winnerIds.Count;

            if (remainingChips > 0)
            {
                // Get all players to find dealer position
                var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
                var dealer = players.FirstOrDefault(p => p.IsDealer);

                if (dealer != null)
                {
                    // Sort winners by seat position relative to dealer
                    var orderedWinners = new List<(int UserId, int RelativePosition)>();

                    foreach (var winnerId in winnerIds)
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
                        // Record an extra chip for this winner
                        await _chipTransactionRepository.RecordGameWinningsAsync(
                            orderedWinners[i].UserId, gameId, potPerWinner + 1);

                        // Update user's chip balance
                        var user = players.FirstOrDefault(p => p.UserId == orderedWinners[i].UserId);
                        if (user != null)
                        {
                            await _gamePlayerRepository.UpdatePlayerChipsAsync(
                                user.GamePlayerId, user.CurrentChips + potPerWinner + 1);
                        }
                    }

                    // Distribute normal pot amount to remaining winners
                    for (int i = remainingChips; i < orderedWinners.Count; i++)
                    {
                        await _chipTransactionRepository.RecordGameWinningsAsync(
                            orderedWinners[i].UserId, gameId, potPerWinner);

                        // Update user's chip balance
                        var user = players.FirstOrDefault(p => p.UserId == orderedWinners[i].UserId);
                        if (user != null)
                        {
                            await _gamePlayerRepository.UpdatePlayerChipsAsync(
                                user.GamePlayerId, user.CurrentChips + potPerWinner);
                        }
                    }
                }
                else
                {
                    // If dealer can't be found, just distribute evenly and ignore odd chips
                    foreach (var winnerId in winnerIds)
                    {
                        await _chipTransactionRepository.RecordGameWinningsAsync(winnerId, gameId, potPerWinner);

                        // Update user's chip balance
                        var user = players.FirstOrDefault(p => p.UserId == winnerId);
                        if (user != null)
                        {
                            await _gamePlayerRepository.UpdatePlayerChipsAsync(
                                user.GamePlayerId, user.CurrentChips + potPerWinner);
                        }
                    }
                }
            }
            else
            {
                // Distribute pot evenly
                foreach (var winnerId in winnerIds)
                {
                    await _chipTransactionRepository.RecordGameWinningsAsync(winnerId, gameId, potPerWinner);

                    // Update user's chip balance(not sure abut that right now)
                    //var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
                    //var user = players.FirstOrDefault(p => p.UserId == winnerId);
                    //if (user != null)
                    //{
                    //    await _gamePlayerRepository.UpdatePlayerChipsAsync(
                    //        user.GamePlayerId, user.CurrentChips + potPerWinner);
                    //}
                }
            }

            // Think about adding multiple winners to the database should consider with win rates

            // Mark the game as completed with multiple winners
            game.EndTime = DateTime.UtcNow;
            game.CurrentState = "Completed";
            // We can't set multiple winners in the Game entity, so we'll set the first one
            // The actual distribution is handled above
            if (winnerIds.Count > 0)
            {
                game.WinnerId = winnerIds[0];
            }

            await _gameRepository.UpdateGameAsync(game);

            return true;
        }


        public async Task<GameStateDto> GetGameStateAsync(int gameId, int userId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null)
                return null;

            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var communityCards = await _cardRepository.GetCommunityCardsByGameIdAsync(gameId);
            var moves = await _moveRepository.GetMovesByGameIdAsync(gameId);

            // Determine if we should show all cards (showdown or game completed)
            bool showAllCards = game.CurrentState == "Showdown" || game.CurrentState == "Completed";

            // Get the requesting player's cards
            var playerCards = new List<CardDto>();
            if (userId > 0) // Only get player cards if a specific user is requesting
            {
                var gamePlayer = players.FirstOrDefault(p => p.UserId == userId);
                if (gamePlayer != null)
                {
                    var cards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(gamePlayer.GamePlayerId);
                    playerCards = cards.Select(c => new CardDto { Suit = c.Suit, Value = c.Value }).ToList();
                }
            }

            // Build player state DTOs
            var playerStateDtos = new List<PlayerStateDto>();
            foreach (var player in players)
            {
                var playerStateDto = new PlayerStateDto
                {
                    UserId = player.UserId,
                    Username = player.User.Username,
                    SeatPosition = player.SeatPosition,
                    ChipCount = player.CurrentChips,
                    IsActive = player.IsActive,
                    IsDealer = player.IsDealer,
                    IsSmallBlind = player.IsSmallBlind,
                    IsBigBlind = player.IsBigBlind,
                    Cards = new List<CardDto>() // Empty by default
                };

                // Include cards if:
                // 1. This is the requesting player, OR
                // 2. It's showdown/completed state AND the player was active at the end
                if (player.UserId == userId || (showAllCards && player.IsActive))
                {
                    var cards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);
                    playerStateDto.Cards = cards.Select(c => new CardDto { Suit = c.Suit, Value = c.Value }).ToList();
                }

                playerStateDtos.Add(playerStateDto);
            }

            // Get last few moves for context
            var lastMoves = moves.OrderByDescending(m => m.MoveTime)
                .Take(10)
                .Select(m => new MoveDto
                {
                    PlayerId = m.PlayerId,
                    ActionType = m.ActionType,
                    Amount = m.Amount,
                    Round = m.Round,
                    MoveTime = m.MoveTime
                })
                .ToList();

            // Build the game state DTO
            var gameStateDto = new GameStateDto
            {
                GameId = game.GameId,
                TableId = game.TableId,
                TableName = game.Table?.Name,
                CurrentState = game.CurrentState,
                PotSize = game.PotSize,
                CurrentTurnUserId = game.CurrentTurnUserId,
                CommunityCards = communityCards.Select(c => new CardDto { Suit = c.Suit, Value = c.Value }).ToList(),
                Players = playerStateDtos,
                PlayerCards = playerCards,
                LastMoves = lastMoves,
                WinnerId = game.WinnerId
            };

            return gameStateDto;
        }


        private async Task<bool> CheckAndAdvanceRoundAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null) return false;

            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();

            // If only one player remains active, they win by default
            if (activePlayers.Count <= 1)
            {
                if (activePlayers.Count == 1)
                {
                    await _gameRepository.EndGameAsync(gameId, activePlayers[0].UserId);
                }

                return true;
            }

            // Get all moves for the current round
            var roundMoves = await _moveRepository.GetLastRoundMovesAsync(gameId, game.CurrentState);

            Dictionary<int, int> playerContributions = new Dictionary<int, int>();

            // Initialize player contributions to 0
            foreach (var player in activePlayers)
            {
                playerContributions[player.UserId] = 0;
            }

            // Calculate each player's contribution and find the highest bet
            foreach (var move in roundMoves)
            {
                if (move.ActionType == "Bet" || move.ActionType == "Raise" || move.ActionType == "Call" ||
                    move.ActionType == "AllIn")
                {
                    if (!playerContributions.ContainsKey(move.PlayerId))
                        continue; // Skip if player folded before this move

                    playerContributions[move.PlayerId] += move.Amount;
                }
            }

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
                    if (player.UserId == lastAggressivePlayerId) continue;

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
            foreach (var player in activePlayers) // Only check active players
            {
                int contribution = playerContributions.GetValueOrDefault(player.UserId, 0); // Use GetValueOrDefault

                // If this active player's contribution is less than the highest required,
                // the bets are not matched.
                if (contribution < highestContributionInRound)
                {
                    allBetsMatched = false;
                    break;
                }
            }

            // Round is complete if all players have acted and all bets are matched
            bool roundComplete = allPlayersActed && allBetsMatched;

            if (roundComplete)
            {
                // Advance to next stage based on current state
                if (game.CurrentState == "PreFlop")
                {
                    await DealFlopAsync(gameId);
                    // Set first active player after dealer to act
                    await SetFirstPlayerInRoundAsync(gameId);
                }
                else if (game.CurrentState == "Flop")
                {
                    await DealTurnAsync(gameId);
                    // Set first active player after dealer to act
                    await SetFirstPlayerInRoundAsync(gameId);
                }
                else if (game.CurrentState == "Turn")
                {
                    await DealRiverAsync(gameId);
                    // Set first active player after dealer to act
                    await SetFirstPlayerInRoundAsync(gameId);
                }
                else if (game.CurrentState == "River")
                {
                    await DetermineWinnerAsync(gameId);
                }

                return true;
            }

            return false; // Round not complete yet
        }


        public async Task<bool> SetFirstPlayerInRoundAsync(int gameId)
        {
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).OrderBy(p => p.SeatPosition).ToList();

            if (activePlayers.Count == 0)
                return false;

            // Find the dealer
            var dealer = players.FirstOrDefault(p => p.IsDealer);
            if (dealer == null)
                return false;

            // Find the first active player after the dealer
            int dealerPosition = dealer.SeatPosition;
            var nextPlayer = activePlayers.FirstOrDefault(p => p.SeatPosition > dealerPosition) ??
                             activePlayers.First();

            // Set this player's turn
            return await _gameRepository.SetCurrentTurnAsync(gameId, nextPlayer.UserId);
        }

        public async Task<bool> PrepareNextHandAsync(int gameId)
        {
            var game = await _gameRepository.GetByIdAsync(gameId);
            if (game == null) return false;

            // Get all players
            var players = await _gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).OrderBy(p => p.SeatPosition).ToList();

            // Need at least 2 players to play
            if (activePlayers.Count < 2) return false;

            // Find the current dealer
            var currentDealer = players.FirstOrDefault(p => p.IsDealer);

            // If no dealer (first hand), pick the first seat
            if (currentDealer == null)
            {
                await _gamePlayerRepository.SetDealerPositionAsync(gameId, activePlayers[0].GamePlayerId);

                // Set small blind and big blind positions
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

            // Reset the game state for a new hand
            game.CurrentState = "Waiting";
            game.PotSize = 0;
            game.CurrentTurnUserId = null;

            await _gameRepository.UpdateGameAsync(game);

            // Clear any cards from the previous hand
            await _cardRepository.ClearGameCardsAsync(gameId);

            return true;
        }
    }
}