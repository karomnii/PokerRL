// PokerGameService.cs

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Helpers;
using TexasHoldemPoker.API.Models;
using TexasHoldemPoker.API.Repositories;

namespace TexasHoldemPoker.API.Services
{
    public class PokerGameService : IPokerGameService
    {
        private readonly IGameRepository gameRepository;
        private readonly IGamePlayerRepository gamePlayerRepository;
        private readonly ICardRepository cardRepository;
        private readonly IMoveRepository moveRepository;
        private readonly IChipTransactionRepository chipTransactionRepository;
        private readonly IGameRoundRepository gameRoundRepository;
        private readonly IGameRoundWinnerRepository gameRoundWinnerRepository;
        private readonly IModelRepository modelRepository;
        private readonly IUserModelRepository userModelRepository;
        private readonly IUserRepository UserRepository;
        private readonly IAiAgentService aiAgentService;
        private readonly Random random = new Random();

        private static Dictionary<int, HashSet<int>>
            completedRoundAcknowledgments = new Dictionary<int, HashSet<int>>();

        public static Dictionary<int, HashSet<int>>
            agentsPlayingInGames = new Dictionary<int, HashSet<int>>();

        public PokerGameService(
            IGameRepository gameRepository,
            IGamePlayerRepository gamePlayerRepository,
            ICardRepository cardRepository,
            IMoveRepository moveRepository,
            IChipTransactionRepository chipTransactionRepository,
            IGameRoundRepository gameRoundRepository,
            IGameRoundWinnerRepository gameRoundWinnerRepository,
            IModelRepository modelRepository,
            IUserModelRepository userModelRepository,
            IAiAgentService aiAgentService,
            IUserRepository userRepository)
        {
            this.gameRepository = gameRepository;
            this.gamePlayerRepository = gamePlayerRepository;
            this.cardRepository = cardRepository;
            this.moveRepository = moveRepository;
            this.chipTransactionRepository = chipTransactionRepository;
            this.gameRoundRepository = gameRoundRepository;
            this.gameRoundWinnerRepository = gameRoundWinnerRepository;
            this.modelRepository = modelRepository;
            this.userModelRepository = userModelRepository;
            this.aiAgentService = aiAgentService;
            UserRepository = userRepository;
        }

        public async Task<Game> CreateGameAsync(int tableId)
        {
            var game = await gameRepository.CreateGameAsync(new Game { TableId = tableId });
            await gameRoundRepository.StartNewRoundAsync(game.GameId);
            return game;
        }

        public async Task<bool> JoinGameAsync(int gameId, int userId, int seatPosition, int buyInAmount)
        {
            var game = await gameRepository.GetByIdAsync(gameId);
            if (game == null)
            {
                return false;
            }

            var gamePlayers = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            if (gamePlayers.Count() > game.Table.MaxPlayers - 1)
            {
                return false;
            }

            var gameRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);
            if (gameRound != null && gameRound.CurrentState != "Waiting")
            {
                return false;
            }

            try
            {
                await gamePlayerRepository.AddPlayerToGameAsync(gameId, userId, seatPosition, buyInAmount);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public async Task<bool> AddModelToGameAsync(int gameId, int userId, int seatPosition, int buyInAmount)
        {
            if (!await userModelRepository.IsUserAiAgent(userId)) return false;

            var game = await gameRepository.GetByIdAsync(gameId);

            bool areThereHumanPlayers =
                (await gamePlayerRepository.GetPlayersByGameIdAsync(gameId)).Any(p =>
                    p.User.IsBot != true && p.IsActive);

            if (!areThereHumanPlayers)
            {
                return false;
            }

            var result = await JoinGameAsync(gameId, userId, seatPosition, buyInAmount);

            if (!result) return false;

            var gamePlayer = await gamePlayerRepository.GetPlayerByGameAndUserAsync(gameId, userId);

            if (!agentsPlayingInGames.ContainsKey(gameId))
            {
                agentsPlayingInGames[gameId] = new HashSet<int>();
            }

            agentsPlayingInGames[gameId].Add(gamePlayer.GamePlayerId);
            return true;
        }

        public async Task<bool> KickModelOutOfGameAsync(int gameId, int userId)
        {
            if (!await userModelRepository.IsUserAiAgent(userId)) return false;

            var gamePlayer = await gamePlayerRepository.GetPlayerByGameAndUserAsync(gameId, userId);

            if (gamePlayer == null) return false;

            var gamePlayerId = gamePlayer.GamePlayerId;

            if (!await LeaveGameAsync(gameId, userId)) return false;

            if (agentsPlayingInGames.ContainsKey(gameId))
            {
                agentsPlayingInGames[gameId].Remove(gamePlayerId);
                if (!agentsPlayingInGames[gameId].Any())
                {
                    agentsPlayingInGames.Remove(gameId);
                }
            }

            return true;
        }

        public async Task<bool> LeaveGameAsync(int gameId, int userId)
        {
            var gamePlayer = await gamePlayerRepository.GetPlayerByGameAndUserAsync(gameId, userId);
            if (gamePlayer == null)
            {
                return false;
            }

            var game = await gameRepository.GetByIdAsync(gameId);
            if (game == null) return false;

            var gameRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);
            if (gameRound != null && gameRound.CurrentState != "Waiting" && gameRound.CurrentState != "Completed")
            {
                return false;
            }

            // If leaving during completed state, remove from acknowledgements if present
            if (gameRound.CurrentState == "Completed" && completedRoundAcknowledgments.ContainsKey(gameId))
            {
                completedRoundAcknowledgments[gameId].Remove(userId);
                // Check if this triggers the next round start
                var playersInGame = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
                var remainingPlayers =
                    playersInGame.Where(p => p.UserId != userId && p.CurrentChips > 0).ToList(); // Players remaining after leave
                if (remainingPlayers.Count() >= 2 &&
                    remainingPlayers.All(p => completedRoundAcknowledgments[gameId].Contains(p.UserId)))
                {
                    completedRoundAcknowledgments.Remove(gameId);
                    await StartNewHandAsync(gameId);
                }
            }
            if (game.CurrentTurnPlayer?.UserId == userId)
            {
                var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
                var remainingActivePlayers = players
                    .Where(p => p.UserId != userId && p.IsActive && p.CurrentChips > 0)
                    .OrderBy(p => p.SeatPosition)
                    .ToList();

                if (remainingActivePlayers.Any())
                    await gameRepository.SetCurrentTurnAsync(gameId, remainingActivePlayers.First().UserId);
                else
                    await gameRepository.SetCurrentTurnAsync(gameId, null);
            }

            var result = await gamePlayerRepository.RemovePlayerFromGameAsync(gamePlayer.GamePlayerId);
            if (result)
            {
                var remainingPlayers = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
                if (remainingPlayers.Count() == 1 && gameRound?.CurrentState != "Waiting")
                    await DetermineWinnerAsync(gameId);
                else if (!remainingPlayers.Any()) await gameRepository.EndGameAsync(gameId);
            }
            return result;
        }

