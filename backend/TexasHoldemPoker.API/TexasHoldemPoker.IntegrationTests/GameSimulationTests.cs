using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Testing;
using TexasHoldemPoker.API;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Models;
using Xunit;
using Xunit.Abstractions;

namespace TexasHoldemPoker.IntegrationTests
{
    public class GameSimulationTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly HttpClient _client;
        private readonly ITestOutputHelper _output;
        private readonly Random _random = new Random();

        // Configurable test parameters
        private readonly TestConfiguration _config;

        public GameSimulationTests(WebApplicationFactory<Program> factory, ITestOutputHelper output)
        {
            _output = output;
            _client = factory.CreateClient();

            // Default configuration - can be overridden in specific tests
            _config = new TestConfiguration
            {
                NumberOfPlayers = 3,
                TableToJoin = 1,
                DefaultBuyIn = 1000,
                EnableRandomActions = true,
                LogDetailedGameState = true
            };
        }

        [Fact]
        public async Task RunFullGameSimulation_WithDynamicPlayerActions()
        {
            _output.WriteLine($"Starting Poker Game Simulation with {_config.NumberOfPlayers} players");

            try
            {
                // Setup players
                var players = await SetupPlayers(_config.NumberOfPlayers);
                Assert.True(players.Count >= 2, "Failed to set up enough players.");
                _output.WriteLine($"Players registered: {string.Join(", ", players.Select(p => p.Username))}");

                // Create game
                int? gameId = await CreateGame(players[0].Token, _config.TableToJoin);
                Assert.True(gameId.HasValue, "Failed to create game.");
                _output.WriteLine($"Game created with ID: {gameId.Value}");

                // Join game
                bool joined = await JoinAllPlayers(gameId.Value, players);
                Assert.True(joined, "Not all players joined successfully.");

                // Start game
                bool started = await StartGame(gameId.Value, players[0].Token);
                Assert.True(started, $"Failed to start game {gameId.Value}.");
                _output.WriteLine($"Game {gameId.Value} started!");

                // Run game with dynamic player actions
                await RunGameWithDynamicActions(gameId.Value, players);

                // Verify game completion and winner
                var finalState = await GetGameStateAsync(gameId.Value, players[0].Token);
                Assert.NotNull(finalState);

                if (finalState.CurrentState == "Completed" && finalState.WinnerId.HasValue)
                {
                    var winner = players.FirstOrDefault(p => p.UserId == finalState.WinnerId.Value);
                    _output.WriteLine(
                        $"\nGame completed! Winner: {winner?.Username ?? "Unknown"} (ID: {finalState.WinnerId.Value})");
                    _output.WriteLine($"Final pot: {finalState.PotSize}");
                }
                else
                {
                    _output.WriteLine("\nGame ended but no winner was determined.");
                }
            }
            catch (Exception ex)
            {
                _output.WriteLine($"Error during test: {ex.GetType().Name} - {ex.Message}");
                _output.WriteLine(ex.StackTrace);
                throw;
            }
        }

        private async Task RunGameWithDynamicActions(int gameId, List<UserDto> players)
        {
            int turnCount = 0;
            const int maxTurns = 100; // Safety limit
            var playerTokens = players.ToDictionary(p => p.UserId, p => p.Token);

            while (turnCount < maxTurns)
            {
                turnCount++;
                _output.WriteLine($"\n--- Turn {turnCount} ---");

                var gameState = await GetGameStateAsync(gameId, players[0].Token);
                Assert.NotNull(gameState);

                if (_config.LogDetailedGameState)
                {
                    LogGameState(gameState);
                }

                // Check for game completion
                if (gameState.CurrentState == "Completed" || gameState.WinnerId.HasValue)
                {
                    await VerifyShowdownCards(gameId, players);
                    break;
                }

                // Ensure there's a current player
                Assert.True(gameState.CurrentTurnUserId.HasValue,
                    $"No current turn user on turn {turnCount}. State: {gameState.CurrentState}");

                int currentPlayerId = gameState.CurrentTurnUserId.Value;
                var playerToAct = players.FirstOrDefault(p => p.UserId == currentPlayerId);
                Assert.NotNull(playerToAct);

                // Get player state and calculate possible actions
                var playerState = gameState.Players?.FirstOrDefault(p => p.UserId == currentPlayerId);
                Assert.NotNull(playerState);

                // Calculate pot contributions to determine valid actions
                var contributions = CalculateContributions(gameState);
                int highestContribution = contributions.Any() ? contributions.Values.Max() : 0;
                int currentContribution = contributions.GetValueOrDefault(currentPlayerId, 0);
                int amountToCall = highestContribution - currentContribution;

                // Determine valid actions
                var validActions = DetermineValidActions(
                    amountToCall,
                    playerState.ChipCount,
                    gameState.CurrentState);

                // Choose an action based on configuration
                var chosenAction = _config.EnableRandomActions
                    ? ChooseRandomAction(validActions, playerState.ChipCount, amountToCall)
                    : ChooseDefaultAction(validActions, amountToCall);

                _output.WriteLine(
                    $"Player {playerToAct.Username} performs {chosenAction.ActionType} ({chosenAction.Amount})");

                // Make the move
                bool moveMade = await MakeMoveAsync(gameId, playerTokens[currentPlayerId], chosenAction);
                Assert.True(moveMade,
                    $"API rejected a calculated valid move ({chosenAction.ActionType} {chosenAction.Amount})");

                await Task.Delay(100); // Small delay between actions
            }

            Assert.True(turnCount < maxTurns, "Reached maximum simulation turns. Game might be stuck.");
        }

