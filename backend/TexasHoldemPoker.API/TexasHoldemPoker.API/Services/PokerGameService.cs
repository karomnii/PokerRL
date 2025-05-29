// PokerGameService.cs

using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Helpers;
using TexasHoldemPoker.API.Models;
using TexasHoldemPoker.API.Repositories;

namespace TexasHoldemPoker.API.Services;

public class PokerGameService : IPokerGameService
{
    private static readonly Dictionary<int, HashSet<int>>
        completedRoundAcknowledgments = new();

    private readonly ICardRepository cardRepository;
    private readonly IChipTransactionRepository chipTransactionRepository;
    private readonly IGamePlayerRepository gamePlayerRepository;
    private readonly IGameRepository gameRepository;
    private readonly IGameRoundRepository gameRoundRepository;
    private readonly IGameRoundWinnerRepository gameRoundWinnerRepository;
    private readonly IMoveRepository moveRepository;
    private readonly Random random = new();

    public PokerGameService(
        IGameRepository gameRepository,
        IGamePlayerRepository gamePlayerRepository,
        ICardRepository cardRepository,
        IMoveRepository moveRepository,
        IChipTransactionRepository chipTransactionRepository,
        IGameRoundRepository gameRoundRepository,
        IGameRoundWinnerRepository gameRoundWinnerRepository)
    {
        this.gameRepository = gameRepository;
        this.gamePlayerRepository = gamePlayerRepository;
        this.cardRepository = cardRepository;
        this.moveRepository = moveRepository;
        this.chipTransactionRepository = chipTransactionRepository;
        this.gameRoundRepository = gameRoundRepository;
        this.gameRoundWinnerRepository = gameRoundWinnerRepository;
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
        if (game == null) return false;

        var gamePlayers = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
        if (gamePlayers.Count() > game.Table.MaxPlayers - 1) return false;

        var gameRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);
        if (gameRound != null && gameRound.CurrentState != "Waiting") return false;

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

    public async Task<bool> LeaveGameAsync(int gameId, int userId)
    {
        var gamePlayer = await gamePlayerRepository.GetPlayerByGameAndUserAsync(gameId, userId);
        if (gamePlayer == null) return false;

        var game = await gameRepository.GetByIdAsync(gameId);
        if (game == null) return false;

        var gameRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);

        if (gameRound != null &&
            gameRound.CurrentState != "Waiting" &&
            gameRound.CurrentState != "Completed")
            return false;

        if (gameRound?.CurrentState == "Completed" && completedRoundAcknowledgments.ContainsKey(gameId))
        {
            completedRoundAcknowledgments[gameId].Remove(userId);

            var playersInGame = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var remainingPlayers = playersInGame
                .Where(p => p.UserId != userId && p.CurrentChips > 0)
                .ToList();

            if (remainingPlayers.Count >= 2 &&
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
        if (game == null) return false;

        var gameRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);
        if (gameRound != null && gameRound.CurrentState != "Waiting" &&
            gameRound.CurrentState != "Completed") return false;

        var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
        var activePlayers = players.Where(p => p.IsActive).ToList();

        if (activePlayers.Count < 2) return false;

        await SetInitialDealerAndBlindsAsync(gameId, activePlayers);
        await DealInitialCardsAsync(gameId);
        gameRound = await gameRoundRepository.StartNewRoundAsync(gameId);
        await gameRepository.UpdateGameStateAsync(gameId, "PreFlop");
        await CollectBlindsAsync(gameId, activePlayers);
        await SetFirstPlayerToActAsync(gameId, "PreFlop");

        return true;
    }


    public async Task<bool> PlaceBetAsync(int gameId, int userId, string actionType, int amount)
    {
        var game = await gameRepository.GetByIdAsync(gameId);
        if (game == null) return false;

        var gameRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);
        if (gameRound == null) return false;

        var gamePlayer = await gamePlayerRepository.GetPlayerByGameAndUserAsync(gameId, userId);
        if (gamePlayer == null) return false;