        public async Task<bool> StartGameAsync(int gameId)
        {
            var game = await gameRepository.GetByIdAsync(gameId);
            if (game == null)
            {
                return false;
            }

            var gameRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);
            if (gameRound != null && gameRound.CurrentState != "Waiting" && gameRound.CurrentState != "Completed")
            {
                return false;
            }

            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();

            if (activePlayers.Count < 2)
            {
                return false;
            }

            bool areThereHumanPlayers =
                (await gamePlayerRepository.GetPlayersByGameIdAsync(gameId)).Any(p =>
                    p.User.IsBot != true && p.IsActive);

            if (!areThereHumanPlayers)
            {
                return false;
            }

            await SetInitialDealerAndBlindsAsync(gameId, activePlayers);
            gameRound = await gameRoundRepository.StartNewRoundAsync(gameId);
            await DealInitialCardsAsync(gameId);
            await gameRepository.UpdateGameStateAsync(gameId, "PreFlop");
            await CollectBlindsAsync(gameId, activePlayers);
            await SetFirstPlayerToActAsync(gameId, "PreFlop");

            await CheckAgentsTurns(gameId);

            return true;
        }

        private async Task SetInitialDealerAndBlindsAsync(int gameId, List<GamePlayer> activePlayers)
        {
            int dealerIndex = random.Next(activePlayers.Count);
            var dealer = activePlayers[dealerIndex];
            await gamePlayerRepository.SetDealerPositionAsync(gameId, dealer.GamePlayerId);

            int sbIndex = (dealerIndex + 1) % activePlayers.Count;
            int bbIndex = (dealerIndex + 2) % activePlayers.Count;

            await gamePlayerRepository.SetBlindPositionsAsync(
                gameId,
                activePlayers[sbIndex].GamePlayerId,
                activePlayers[bbIndex].GamePlayerId);
        }

        private async Task CollectBlindsAsync(int gameId, List<GamePlayer> activePlayers)
        {
            var game = await gameRepository.GetByIdAsync(gameId);
            if (game == null) return;
            var table = await gameRepository.GetGameTableAsync(gameId);
            if (table == null) return;
            var currentRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);
            if (currentRound == null) return;


            var sbPlayer = activePlayers.FirstOrDefault(p => p.IsSmallBlind);
            if (sbPlayer != null)
            {
                int sbAmount = Math.Min(table.SmallBlind, sbPlayer.CurrentChips);
                if (sbAmount > 0)
                {
                    await moveRepository.RecordMoveAsync(gameId, currentRound.GameRoundId, sbPlayer.UserId, "Blind",
                        sbAmount, "PreFlop");
                }
            }

            var bbPlayer = activePlayers.FirstOrDefault(p => p.IsBigBlind);
            if (bbPlayer != null)
            {
                int bbAmount = Math.Min(table.BigBlind, bbPlayer.CurrentChips);
                if (bbAmount > 0)
                {
                    await moveRepository.RecordMoveAsync(gameId, currentRound.GameRoundId, bbPlayer.UserId, "Blind",
                        bbAmount, "PreFlop");
                }
            }