        private List<MakeMoveDto> DetermineValidActions(int amountToCall, int chipCount, string gameState)
        {
            var actions = new List<MakeMoveDto>();

            // Fold is always an option
            actions.Add(new MakeMoveDto { ActionType = "Fold", Amount = 0 });

            // Check if player can check
            if (amountToCall == 0)
            {
                actions.Add(new MakeMoveDto { ActionType = "Check", Amount = 0 });
            }

            // Call if there's something to call and player has enough chips
            if (amountToCall > 0 && chipCount >= amountToCall)
            {
                actions.Add(new MakeMoveDto { ActionType = "Call", Amount = amountToCall });
            }

            // Bet/Raise options if player has enough chips
            if (chipCount > amountToCall)
            {
                // Min bet/raise is typically the big blind or the previous bet doubled
                int minRaise = Math.Max(20, amountToCall * 2); // Using 20 as a default big blind

                if (chipCount >= minRaise)
                {
                    actions.Add(new MakeMoveDto { ActionType = amountToCall > 0 ? "Raise" : "Bet", Amount = minRaise });

                    // Add some larger raise options
                    if (chipCount >= minRaise * 2)
                    {
                        actions.Add(new MakeMoveDto
                        {
                            ActionType = amountToCall > 0 ? "Raise" : "Bet",
                            Amount = Math.Min(chipCount, minRaise * 2)
                        });
                    }
                }
            }

            // All-in is always an option if player has chips
            if (chipCount > 0)
            {
                actions.Add(new MakeMoveDto { ActionType = "AllIn", Amount = chipCount });
            }

            return actions;
        }

        private MakeMoveDto ChooseRandomAction(List<MakeMoveDto> validActions, int chipCount, int amountToCall)
        {
            // Weight actions to make the game more interesting
            // More likely to call/check than fold, and occasionally raise/bet
            var weightedActions = new List<(MakeMoveDto action, int weight)>();

            foreach (var action in validActions)
            {
                int weight = action.ActionType switch
                {
                    "Fold" => 10, // Least likely
                    "Check" => 50, // Very likely if available
                    "Call" => 40, // Likely if available
                    "Bet" => 20, // Occasional
                    "Raise" => 20, // Occasional
                    "AllIn" => 5, // Rare but possible
                    _ => 1
                };

                // Adjust weights based on game situation
                if (action.ActionType == "Call" && amountToCall > chipCount / 2)
                {
                    weight /= 2; // Less likely to call large bets
                }

                weightedActions.Add((action, weight));
            }

            // Select action based on weights
            int totalWeight = weightedActions.Sum(w => w.weight);
            int randomValue = _random.Next(totalWeight);

            int cumulativeWeight = 0;
            foreach (var (action, weight) in weightedActions)
            {
                cumulativeWeight += weight;
                if (randomValue < cumulativeWeight)
                {
                    return action;
                }
            }

            // Fallback to first action (should never happen)
            return validActions.First();
        }

        private MakeMoveDto ChooseDefaultAction(List<MakeMoveDto> validActions, int amountToCall)
        {
            // Simple strategy: Check if possible, otherwise call, fold as last resort
            var checkAction = validActions.FirstOrDefault(a => a.ActionType == "Check");
            if (checkAction != null) return checkAction;

            var callAction = validActions.FirstOrDefault(a => a.ActionType == "Call");
            if (callAction != null) return callAction;

            // If can't check or call, fold
            return validActions.First(a => a.ActionType == "Fold");
        }