        // Handle acknowledgement in "Completed" state
        if (gameRound.CurrentState == "Completed")
        {
            if (actionType != "Check") return false;

            if (!completedRoundAcknowledgments.ContainsKey(gameId))
                completedRoundAcknowledgments[gameId] = new HashSet<int>();

            completedRoundAcknowledgments[gameId].Add(userId);

            var playersInGame = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
            var relevantPlayers = playersInGame.Where(p => p.CurrentChips > 0).ToList();

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
            return false;

        if (!gamePlayer.IsActive ||
            (gamePlayer.CurrentChips == 0 && actionType != "Check")) // Can check even with 0 chips if no bet faced
            return false;

        var playerContributions =
            await moveRepository.GetPlayerContributionsForRoundAsync(gameId, gameRound.GameRoundId,
                gameRound.CurrentState);
        var currentPlayerContribution = playerContributions.GetValueOrDefault(userId, 0);
        var highestContributionInRound = playerContributions.Any() ? playerContributions.Values.Max() : 0;
        var callAmount = highestContributionInRound - currentPlayerContribution;

        var isValidMove = false;
        var effectiveAmount = 0;

        switch (actionType)
        {
            case "Fold":
                isValidMove = true;
                effectiveAmount = 0;
                break;
            case "Check":
                isValidMove = callAmount == 0;
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
                isValidMove = callAmount == 0 &&
                              amount >= (await gameRepository.GetGameTableAsync(gameId)).BigBlind &&
                              amount <= gamePlayer.CurrentChips;
                if (isValidMove) effectiveAmount = amount;
                break;
            case "Raise":
                var minRaiseAmount = 2 * callAmount;
                minRaiseAmount = Math.Max(minRaiseAmount,
                    (await gameRepository.GetGameTableAsync(gameId)).BigBlind);

                isValidMove = (callAmount > 0 || highestContributionInRound == 0) &&
                              amount >= minRaiseAmount &&
                              currentPlayerContribution + amount <= gamePlayer.CurrentChips;

                if (isValidMove) effectiveAmount = amount;
                break;
            case "AllIn":
                isValidMove = gamePlayer.CurrentChips > 0;
                if (isValidMove) effectiveAmount = gamePlayer.CurrentChips;
                break;
            default:
                return false;
        }


        if (!isValidMove) return false;

        if (actionType == "Fold")
        {
            await gamePlayerRepository.SetPlayerStatusAsync(gamePlayer.GamePlayerId, false);
            await moveRepository.RecordMoveAsync(gameId, gameRound.GameRoundId, userId, actionType, 0,
                gameRound.CurrentState);
        }
        else
        {
            var amountForRecord =
                actionType == "Call" || actionType == "Raise" || actionType == "Bet" || actionType == "AllIn"
                    ? effectiveAmount
                    : 0;
            await moveRepository.RecordMoveAsync(gameId, gameRound.GameRoundId, userId, actionType,
                amountForRecord, gameRound.CurrentState);
        }

        await gameRepository.SaveChangesAsync();

        var roundComplete = await CheckRoundCompleteAsync(gameId);

        if (roundComplete)
            await AdvanceGameStateAsync(gameId);
        else
            await SetNextPlayerTurnAsync(gameId);

        return true;
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

        var requestingPlayerCards = new List<CardDto>();
        var requestingPlayer = players.FirstOrDefault(p => p.UserId == userId);

        if (requestingPlayer != null)
        {
            var playerCardsRaw =
                await cardRepository.GetPlayerCardsByGamePlayerIdAsync(requestingPlayer.GamePlayerId);
            requestingPlayerCards =
                playerCardsRaw.Select(c => new CardDto { Suit = c.Suit, Value = c.Value }).ToList();
        }

        var showAllCards = currentRound != null &&
                           (currentRound?.CurrentState == "Showdown" || currentRound?.CurrentState == "Completed");

        var highestContributionInRound = playerContributions.Any() ? playerContributions.Values.Max() : 0;
        var requestingPlayerContribution = userId > 0 ? playerContributions.GetValueOrDefault(userId, 0) : 0;
        var callAmount = highestContributionInRound - requestingPlayerContribution;
        callAmount = Math.Max(0, callAmount);

        var minRaiseAmount = Math.Max(2 * callAmount, (await gameRepository.GetGameTableAsync(gameId)).BigBlind);

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
                Cards = showAllCards || p.UserId == userId
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

    private async Task SetInitialDealerAndBlindsAsync(int gameId, List<GamePlayer> activePlayers)
    {
        var dealerIndex = random.Next(activePlayers.Count);
        var dealer = activePlayers[dealerIndex];
        await gamePlayerRepository.SetDealerPositionAsync(gameId, dealer.GamePlayerId);

        var sbIndex = (dealerIndex + 1) % activePlayers.Count;
        var bbIndex = (dealerIndex + 2) % activePlayers.Count;

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
            var sbAmount = Math.Min(table.SmallBlind, sbPlayer.CurrentChips);
            if (sbAmount > 0)
                await moveRepository.RecordMoveAsync(gameId, currentRound.GameRoundId, sbPlayer.UserId, "Blind",
                    sbAmount, "PreFlop");
        }

        var bbPlayer = activePlayers.FirstOrDefault(p => p.IsBigBlind);
        if (bbPlayer != null)
        {
            var bbAmount = Math.Min(table.BigBlind, bbPlayer.CurrentChips);
            if (bbAmount > 0)
                await moveRepository.RecordMoveAsync(gameId, currentRound.GameRoundId, bbPlayer.UserId, "Blind",
                    bbAmount, "PreFlop");
        }

        await gameRepository.SaveChangesAsync();
    }