            await gameRepository.SaveChangesAsync();
        }

        private async Task DealInitialCardsAsync(int gameId)
        {
            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();
            if (!activePlayers.Any()) return;

            var allCards = await cardRepository.GetAllCardsAsync();
            var shuffledCards = ShuffleCards(allCards.ToList());
            int cardIndex = 0;

            for (int i = 0; i < 2; i++)
            {
                foreach (var player in activePlayers)
                {
                    if (cardIndex < shuffledCards.Count)
                    {
                        await cardRepository.DealPlayerCardAsync(player.GamePlayerId, shuffledCards[cardIndex].CardId,
                            i + 1);
                        cardIndex++;
                    }
                }
            }
        }

        private async Task SetFirstPlayerToActAsync(int gameId, string round)
        {
            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive && p.CurrentChips > 0).OrderBy(p => p.SeatPosition)
                .ToList();

            if (!activePlayers.Any()) return;

            GamePlayer firstToAct = null;

            if (round == "PreFlop")
            {
                if (activePlayers.Count == 2)
                {
                    firstToAct = activePlayers.FirstOrDefault(p => p.IsDealer);
                }
                else
                {
                    var bbPlayer = activePlayers.FirstOrDefault(p => p.IsBigBlind);
                    if (bbPlayer != null)
                    {
                        int bbIndex = activePlayers.IndexOf(bbPlayer);
                        firstToAct = activePlayers[(bbIndex + 1) % activePlayers.Count];
                    }
                }
            }
            else
            {
                if (activePlayers.Count == 2)
                {
                    firstToAct = activePlayers.FirstOrDefault(p => p.IsBigBlind);
                }
                else
                {
                    var dealer = activePlayers.FirstOrDefault(p => p.IsDealer);
                    if (dealer != null)
                    {
                        int dealerIndex = activePlayers.IndexOf(dealer);
                        for (int i = 1; i <= activePlayers.Count; i++)
                        {
                            var nextPlayer = activePlayers[(dealerIndex + i) % activePlayers.Count];
                            if (nextPlayer.IsActive && nextPlayer.CurrentChips > 0)
                            {
                                firstToAct = nextPlayer;
                                break;
                            }
                        }
                    }
                }
            }

            if (firstToAct == null && activePlayers.Any())
            {
                firstToAct = activePlayers.First();
            }


            if (firstToAct != null)
            {
                await gameRepository.SetCurrentTurnAsync(gameId, firstToAct.UserId);
            }
            else
            {
                await gameRepository.SetCurrentTurnAsync(gameId, null);
            }
        }


        public async Task<bool> PlaceBetAsync(int gameId, int userId, string actionType, int amount)
        {
            var game = await gameRepository.GetByIdAsync(gameId);
            if (game == null) return false;

            var gameRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);
            if (gameRound == null) return false;

            var gamePlayer = await gamePlayerRepository.GetPlayerByGameAndUserAsync(gameId, userId);
            if (gamePlayer == null)
            {
                return false;
            }

            // Handle acknowledgement in "Completed" state
            if (gameRound.CurrentState == "Completed")
            {
                if (actionType != "Check")
                {
                    return false;
                }

                if (!completedRoundAcknowledgments.ContainsKey(gameId))
                {
                    completedRoundAcknowledgments[gameId] = new HashSet<int>();
                }

                completedRoundAcknowledgments[gameId].Add(userId);

                var playersInGame = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
                var relevantPlayers = playersInGame.Where(p => p.User.IsBot != true
                                                               && p.CurrentChips > 0).ToList();

                if (relevantPlayers.Any() &&
                    relevantPlayers.All(p => completedRoundAcknowledgments[gameId].Contains(p.UserId)))
                {
                    completedRoundAcknowledgments.Remove(gameId);
                    await StartNewHandAsync(gameId);
                }

                return true;
            }


            if (game.CurrentTurnPlayerId != gamePlayer.GamePlayerId || gameRound.CurrentState == "Waiting" ||
                gameRound.CurrentState == "Showdown" ||
                gameRound.CurrentState == "Completed")
            {
                return false;
            }

            if (!gamePlayer.IsActive ||
                gamePlayer.CurrentChips == 0 && actionType != "Check") // Can check even with 0 chips if no bet faced
            {
                return false;
            }

            var playerContributions =
                await moveRepository.GetPlayerContributionsForRoundAsync(gameId, gameRound.GameRoundId,
                    gameRound.CurrentState);
            int currentPlayerContribution = playerContributions.GetValueOrDefault(userId, 0);
            int highestContributionInRound = playerContributions.Any() ? playerContributions.Values.Max() : 0;
            int callAmount = highestContributionInRound - currentPlayerContribution;

            bool isValidMove = false;
            int effectiveAmount = 0;

            switch (actionType)
            {
                case "Fold":
                    isValidMove = true;
                    effectiveAmount = 0;
                    break;
                case "Check":
                    isValidMove = (callAmount == 0);
                    effectiveAmount = 0;
                    break;
                case "Call":
                    if (callAmount == 0)
                    {
                        isValidMove = true;
                        effectiveAmount = 0;
                        actionType = "Check";
                    }
                    else if (callAmount >= gamePlayer.CurrentChips)
                    {
                        effectiveAmount = gamePlayer.CurrentChips;
                        actionType = "AllIn";
                        isValidMove = true;
                    }
                    else if (callAmount > 0 && callAmount < gamePlayer.CurrentChips)
                    {
                        effectiveAmount = callAmount;
                        isValidMove = true;
                    }

                    break;
                case "Bet":
                    isValidMove = (callAmount == 0 &&
                                   amount >= (await gameRepository.GetGameTableAsync(gameId)).BigBlind &&
                                   amount <= gamePlayer.CurrentChips);
                    if (isValidMove) effectiveAmount = amount;
                    break;
                case "Raise":
                    int minRaiseAmount = 2 * callAmount;
                    minRaiseAmount = Math.Max(minRaiseAmount,
                        (await gameRepository.GetGameTableAsync(gameId)).BigBlind);
                    // for AI agent reasons, we allow rasig even if callAmount is 0, as long as the raise is valid
                    if (amount >= gamePlayer.CurrentChips)
                    {
                        isValidMove = true;
                        actionType = "AllIn";
                        amount = gamePlayer.CurrentChips;
                    }
                    else
                    {
                        isValidMove = amount >= minRaiseAmount && amount <= gamePlayer.CurrentChips;
                    }

                    if (isValidMove) effectiveAmount = amount;
                    break;
                case "AllIn":
                    isValidMove = gamePlayer.CurrentChips > 0;
                    if (isValidMove) effectiveAmount = gamePlayer.CurrentChips;
                    break;
                default:
                    return false;
            }


            if (!isValidMove)
            {
                return false;
            }

            if (actionType == "Fold")
            {
                await gamePlayerRepository.SetPlayerStatusAsync(gamePlayer.GamePlayerId, false);
                await moveRepository.RecordMoveAsync(gameId, gameRound.GameRoundId, userId, actionType, 0,
                    gameRound.CurrentState);
            }
            else
            {
                int amountForRecord =
                    (actionType == "Call" || actionType == "Raise" || actionType == "Bet" || actionType == "AllIn")
                        ? effectiveAmount
                        : 0;
                await moveRepository.RecordMoveAsync(gameId, gameRound.GameRoundId, userId, actionType,
                    amountForRecord, gameRound.CurrentState);
            }

            await gameRepository.SaveChangesAsync();

            bool roundComplete = await CheckRoundCompleteAsync(gameId);

            if (roundComplete)
            {
                await AdvanceGameStateAsync(gameId);
            }
            else
            {
                await SetNextPlayerTurnAsync(gameId);
            }

            await CheckAgentsTurns(gameId);

            return true;
        }

        private async Task SetNextPlayerTurnAsync(int gameId)
        {
            var game = await gameRepository.GetByIdAsync(gameId);
            if (game?.CurrentTurnPlayerId == null) return;

            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players
                .Where(p => p.IsActive)
                .OrderBy(p => p.SeatPosition)
                .ToList();
            var activePlayersWithChips = activePlayers
                .Where(p => p.CurrentChips > 0)
                .OrderBy(p => p.SeatPosition)
                .ToList();

            if (activePlayersWithChips.Count == 0)
            {
                return;
            }

            var currentPlayer = activePlayersWithChips.FirstOrDefault(p => p.GamePlayerId == game.CurrentTurnPlayerId) ??
                                activePlayers.FirstOrDefault(p => p.GamePlayerId == game.CurrentTurnPlayerId);
            if (currentPlayer == null)
            {
                var originalPlayer = players.FirstOrDefault(p => p.GamePlayerId == game.CurrentTurnPlayerId);
                int searchStartIndex = originalPlayer != null
                    ? players.OrderBy(p => p.SeatPosition).ToList().IndexOf(originalPlayer)
                    : -1;

                if (searchStartIndex != -1)
                {
                    var orderedPlayers = players.OrderBy(p => p.SeatPosition).ToList();
                    for (int i = 1; i <= orderedPlayers.Count; i++)
                    {
                        var potentialNextPlayer = orderedPlayers[(searchStartIndex + i) % orderedPlayers.Count];
                        if (potentialNextPlayer.IsActive && potentialNextPlayer.CurrentChips > 0)
                        {
                            await gameRepository.SetCurrentTurnAsync(gameId, potentialNextPlayer.UserId);
                            return;
                        }
                    }
                }

                await gameRepository.SetCurrentTurnAsync(gameId,
                    activePlayersWithChips?.First()?.UserId ?? activePlayers?.First()?.UserId);
                return;
            }

            int currentIndex = activePlayersWithChips.IndexOf(currentPlayer);
            var nextPlayer = activePlayersWithChips[(currentIndex + 1) % activePlayersWithChips.Count];

            await gameRepository.SetCurrentTurnAsync(gameId, nextPlayer.UserId);
        }


        private async Task<bool> CheckRoundCompleteAsync(int gameId)
        {
            var game = await gameRepository.GetByIdAsync(gameId);
            if (game == null) return false;

            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();
            var activePlayersWithChips = activePlayers.Where(p => p.CurrentChips > 0).ToList();

            if (activePlayersWithChips.Count == 0)
            {
                return true;
            }

            var currentRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);
            var playerContributions =
                await moveRepository.GetPlayerContributionsForRoundAsync(gameId, currentRound.GameRoundId,
                    currentRound.CurrentState);
            var movesThisRound =
                await moveRepository.GetMovesByGameRoundAsync(gameId, currentRound.GameRoundId,
                    currentRound.CurrentState);

            int highestContribution = playerContributions.Any() ? playerContributions.Values.Max() : 0;

            bool allBetsMatched = true;
            bool allPlayersActed = true;

            var lastAggressiveAction = movesThisRound
                .Where(m => m.ActionType == "Bet" || m.ActionType == "Raise")
                .OrderByDescending(m => m.MoveTime)
                .FirstOrDefault();

            DateTime actionCutoff = lastAggressiveAction?.MoveTime ?? DateTime.MinValue;


            foreach (var player in activePlayersWithChips)
            {
                int contribution = playerContributions.GetValueOrDefault(player.UserId, 0);

                if (contribution < highestContribution && player.CurrentChips > 0)
                {
                    allBetsMatched = false;
                }

                bool actedSinceCutoff = movesThisRound.Any(m =>
                    m.PlayerId == player.UserId && m.MoveTime >= actionCutoff && m.ActionType != "Blind");
                //bool isBBPreflopCheckOption = game.CurrentState == "PreFlop" && player.IsBigBlind &&
                //                              highestContribution == (await gameRepository.GetGameTableAsync(gameId))
                //                              .BigBlind && !actedSinceCutoff;


                if (!actedSinceCutoff && player.CurrentChips > 0)
                {
                    allPlayersActed = false;
                }

                if (!allBetsMatched || !allPlayersActed) break;
            }

            if (currentRound.CurrentState == "PreFlop")
            {
                var bbPlayer = activePlayersWithChips.FirstOrDefault(p => p.IsBigBlind);
                if (bbPlayer != null &&
                    highestContribution == (await gameRepository.GetGameTableAsync(gameId)).BigBlind)
                {
                    bool bbActed = movesThisRound.Any(m => m.PlayerId == bbPlayer.UserId && m.ActionType != "Blind");
                    if (!bbActed)
                    {
                        allPlayersActed = false;
                    }
                }
            }


            return allBetsMatched && allPlayersActed;
        }

        private async Task AdvanceGameStateAsync(int gameId)
        {
            var game = await gameRepository.GetByIdAsync(gameId);
            if (game == null) return;

            var gameRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);

            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();

            if (activePlayers.Count <= 1 && gameRound.CurrentState != "Completed")
            {
                await DetermineWinnerAsync(gameId);
                return;
            }

            string nextState = "";
            bool requireNextRoundActions = true;

            switch (gameRound.CurrentState)
            {
                case "PreFlop":
                    await DealCommunityCardsAsync(gameId, 3);
                    nextState = "Flop";
                    break;
                case "Flop":
                    await DealCommunityCardsAsync(gameId, 1);
                    nextState = "Turn";
                    break;
                case "Turn":
                    await DealCommunityCardsAsync(gameId, 1);
                    nextState = "River";
                    break;
                case "River":
                    nextState = "Showdown";
                    requireNextRoundActions = false;
                    break;
                case "Showdown":
                case "Completed":
                    requireNextRoundActions = false;
                    return;
            }

            if (!string.IsNullOrEmpty(nextState))
            {
                await gameRepository.UpdateGameStateAsync(gameId, nextState);
                if (requireNextRoundActions)
                {
                    await SetFirstPlayerToActAsync(gameId, nextState);
                }
                else if (nextState == "Showdown")
                {
                    await gameRepository.SetCurrentTurnAsync(gameId, null);
                    await DetermineWinnerAsync(gameId);
                }
            }

            var activePlayersWithChips = activePlayers.Where(p => p.CurrentChips > 0).ToList();
            gameRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);

            if (activePlayersWithChips.Count < 2 && (gameRound.CurrentState == "Flop" ||
                                                     gameRound.CurrentState == "Turn" ||
                                                     gameRound.CurrentState == "River"))
            {
                await AdvanceGameStateAsync(gameId);
            }
        }

        private async Task DealCommunityCardsAsync(int gameId, int count)
        {
            var game = await gameRepository.GetByIdAsync(gameId);
            if (game == null) return;

            var allCards = await cardRepository.GetAllCardsAsync();
            var usedCardIds = new HashSet<int>();

            var communityCards = await cardRepository.GetCommunityCardsByGameIdAsync(gameId);
            foreach (var card in communityCards) usedCardIds.Add(card.CardId);

            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            foreach (var player in players)
            {
                var playerCards = await cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);
                foreach (var card in playerCards) usedCardIds.Add(card.CardId);
            }

            var availableCards = allCards.Where(c => !usedCardIds.Contains(c.CardId)).ToList();
            var shuffledAvailableCards = ShuffleCards(availableCards);

            int currentCommunityCardCount = communityCards.Count();
            for (int i = 0; i < count && i < shuffledAvailableCards.Count; i++)
            {
                await cardRepository.DealCommunityCardAsync(gameId, shuffledAvailableCards[i].CardId,
                    currentCommunityCardCount + i + 1);
            }
        }
        public class SidePot
        {
            public int Amount { get; set; }
            public List<int> EligiblePlayers { get; set; } = new List<int>();
        }

        private async Task<List<SidePot>> CalculateSidePotsAsync(int gameId, int gameRoundId)
        {
            var sidePods = new List<SidePot>();
            var allmoves = await moveRepository.GetMovesByGameIdAsync(gameId);

            var playercontr = new Dictionary<int, int>();
            foreach(var move in allmoves.Where(m =>
                        m.ActionType == "Bet" || m.ActionType == "Call" || 
                        m.ActionType == "Raise" || m.ActionType == "AllIn" || 
                        m.ActionType == "Blind")){
                if (!playercontr.ContainsKey(move.PlayerId))
                {
                    playercontr[move.PlayerId] = 0;
                }
                playercontr[move.PlayerId] += move.Amount;
            }
            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).Select(p => p.UserId).ToList();
            var contributingPlayers = playercontr
                .Where(kvp => activePlayers.Contains(kvp.Key))
                .OrderBy(kvp => kvp.Value)
                .ToList();
            while (contributingPlayers.Any())
            {
                var smallestContribution = contributingPlayers.First();
                var potAmount = 0;
                var eligiblePlayers = new List<int>();
                
                foreach (var player in contributingPlayers.ToList())
                {
                    var contribution = Math.Min(player.Value, smallestContribution.Value);
                    potAmount += contribution;
                    eligiblePlayers.Add(player.Key);
                    
                    if (player.Value <= smallestContribution.Value)
                    {
                        contributingPlayers.Remove(player);
                    }
                    else
                    {
                        var index = contributingPlayers.FindIndex(kvp => kvp.Key == player.Key);
                        contributingPlayers[index] = new KeyValuePair<int, int>(
                            player.Key, 
                            player.Value - smallestContribution.Value);
                    }
                }

                if (potAmount > 0)
                {
                    sidePods.Add(new SidePot
                    {
                        Amount = potAmount,
                        EligiblePlayers = eligiblePlayers
                    });
                }
            }

            return sidePods;
        }
        public async Task<bool> DetermineWinnerAsync(int gameId)
        {
            var game = await gameRepository.GetByIdAsync(gameId);
            if (game == null) return false;

            var gameRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);
            if (gameRound == null) return false;

            if (gameRound.CurrentState != "Showdown")
            {
                var activePlayersCheck = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
                if (activePlayersCheck.Count(p => p.IsActive) > 1) return false;
            }

            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var activePlayers = players.Where(p => p.IsActive).ToList();

            if (activePlayers.Count == 1)
            {
                int totalPot = await gameRepository.GetPotSizeAsync(gameId);
                await gameRoundWinnerRepository.AddWinnerAsync(gameRound.GameRoundId, activePlayers.Single().UserId, totalPot);
            }
            else
            {
                if (gameRound.CurrentState != "Showdown")
                {
                    await gameRepository.UpdateGameStateAsync(gameId, "Showdown");
                }
                
                var sidePots = await CalculateSidePotsAsync(gameId, gameRound.GameRoundId);
                
                var communityCards = await cardRepository.GetCommunityCardsByGameIdAsync(gameId);
                
                var playerHandRanks = new Dictionary<int, int>();
                foreach (var player in activePlayers)
                {
                    var playerCards = await cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);
                    var allCards = communityCards.Concat(playerCards).ToList();
                    int handRank = PokerHandEvaluator.EvaluateHand(allCards);
                    playerHandRanks[player.UserId] = handRank;
                }
                
                foreach (var sidePot in sidePots)
                {
                    var eligiblePlayers = activePlayers
                        .Where(p => sidePot.EligiblePlayers.Contains(p.UserId))
                        .ToList();

                    if (eligiblePlayers.Count == 0) continue;

                    if (eligiblePlayers.Count == 1)
                    {
                        await gameRoundWinnerRepository.AddWinnerAsync(gameRound.GameRoundId, 
                            eligiblePlayers.First().UserId, sidePot.Amount);
                    }
                    else
                    {
                        var eligibleHandRanks = eligiblePlayers
                            .Select(p => new { UserId = p.UserId, Rank = playerHandRanks[p.UserId] })
                            .OrderByDescending(x => x.Rank)
                            .ToList();

                        int bestRank = eligibleHandRanks.First().Rank;
                        var potWinners = eligibleHandRanks
                            .Where(x => x.Rank == bestRank)
                            .Select(x => x.UserId)
                            .ToList();

                        if (potWinners.Count == 1)
                        {
                            await gameRoundWinnerRepository.AddWinnerAsync(gameRound.GameRoundId, 
                                potWinners.First(), sidePot.Amount);
                        }
                        else
                        {
                            int potPerWinner = sidePot.Amount / potWinners.Count;
                            int remainder = sidePot.Amount % potWinners.Count;
                            var winnerAmounts = potWinners.ToDictionary(id => id, id => potPerWinner);
                            
                            if (remainder > 0)
                            {
                                var dealer = players.FirstOrDefault(p => p.IsDealer);
                                int dealerPos = dealer?.SeatPosition ?? 0;

                                var orderedWinners = potWinners
                                    .Select(id => players.First(p => p.UserId == id))
                                    .OrderBy(p => (p.SeatPosition - dealerPos + players.Count()) % players.Count())
                                    .ToList();

                                for (int i = 0; i < remainder; i++)
                                {
                                    winnerAmounts[orderedWinners[i].UserId]++;
                                }
                            }

                            await gameRoundWinnerRepository.AddMultipleWinnersAsync(gameRound.GameRoundId, winnerAmounts);
                        }
                    }
                }
            }

            await gameRoundRepository.EndRoundAsync(gameRound.GameRoundId);
            await gameRepository.UpdateGameStateAsync(gameId, "Completed");
            await gameRepository.SetCurrentTurnAsync(gameId, null);

            return true;
        }


        private async Task<bool> StartNewHandAsync(int gameId)
        {
            var game = await gameRepository.GetByIdAsync(gameId);
            if (game == null) return false;

            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var playersWithChips = players.Where(p => p.CurrentChips > 0).ToList();

            if (playersWithChips.Count < 2)
            {
                // TODO: Change game state to "Waiting" if not enough players
                await gameRepository.EndGameAsync(gameId);
                return false;
            }

            foreach (var player in playersWithChips)
            {
                await gamePlayerRepository.SetPlayerStatusAsync(player.GamePlayerId, true);
            }

            foreach (var player in players.Where(p => p.CurrentChips <= 0))
            {
                await gamePlayerRepository.SetPlayerStatusAsync(player.GamePlayerId, false);
            }

            bool areThereHumanPlayers =
                (await gamePlayerRepository.GetPlayersByGameIdAsync(gameId)).Any(p =>
                    p.User.IsBot != true && p.IsActive);

            if (!areThereHumanPlayers)
            {
                return false;
            }

            await RotateDealerAndSetBlindsAsync(gameId);
            await gameRepository.UpdatePotSizeAsync(gameId, 0);
            var newRound = await gameRoundRepository.StartNewRoundAsync(gameId);

            await DealInitialCardsAsync(gameId);
            await gameRepository.UpdateGameStateAsync(gameId, "PreFlop");

            var currentPlayers = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            await CollectBlindsAsync(gameId, currentPlayers.Where(p => p.IsActive).ToList());
            await SetFirstPlayerToActAsync(gameId, "PreFlop");

            await CheckAgentsTurns(gameId);

            return true;
        }

        private async Task RotateDealerAndSetBlindsAsync(int gameId)
        {
            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);

            var activePlayersWithChips = players.Where(p => p.CurrentChips > 0).OrderBy(p => p.SeatPosition).ToList();

            if (activePlayersWithChips.Count < 2) return;

            var currentDealer = activePlayersWithChips.FirstOrDefault(p => p.IsDealer);
            int currentDealerIndex = currentDealer != null ? activePlayersWithChips.IndexOf(currentDealer) : -1;

            GamePlayer nextDealer = null;
            if (currentDealerIndex != -1)
            {
                for (int i = 1; i <= activePlayersWithChips.Count; i++)
                {
                    var potentialDealer =
                        activePlayersWithChips[(currentDealerIndex + i) % activePlayersWithChips.Count];
                    if (potentialDealer.CurrentChips > 0)
                    {
                        nextDealer = potentialDealer;
                        break;
                    }
                }
            }

            if (nextDealer == null)
            {
                nextDealer = activePlayersWithChips.First();
            }


            await gamePlayerRepository.SetDealerPositionAsync(gameId, nextDealer.GamePlayerId);

            int newDealerIndex = activePlayersWithChips.IndexOf(nextDealer);
            GamePlayer sbPlayer = null;
            GamePlayer bbPlayer = null;

            if (activePlayersWithChips.Count == 2)
            {
                sbPlayer = nextDealer;
                bbPlayer = activePlayersWithChips[(newDealerIndex + 1) % activePlayersWithChips.Count];
            }
            else
            {
                for (int i = 1; i <= activePlayersWithChips.Count; i++)
                {
                    var potentialSB = activePlayersWithChips[(newDealerIndex + i) % activePlayersWithChips.Count];
                    if (potentialSB.CurrentChips > 0)
                    {
                        sbPlayer = potentialSB;
                        break;
                    }
                }

                if (sbPlayer != null)
                {
                    int sbIndex = activePlayersWithChips.IndexOf(sbPlayer);
                    for (int i = 1; i <= activePlayersWithChips.Count; i++)
                    {
                        var potentialBB = activePlayersWithChips[(sbIndex + i) % activePlayersWithChips.Count];
                        if (potentialBB.CurrentChips > 0)
                        {
                            bbPlayer = potentialBB;
                            break;
                        }
                    }
                }
            }

            if (sbPlayer == null || bbPlayer == null)
            {
                // Handle error - maybe assign to first two players? Log warning?
                // For now, proceed with potentially null blinds if logic failed.
                await gamePlayerRepository.SetBlindPositionsAsync(gameId, sbPlayer?.GamePlayerId ?? 0,
                    bbPlayer?.GamePlayerId ?? 0);
            }
            else
            {
                await gamePlayerRepository.SetBlindPositionsAsync(gameId, sbPlayer.GamePlayerId, bbPlayer.GamePlayerId);
            }
        }


        public async Task<GameStateDto> GetGameStateAsync(int gameId, int userId)
        {
            var game = await gameRepository.GetByIdAsync(gameId);
            if (game == null) return null;

            var table = await gameRepository.GetGameTableAsync(gameId);
            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var communityCards = await cardRepository.GetCommunityCardsByGameIdAsync(gameId);
            var currentRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);
            var lastMoves = await moveRepository.GetMovesByGameIdAsync(gameId);
            var roundWinners = currentRound != null
                ? await gameRoundWinnerRepository.GetByGameRoundIdAsync(currentRound.GameRoundId)
                : new List<GameRoundWinner>();
            var playerContributions = currentRound != null
                ? await moveRepository.GetPlayerContributionsForRoundAsync(gameId, currentRound.GameRoundId,
                    currentRound.CurrentState)
                : new Dictionary<int, int>();

            List<CardDto> requestingPlayerCards = new List<CardDto>();
            var requestingPlayer = players.FirstOrDefault(p => p.UserId == userId);

            if (requestingPlayer != null)
            {
                var playerCardsRaw =
                    await cardRepository.GetPlayerCardsByGamePlayerIdAsync(requestingPlayer.GamePlayerId);
                requestingPlayerCards =
                    playerCardsRaw.Select(c => new CardDto { Suit = c.Suit, Value = c.Value }).ToList();
            }

            bool showAllCards = currentRound != null &&
                                (currentRound?.CurrentState == "Showdown" || currentRound?.CurrentState == "Completed");

            int highestContributionInRound = playerContributions.Any() ? playerContributions.Values.Max() : 0;
            int requestingPlayerContribution = userId > 0 ? playerContributions.GetValueOrDefault(userId, 0) : 0;
            int callAmount = highestContributionInRound - requestingPlayerContribution;
            callAmount = Math.Max(0, callAmount);

            int minRaiseAmount = Math.Max(2 * callAmount, (await gameRepository.GetGameTableAsync(gameId)).BigBlind);

            var gameStateDto = new GameStateDto
            {
                GameId = game.GameId,
                TableId = game.TableId,
                TableName = table?.Name ?? "Unknown Table",
                CurrentState = currentRound?.CurrentState ?? "Unknown",
                PotSize = game.PotSize,
                CurrentTurnUserId = game.CurrentTurnPlayer?.UserId ?? 0,
                CommunityCards = communityCards.Select(c => new CardDto { Suit = c.Suit, Value = c.Value }).ToList(),
                Players = players.Select(p => new PlayerStateDto
                {
                    UserId = p.UserId,
                    Username = p.User?.Username ?? "Unknown",
                    CurrentChips = p.CurrentChips,
                    IsActive = p.IsActive,
                    IsDealer = p.IsDealer,
                    IsSmallBlind = p.IsSmallBlind,
                    IsBigBlind = p.IsBigBlind,
                    SeatPosition = p.SeatPosition,
                    Cards = (showAllCards || p.UserId == userId)
                        ? (cardRepository.GetPlayerCardsByGamePlayerIdAsync(p.GamePlayerId).Result ?? new List<Card>())
                        .Select(c => new CardDto { Suit = c.Suit, Value = c.Value }).ToList()
                        : new List<CardDto>()
                }).ToList(),
                PlayerCards = requestingPlayerCards,
                LastMoves = lastMoves.OrderByDescending(m => m.MoveTime).Take(10).Select(m => new MoveDto
                {
                    PlayerId = m.PlayerId,
                    ActionType = m.ActionType,
                    Amount = m.Amount,
                    MoveTime = m.MoveTime
                }).ToList(),
                RoundWinners = roundWinners.Select(rw => new RoundWinnerDto
                    { UserId = rw.UserId, Username = rw.User.Username, AmountWon = rw.AmountWon }).ToList(),
                PlayerRoundContributions = playerContributions,
                CallAmount = callAmount,
                MinRaiseAmount = minRaiseAmount
            };

            return gameStateDto;
        }

        private List<Card> ShuffleCards(List<Card> cards)
        {
            int n = cards.Count;
            while (n > 1)
            {
                n--;
                int k = random.Next(n + 1);
                Card value = cards[k];
                cards[k] = cards[n];
                cards[n] = value;
            }

            return cards;
        }

        private async Task<bool> CheckAgentsTurns(int gameId)
        {
            var game = await gameRepository.GetByIdAsync(gameId);

            if (game?.CurrentTurnPlayerId == null) return false;

            var currentPlayer = game.CurrentTurnPlayer;

            var currentTurnAgent = agentsPlayingInGames
                .FirstOrDefault(g => g.Key == gameId && g.Value.Contains(currentPlayer.GamePlayerId));

            if (currentTurnAgent.Value == null || !currentTurnAgent.Value.Any())
            {
                return false;
            }

            bool moveMade = true;
            var result = await MakeAgentTurn(game.GameId, currentPlayer.GamePlayerId);
            if (!result)
            {
                Console.WriteLine($"Agent {currentPlayer.UserId} could not make a move in game {game.GameId}");
            }
            if (moveMade)
            {
                await CheckAgentsTurns(gameId);
            }
            return moveMade;
        }

        private async Task<bool> MakeAgentTurn(int gameId, int GamePlayerId)
        {
            var game = await gameRepository.GetByIdAsync(gameId);

            if (game == null || game.CurrentTurnPlayerId != GamePlayerId)
            {
                return false;
            }

            var userId = game.CurrentTurnPlayer.UserId;

            GameStateDto gameState = await GetGameStateAsync(gameId, userId);

            MoveDto move = await aiAgentService.GetBestActionAsync(gameState);

            await Task.Delay(3000);


            var result = await PlaceBetAsync(gameId, userId, move.ActionType, move.Amount);

            if (!result)
            {
                Console.WriteLine(
                    $"Agent {userId} tried to make a move {move.ActionType} with amount {move.Amount} in game {gameId}, but failed.");
                await PlaceBetAsync(gameId, userId, "Fold", 0);
            }
            Console.WriteLine($"Agent {userId} made a move {move.ActionType} with amount {move.Amount} in game {gameId}.");
            return result;
        }

        public async Task<IEnumerable<AgentDto>> GetAvailableAgentsAsync(int gameId)
        {
            var game = await gameRepository.GetByIdAsync(gameId);

            bool areThereHumanPlayers =
                (await gamePlayerRepository.GetPlayersByGameIdAsync(gameId)).Any(p =>
                    p.User.IsBot != true && p.IsActive);

            if (!areThereHumanPlayers)
            {
                return Enumerable.Empty<AgentDto>();
            }

            var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var agentsInGame = players
                .Where(p => p.User.IsBot == true)
                .Select(p => p.User)
                .ToList();

            var allAgents = await userModelRepository.GetAllBotUsersAsync();
            var availableAgents = allAgents
                .Where(a => agentsInGame.All(ag => ag.UserId != a.UserId))
                .ToList();

            return availableAgents.Select(a => new AgentDto
            {
                UserId = a.UserId,
                Username = a.Username,
                Name = a.UserModels.FirstOrDefault()?.Model.Name ?? "Unknown",
                Difficulty = a.UserModels.FirstOrDefault()?.Model.Difficulty ?? "Unknown"
            });
        }
        public async Task<bool> InitializeAgentsPlayingInGames()
        {
            var agentsInGames = await gamePlayerRepository.GetAllAgentsInGamesAsync();

            if (agentsInGames == null || !agentsInGames.Any())
            {
                return false;
            }

            foreach (var agent in agentsInGames)
            {
                if (!agentsPlayingInGames.ContainsKey(agent.GameId))
                {
                    agentsPlayingInGames[agent.GameId] = new HashSet<int>();
                }
                agentsPlayingInGames[agent.GameId].Add(agent.GamePlayerId);
            }
            return true;
        }
    }
}