        private Dictionary<int, int> CalculateContributions(GameStateDto gameState)
        {
            var contributions = new Dictionary<int, int>();
            var activePlayers = gameState.Players?.Where(p => p.IsActive).ToList() ?? new List<PlayerStateDto>();

            foreach (var player in activePlayers)
            {
                contributions[player.UserId] = 0;
            }

            var roundMoves = gameState.LastMoves?
                .Where(m => m.Round == gameState.CurrentState)
                .ToList() ?? new List<MoveDto>();

            foreach (var move in roundMoves)
            {
                if (contributions.ContainsKey(move.PlayerId) &&
                    (move.ActionType == "Bet" || move.ActionType == "Call" ||
                     move.ActionType == "Raise" || move.ActionType == "AllIn"))
                {
                    contributions[move.PlayerId] += move.Amount;
                }
            }

            return contributions;
        }

        private async Task<List<UserDto>> SetupPlayers(int count)
        {
            var players = new List<UserDto>();
            for (int i = 1; i <= count; i++)
            {
                string username = $"TestPlayer{DateTime.UtcNow.Ticks}_{i}";
                string email = $"{username}@test.com";
                string password = "Password123!";

                var registerDto = new RegisterDto { Username = username, Email = email, Password = password };
                var registeredUser = await RegisterUserAsync(registerDto);

                if (registeredUser != null)
                {
                    var loginDto = new LoginDto { Username = username, Password = password };
                    var loggedInUser = await LoginUserAsync(loginDto);
                    if (loggedInUser != null && !string.IsNullOrEmpty(loggedInUser.Token))
                    {
                        players.Add(loggedInUser);
                    }
                }
            }

            return players;
        }

        private void LogGameState(GameStateDto state)
        {
            _output.WriteLine($"State: {state.CurrentState}, Pot: {state.PotSize}");

            if (state.CommunityCards != null && state.CommunityCards.Any())
            {
                _output.WriteLine(
                    $"Community Cards: {string.Join(" ", state.CommunityCards.Select(c => $"{c.Value}{c.Suit.First()}"))}");
            }
            else
            {
                _output.WriteLine("Community Cards: None");
            }

            _output.WriteLine("Players:");
            if (state.Players != null)
            {
                foreach (var p in state.Players.OrderBy(pl => pl.SeatPosition))
                {
                    string markers = string.Join("", new[]
                    {
                        p.IsDealer ? " (D)" : "",
                        p.IsSmallBlind ? " (SB)" : "",
                        p.IsBigBlind ? " (BB)" : "",
                        !p.IsActive ? " (Folded)" : "",
                        state.CurrentTurnUserId == p.UserId ? " <<< TURN" : ""
                    });

                    _output.WriteLine(
                        $"  Seat {p.SeatPosition}: {p.Username} (ID: {p.UserId}), Chips: {p.ChipCount}{markers}");
                }
            }
        }

        // API interaction methods
        private async Task<UserDto> RegisterUserAsync(RegisterDto dto)
        {
            try
            {
                HttpResponseMessage response = await _client.PostAsJsonAsync("/api/users/register", dto);
                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadFromJsonAsync<UserDto>();
                }

                _output.WriteLine(
                    $"Register failed: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                return null;
            }
            catch (Exception ex)
            {
                _output.WriteLine($"Exception during Register: {ex.Message}");
                return null;
            }
        }

        private async Task<UserDto> LoginUserAsync(LoginDto dto)
        {
            try
            {
                HttpResponseMessage response = await _client.PostAsJsonAsync("/api/users/login", dto);
                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadFromJsonAsync<UserDto>();
                }

                _output.WriteLine(
                    $"Login failed for {dto.Username}: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                return null;
            }
            catch (Exception ex)
            {
                _output.WriteLine($"Exception during Login: {ex.Message}");
                return null;
            }
        }