    private async Task DealInitialCardsAsync(int gameId)
    {
        var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
        var activePlayers = players.Where(p => p.IsActive && p.CurrentChips > 0).ToList();
        if (!activePlayers.Any()) return;

        var allCards = await cardRepository.GetAllCardsAsync();
        var shuffledCards = ShuffleCards(allCards.ToList());
        var cardIndex = 0;

        for (var i = 0; i < 2; i++)
            foreach (var player in activePlayers)
                if (cardIndex < shuffledCards.Count)
                {
                    await cardRepository.DealPlayerCardAsync(player.GamePlayerId, shuffledCards[cardIndex].CardId,
                        i + 1);
                    cardIndex++;
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
                    var bbIndex = activePlayers.IndexOf(bbPlayer);
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
                    var dealerIndex = activePlayers.IndexOf(dealer);
                    for (var i = 1; i <= activePlayers.Count; i++)
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

        if (firstToAct == null && activePlayers.Any()) firstToAct = activePlayers.First();


        if (firstToAct != null)
            await gameRepository.SetCurrentTurnAsync(gameId, firstToAct.UserId);
        else
            await gameRepository.SetCurrentTurnAsync(gameId, null);
    }

    private async Task SetNextPlayerTurnAsync(int gameId)
    {
        var game = await gameRepository.GetByIdAsync(gameId);
        if (game == null) return;

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
            await gameRepository.SetCurrentTurnAsync(gameId, null);
            return;
        }

        var currentPlayer = game.CurrentTurnPlayerId.HasValue
            ? players.FirstOrDefault(p => p.GamePlayerId == game.CurrentTurnPlayerId.Value)
            : null;

        if (currentPlayer == null)
        {
            await gameRepository.SetCurrentTurnAsync(gameId, activePlayersWithChips.First().UserId);
            return;
        }

        var currentPlayerIndex = activePlayersWithChips.FindIndex(p => p.UserId == currentPlayer.UserId);

        if (currentPlayerIndex == -1)
        {
            await gameRepository.SetCurrentTurnAsync(gameId, activePlayersWithChips.First().UserId);
            return;
        }

        var nextPlayerIndex = (currentPlayerIndex + 1) % activePlayersWithChips.Count;
        var nextPlayer = activePlayersWithChips[nextPlayerIndex];

        await gameRepository.SetCurrentTurnAsync(gameId, nextPlayer.UserId);
    }


