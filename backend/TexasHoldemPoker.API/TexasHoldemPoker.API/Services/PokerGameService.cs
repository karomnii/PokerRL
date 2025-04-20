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
            var currentPlayer = players.FirstOrDefault(p => p.UserId == userId);

            // Get community cards
            var communityCards = await _cardRepository.GetCommunityCardsByGameIdAsync(gameId);

            // Get last moves
            var lastMoves = await _moveRepository.GetMovesByGameIdAsync(gameId);

            var communityCardDtos = communityCards.Select(c => new CardDto { Suit = c.Suit, Value = c.Value }).ToList();

            var playerCardDtos = new List<CardDto>();
            if (currentPlayer != null)
            {
                var playerCards = await _cardRepository.GetPlayerCardsByGamePlayerIdAsync(currentPlayer.GamePlayerId);
                playerCardDtos = playerCards.Select(pc => new CardDto { Suit = pc.Suit, Value = pc.Value }).ToList();
            }

            var playerStateDtos = players.Select(p => new PlayerStateDto
            {
                UserId = p.UserId,
                Username = p.User.Username,
                SeatPosition = p.SeatPosition,
                ChipCount = p.CurrentChips,
                IsActive = p.IsActive,
                IsDealer = p.IsDealer,
                IsSmallBlind = p.IsSmallBlind,
                IsBigBlind = p.IsBigBlind,
                // Conditionally include cards based on user ID or game state
                Cards = (p.UserId == userId || game.CurrentState == "Showdown")
                    ? _cardRepository.GetPlayerCardsByGamePlayerIdAsync(p.GamePlayerId).Result
                        .Select(pc => new CardDto { Suit = pc.Suit, Value = pc.Value }).ToList()
                    : new List<CardDto>()
            }).ToList();

            var moveDtos = lastMoves.OrderByDescending(m => m.MoveTime).Take(10)
                .Select(m => new MoveDto
                {
                    PlayerId = m.PlayerId,
                    ActionType = m.ActionType,
                    Amount = m.Amount,
                    Round = m.Round,
                    MoveTime = m.MoveTime
                }).ToList();

            return new GameStateDto
            {
                GameId = game.GameId,
                TableId = game.TableId,
                TableName = game.Table.Name,
                CurrentState = game.CurrentState,
                PotSize = game.PotSize,
                CurrentTurnUserId = game.CurrentTurnUserId,
                CommunityCards = communityCardDtos,
                PlayerCards = playerCardDtos,
                Players = playerStateDtos,
                LastMoves = moveDtos,
                WinnerId = game.WinnerId
            };
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

            // Calculate the highest bet in this round
            int highestBet = 0;
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

                    if (playerContributions[move.PlayerId] > highestBet)
                    {
                        highestBet = playerContributions[move.PlayerId];
                    }
                }
            }

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
            foreach (var player in activePlayers)
            {
                int contribution = playerContributions.ContainsKey(player.UserId)
                    ? playerContributions[player.UserId]
                    : 0;

                // If a player hasn't matched the highest bet and hasn't folded
                if (contribution < highestBet)
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