        private async Task<int?> CreateGame(string token, int tableId)
        {
            try
            {
                _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
                var dto = new CreateGameDto { TableId = tableId };
                HttpResponseMessage response = await _client.PostAsJsonAsync("/api/games", dto);
                _client.DefaultRequestHeaders.Authorization = null;

                if (response.IsSuccessStatusCode)
                {
                    var game = await response.Content.ReadFromJsonAsync<Game>();
                    return game?.GameId;
                }

                _output.WriteLine(
                    $"CreateGame failed: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                return null;
            }
            catch (Exception ex)
            {
                _output.WriteLine($"Exception during CreateGame: {ex.Message}");
                _client.DefaultRequestHeaders.Authorization = null;
                return null;
            }
        }

        private async Task<bool> JoinAllPlayers(int gameId, List<UserDto> players)
        {
            int seat = 1;
            foreach (var player in players)
            {
                if (!await JoinGame(gameId, player.Token, seat, _config.DefaultBuyIn))
                {
                    return false;
                }

                seat++;
            }

            return true;
        }

        private async Task<bool> JoinGame(int gameId, string token, int seatPosition, int buyInAmount)
        {
            try
            {
                _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
                var dto = new JoinGameDto { SeatPosition = seatPosition, BuyInAmount = buyInAmount };
                HttpResponseMessage response = await _client.PostAsJsonAsync($"/api/games/{gameId}/join", dto);
                _client.DefaultRequestHeaders.Authorization = null;

                if (!response.IsSuccessStatusCode)
                {
                    _output.WriteLine(
                        $"JoinGame failed for seat {seatPosition}: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                }

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _output.WriteLine($"Exception during JoinGame: {ex.Message}");
                _client.DefaultRequestHeaders.Authorization = null;
                return false;
            }
        }

        private async Task<bool> StartGame(int gameId, string token)
        {
            try
            {
                _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
                HttpResponseMessage response = await _client.PostAsync($"/api/games/{gameId}/start", null);
                _client.DefaultRequestHeaders.Authorization = null;

                if (!response.IsSuccessStatusCode)
                {
                    _output.WriteLine(
                        $"StartGame failed: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                }

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _output.WriteLine($"Exception during StartGame: {ex.Message}");
                _client.DefaultRequestHeaders.Authorization = null;
                return false;
            }
        }

        private async Task<GameStateDto> GetGameStateAsync(int gameId, string token)
        {
            try
            {
                _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
                HttpResponseMessage response = await _client.GetAsync($"/api/games/{gameId}");
                _client.DefaultRequestHeaders.Authorization = null;

                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadFromJsonAsync<GameStateDto>();
                }

                _output.WriteLine(
                    $"GetGameState failed: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                return null;
            }
            catch (Exception ex)
            {
                _output.WriteLine($"Exception during GetGameState: {ex.Message}");
                _client.DefaultRequestHeaders.Authorization = null;
                return null;
            }
        }

        private async Task<bool> MakeMoveAsync(int gameId, string token, MakeMoveDto dto)
        {
            try
            {
                _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
                HttpResponseMessage response = await _client.PostAsJsonAsync($"/api/games/{gameId}/move", dto);
                _client.DefaultRequestHeaders.Authorization = null;

                if (!response.IsSuccessStatusCode)
                {
                    _output.WriteLine(
                        $"MakeMove failed ({dto.ActionType} {dto.Amount}): {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                }

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _output.WriteLine($"Exception during MakeMove: {ex.Message}");
                _client.DefaultRequestHeaders.Authorization = null;
                return false;
            }
        }

        private async Task VerifyShowdownCards(int gameId, List<UserDto> players)
        {
            _output.WriteLine("\n--- Verifying Showdown Cards ---");

            // Get the final game state using the first player's token
            var finalState = await GetGameStateAsync(gameId, players[0].Token);
            Assert.NotNull(finalState);

            // Check if game is completed
            Assert.Equal("Completed", finalState.CurrentState);
            Assert.True(finalState.WinnerId.HasValue, "No winner was determined for the completed game");

            // Find the winner
            var winner = players.FirstOrDefault(p => p.UserId == finalState.WinnerId.Value);
            Assert.NotNull(winner);
            _output.WriteLine($"Game winner: {winner.Username} (ID: {finalState.WinnerId.Value})");

            // Verify all active players have their cards visible
            int visibleCardSets = 0;
            foreach (var player in finalState.Players.Where(p => p.IsActive))
            {
                Assert.NotNull(player.Cards);
                if (player.Cards.Count > 0)
                {
                    visibleCardSets++;
                    _output.WriteLine($"Player {player.Username} cards: {string.Join(", ", player.Cards.Select(c => $"{c.Value}{c.Suit.First()}"))}");
                }
                else
                {
                    _output.WriteLine($"WARNING: Active player {player.Username} has no visible cards at showdown");
                }
            }

            // There should be at least one player with visible cards (the winner)
            Assert.True(visibleCardSets > 0, "No players have visible cards at showdown");

            // Log the community cards for context
            _output.WriteLine($"Community cards: {string.Join(", ", finalState.CommunityCards.Select(c => $"{c.Value}{c.Suit.First()}"))}");
        }

    }

    // Configuration class for test parameters
    public class TestConfiguration
    {
        public int NumberOfPlayers { get; set; }
        public int TableToJoin { get; set; }
        public int DefaultBuyIn { get; set; }
        public bool EnableRandomActions { get; set; }
        public bool LogDetailedGameState { get; set; }
    }
}