    private async Task<bool> CheckRoundCompleteAsync(int gameId)
    {
        var game = await gameRepository.GetByIdAsync(gameId);
        if (game == null) return false;

        var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
        var activePlayers = players.Where(p => p.IsActive).ToList();
        var activePlayersWithChips = activePlayers.Where(p => p.CurrentChips > 0).ToList();

        if (activePlayersWithChips.Count == 0) return true;

        if (activePlayersWithChips.Count == 1) return true;

        var currentRound = await gameRoundRepository.GetCurrentRoundAsync(gameId);
        var playerContributions =
            await moveRepository.GetPlayerContributionsForRoundAsync(gameId, currentRound.GameRoundId,
                currentRound.CurrentState);
        var movesThisRound =
            await moveRepository.GetMovesByGameRoundAsync(gameId, currentRound.GameRoundId,
                currentRound.CurrentState);

        var highestContribution = playerContributions.Any() ? playerContributions.Values.Max() : 0;

        var lastAggressiveAction = movesThisRound
            .Where(m => m.ActionType == "Bet" || m.ActionType == "Raise")
            .OrderByDescending(m => m.MoveTime)
            .FirstOrDefault();

        if (currentRound.CurrentState == "PreFlop")
        {
            var bbPlayer = activePlayersWithChips.FirstOrDefault(p => p.IsBigBlind);
            var table = await gameRepository.GetGameTableAsync(gameId);

            if (highestContribution == table.BigBlind && bbPlayer != null)
            {
                var bbActionsAfterBlinds = movesThisRound
                    .Where(m => m.PlayerId == bbPlayer.UserId && m.ActionType != "Blind")
                    .Any();

                if (!bbActionsAfterBlinds) return false;
            }
        }

        if (lastAggressiveAction != null)
            foreach (var player in activePlayersWithChips)
            {
                var contribution = playerContributions.GetValueOrDefault(player.UserId, 0);

                if (contribution < highestContribution && player.CurrentChips > 0) return false;

                if (player.UserId != lastAggressiveAction.PlayerId)
                {
                    var actedAfterAggression = movesThisRound
                        .Any(m => m.PlayerId == player.UserId &&
                                  m.MoveTime > lastAggressiveAction.MoveTime &&
                                  m.ActionType != "Blind");

                    if (!actedAfterAggression) return false;
                }
            }
        else
            foreach (var player in activePlayersWithChips)
            {
                var playerActed = movesThisRound
                    .Any(m => m.PlayerId == player.UserId && m.ActionType != "Blind");

                if (!playerActed) return false;
            }

        return true;
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

        var nextState = "";
        var requireNextRoundActions = true;

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
            await AdvanceGameStateAsync(gameId);
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

        var currentCommunityCardCount = communityCards.Count();
        for (var i = 0; i < count && i < shuffledAvailableCards.Count; i++)
            await cardRepository.DealCommunityCardAsync(gameId, shuffledAvailableCards[i].CardId,
                currentCommunityCardCount + i + 1);
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
            var totalPot = await gameRepository.GetPotSizeAsync(gameId);
            await gameRoundWinnerRepository.AddWinnerAsync(gameRound.GameRoundId, activePlayers.Single().UserId,
                totalPot);
        }
        else
        {
            if (gameRound.CurrentState != "Showdown") await gameRepository.UpdateGameStateAsync(gameId, "Showdown");

            var sidePots = await CalculateSidePotsAsync(gameId, gameRound.GameRoundId);

            var communityCards = await cardRepository.GetCommunityCardsByGameIdAsync(gameId);

            foreach (var sidePot in sidePots)
            {
                var eligiblePlayers = activePlayers.Where(p => sidePot.EligiblePlayers.Contains(p.UserId)).ToList();

                if (eligiblePlayers.Count == 1)
                {
                    await gameRoundWinnerRepository.AddWinnerAsync(gameRound.GameRoundId,
                        eligiblePlayers.First().UserId, sidePot.Amount);
                }
                else
                {
                    var playerHandRanks = new List<Tuple<int, int>>();

                    foreach (var player in eligiblePlayers)
                    {
                        var playerCards = await cardRepository.GetPlayerCardsByGamePlayerIdAsync(player.GamePlayerId);
                        var allCards = communityCards.Concat(playerCards).ToList();

                        var handRank = PokerHandEvaluator.EvaluateHand(allCards);
                        playerHandRanks.Add(Tuple.Create(player.UserId, handRank));
                    }

                    playerHandRanks.Sort((p1, p2) => p2.Item2.CompareTo(p1.Item2));

                    var bestRank = playerHandRanks.First().Item2;
                    var potWinners = playerHandRanks.Where(p => p.Item2 == bestRank).Select(p => p.Item1).ToList();

                    if (potWinners.Count == 1)
                    {
                        await gameRoundWinnerRepository.AddWinnerAsync(gameRound.GameRoundId,
                            potWinners.First(), sidePot.Amount);
                    }
                    else
                    {
                        var potPerWinner = sidePot.Amount / potWinners.Count;
                        var remainder = sidePot.Amount % potWinners.Count;
                        var winnerAmounts = potWinners.ToDictionary(id => id, id => potPerWinner);

                        if (remainder > 0)
                        {
                            var dealer = players.FirstOrDefault(p => p.IsDealer);
                            var dealerPos = dealer?.SeatPosition ?? 0;

                            var orderedWinners = potWinners
                                .Select(id => players.First(p => p.UserId == id))
                                .OrderBy(p => (p.SeatPosition - dealerPos + players.Count()) % players.Count())
                                .ToList();

                            for (var i = 0; i < remainder; i++) winnerAmounts[orderedWinners[i].UserId]++;
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

    private async Task<List<SidePot>> CalculateSidePotsAsync(int gameId, int gameRoundId)
    {
        var sidePots = new List<SidePot>();
        var allMoves = await moveRepository.GetMovesByGameRoundIdAsync(gameRoundId);

        var playerContributions = allMoves
            .Where(m => m.ActionType == "Bet" || m.ActionType == "Call" ||
                        m.ActionType == "Raise" || m.ActionType == "AllIn" ||
                        m.ActionType == "Blind")
            .GroupBy(m => m.PlayerId)
            .Select(g => new { PlayerId = g.Key, TotalContribution = g.Sum(m => m.Amount) })
            .OrderBy(p => p.TotalContribution)
            .ToList();

        var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
        var remainingContributions = playerContributions.ToDictionary(p => p.PlayerId, p => p.TotalContribution);

        foreach (var contribution in playerContributions)
        {
            if (contribution.TotalContribution == 0) continue;

            var eligiblePlayers = remainingContributions.Keys.ToList();
            var potAmount = 0;

            foreach (var playerId in eligiblePlayers)
            {
                var playerContribution = Math.Min(remainingContributions[playerId], contribution.TotalContribution);
                potAmount += playerContribution;
                remainingContributions[playerId] -= playerContribution;
            }

            if (potAmount > 0)
                sidePots.Add(new SidePot
                {
                    Amount = potAmount,
                    EligiblePlayers = eligiblePlayers
                });

            remainingContributions = remainingContributions
                .Where(kvp => kvp.Value > 0)
                .ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
        }

        return sidePots;
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
            await gamePlayerRepository.SetPlayerStatusAsync(player.GamePlayerId, true);

        foreach (var player in players.Where(p => p.CurrentChips <= 0))
            await gamePlayerRepository.SetPlayerStatusAsync(player.GamePlayerId, false);

        await RotateDealerAndSetBlindsAsync(gameId);
        await gameRepository.UpdatePotSizeAsync(gameId, 0);
        var newRound = await gameRoundRepository.StartNewRoundAsync(gameId);

        await DealInitialCardsAsync(gameId);
        await gameRepository.UpdateGameStateAsync(gameId, "PreFlop");

        var currentPlayers = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);
        await CollectBlindsAsync(gameId, currentPlayers.Where(p => p.IsActive).ToList());
        await SetFirstPlayerToActAsync(gameId, "PreFlop");

        return true;
    }

    private async Task RotateDealerAndSetBlindsAsync(int gameId)
    {
        var players = await gamePlayerRepository.GetPlayersByGameIdAsync(gameId);

        var activePlayersWithChips = players.Where(p => p.CurrentChips > 0).OrderBy(p => p.SeatPosition).ToList();

        if (activePlayersWithChips.Count < 2) return;

        var currentDealer = activePlayersWithChips.FirstOrDefault(p => p.IsDealer);
        var currentDealerIndex = currentDealer != null ? activePlayersWithChips.IndexOf(currentDealer) : -1;

        GamePlayer nextDealer = null;
        if (currentDealerIndex != -1)
            for (var i = 1; i <= activePlayersWithChips.Count; i++)
            {
                var potentialDealer =
                    activePlayersWithChips[(currentDealerIndex + i) % activePlayersWithChips.Count];
                if (potentialDealer.CurrentChips > 0)
                {
                    nextDealer = potentialDealer;
                    break;
                }
            }

        if (nextDealer == null) nextDealer = activePlayersWithChips.First();


        await gamePlayerRepository.SetDealerPositionAsync(gameId, nextDealer.GamePlayerId);

        var newDealerIndex = activePlayersWithChips.IndexOf(nextDealer);
        GamePlayer sbPlayer = null;
        GamePlayer bbPlayer = null;

        if (activePlayersWithChips.Count == 2)
        {
            sbPlayer = nextDealer;
            bbPlayer = activePlayersWithChips[(newDealerIndex + 1) % activePlayersWithChips.Count];
        }
        else
        {
            for (var i = 1; i <= activePlayersWithChips.Count; i++)
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
                var sbIndex = activePlayersWithChips.IndexOf(sbPlayer);
                for (var i = 1; i <= activePlayersWithChips.Count; i++)
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
            // Handle error - maybe assign to first two players? Log warning?
            // For now, proceed with potentially null blinds if logic failed.
            await gamePlayerRepository.SetBlindPositionsAsync(gameId, sbPlayer?.GamePlayerId ?? 0,
                bbPlayer?.GamePlayerId ?? 0);
        else
            await gamePlayerRepository.SetBlindPositionsAsync(gameId, sbPlayer.GamePlayerId, bbPlayer.GamePlayerId);
    }

    private List<Card> ShuffleCards(List<Card> cards)
    {
        var n = cards.Count;
        while (n > 1)
        {
            n--;
            var k = random.Next(n + 1);
            var value = cards[k];
            cards[k] = cards[n];
            cards[n] = value;
        }

        return cards;
    }

    public class SidePot
    {
        public int Amount { get; set; }
        public List<int> EligiblePlayers { get; set; }
    }
}