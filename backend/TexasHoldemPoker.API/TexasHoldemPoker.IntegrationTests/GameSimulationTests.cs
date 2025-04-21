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
    public class
        GameSimulationTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly HttpClient _client;
        private readonly ITestOutputHelper _output;
        private readonly Random _random = new Random();

        // --- Configuration ---
        // Use constants as before, or pull from config if needed
        private const int NumberOfPlayers = 3;
        private const int TableToJoin = 1; // Assumes TableId 1 exists from seed data
        private const int DefaultBuyIn = 1000;
        private const int SimpleCallAmount = 20; // Simple amount to call/bet (adjust based on Big Blind of Table 1)

        public GameSimulationTests(WebApplicationFactory<Program> factory, ITestOutputHelper output)
        {
            _output = output;
            _client = factory.CreateClient();
            _output.WriteLine($"HttpClient configured for base address: {_client.BaseAddress}");
        }

        [Fact]
        public async Task RunFullGameSimulation_WithValidatedMoves() // Updated test name slightly
        {
            _output.WriteLine($"Starting Poker Game Simulation (Integration Test with Move Validation)");
            _output.WriteLine($"Simulating with {NumberOfPlayers} players.");
            _output.WriteLine("============================================\n");

            try
            {
                // 1. Setup Players (Same as before)
                var players = await SetupPlayers(NumberOfPlayers);
                Assert.True(players.Count >= 2, "Failed to set up enough players.");
                _output.WriteLine($"\n--- {players.Count} Players Registered & Logged In ---");
                players.ForEach(p => _output.WriteLine($" > User: {p.Username} (ID: {p.UserId}), Token acquired."));

                // 2. Create Game (Same as before)
                _output.WriteLine("\n--- Creating Game ---");
                int? gameId = await CreateGame(players[0].Token, TableToJoin);
                Assert.True(gameId.HasValue, "Failed to create game.");
                _output.WriteLine($"Game created with ID: {gameId.Value} on Table {TableToJoin}");

                // 3. Join Game (Same as before)
                _output.WriteLine("\n--- Players Joining Game ---");
                bool joined = await JoinAllPlayers(gameId.Value, players);
                Assert.True(joined, "Not all players joined successfully.");
                _output.WriteLine("All players joined successfully.");

                // 4. Start Game (Same as before)
                _output.WriteLine("\n--- Starting Game ---");
                bool started = await StartGame(gameId.Value, players[0].Token);
                Assert.True(started, $"Failed to start game {gameId.Value}.");
                _output.WriteLine($"Game {gameId.Value} started!");
                _output.WriteLine("\n============================================");
                _output.WriteLine("         Starting Game Simulation");
                _output.WriteLine("============================================\n");


                // 5. Game Loop (*** REWRITTEN LOGIC ***)
                await RunGameLoopWithValidation(gameId.Value, players);


                _output.WriteLine("\n============================================");
                _output.WriteLine("          Simulation Finished Successfully");
                _output.WriteLine("============================================");
            }
            catch (HttpRequestException httpEx) // Catches network/request level errors
            {
                _output.WriteLine($"!!! HTTP Request Exception: {httpEx.Message}");
                if (httpEx.InnerException != null)
                    _output.WriteLine($"    Inner Exception: {httpEx.InnerException.Message}");
                // Optionally log httpEx.StatusCode if available in specific .NET versions/scenarios
                // if (httpEx.StatusCode.HasValue)
                //    _output.WriteLine($"    Status Code: {httpEx.StatusCode}");
                Assert.Fail($"HttpRequestException occurred: {httpEx.Message}");
            }
            catch (Exception ex) // Catches other unexpected errors
            {
                _output.WriteLine($"!!! An unexpected error occurred: {ex.GetType().Name} - {ex.Message}");
                _output.WriteLine(ex.StackTrace);
                Assert.Fail($"An unexpected error occurred: {ex.Message}");
            }
        }

        private async Task RunGameLoopWithValidation(int gameId, List<UserDto> players)
        {
            int turnCount = 0;
            const int maxTurns = 100;
            var currentPlayerTokens = players.ToDictionary(p => p.UserId, p => p.Token); // Store tokens for easy lookup

            while (turnCount < maxTurns)
            {
                turnCount++;
                _output.WriteLine($"\n--- Turn {turnCount} ---");

                var gameState = await GetGameStateAsync(gameId, players[0].Token);
                Assert.NotNull(gameState); // Test fails if state cannot be retrieved

                LogGameState(gameState);

                if (gameState.CurrentState == "Completed" || gameState.WinnerId.HasValue)
                    break; // Exit loop if game over

                Assert.True(gameState.CurrentTurnUserId.HasValue,
                    $"Game state shows no current turn user on turn {turnCount}. State: {gameState.CurrentState}");
                int currentTurnPlayerId = gameState.CurrentTurnUserId!.Value;
                var playerToAct = players.FirstOrDefault(p => p.UserId == currentTurnPlayerId);
                Assert.NotNull(playerToAct); // Player must be in our list

                _output.WriteLine($" > Turn: {playerToAct!.Username} (ID: {currentTurnPlayerId})");

                var playerState = gameState.Players?.FirstOrDefault(p => p.UserId == currentTurnPlayerId);
                Assert.NotNull(playerState); // Player must be in game state players list

                // Calculate contributions and amount to call
                var playerContributions = CalculateContributions(gameState);
                int highestContributionInRound = playerContributions.Any() ? playerContributions.Values.Max() : 0;
                int currentPlayerContribution = playerContributions.GetValueOrDefault(currentTurnPlayerId, 0);
                int amountToCall = highestContributionInRound - currentPlayerContribution;

                _output.WriteLine($"   Highest contribution this round: {highestContributionInRound}");
                _output.WriteLine($"   {playerToAct.Username}'s contribution: {currentPlayerContribution}");
                _output.WriteLine($"   Amount to call: {amountToCall}");

                // Decide Action
                string actionType;
                int amount;
                bool canCheck = (amountToCall <= 0);

                if (canCheck)
                {
                    actionType = "Check";
                    amount = 0;
                    _output.WriteLine($"   Decision: Check");
                }
                else
                {
                    if (playerState!.ChipCount > amountToCall)
                    {
                        actionType = "Call";
                        amount = amountToCall;
                        _output.WriteLine($"   Decision: Call {amount}");
                    }
                    else
                    {
                        actionType = "AllIn";
                        amount = playerState.ChipCount;
                        _output.WriteLine($"   Decision: AllIn with {amount}");
                    }
                }

                // Make the Move
                var moveDto = new MakeMoveDto { ActionType = actionType, Amount = amount };
                _output.WriteLine($"   Action Attempt: {playerToAct.Username} performs {actionType} ({amount})");

                string playerToken = currentPlayerTokens[currentTurnPlayerId];
                bool moveMade = await MakeMoveAsync(gameId, playerToken, moveDto);

                // If move failed, the Assert inside MakeMoveAsync will have logged details
                Assert.True(moveMade,
                    $"API rejected a calculated valid move ({actionType} {amount} by {playerToAct.Username}) on turn {turnCount}. See previous logs for API response.");

                await Task.Delay(100); // Shorter delay
            }

            Assert.True(turnCount < maxTurns, "Reached maximum simulation turns. Game might be stuck.");
        }

        private Dictionary<int, int> CalculateContributions(GameStateDto gameState)
        {
            var contributions = new Dictionary<int, int>();
            var activePlayersInState = gameState.Players?.Where(p => p.IsActive).ToList() ?? new List<PlayerStateDto>();
            foreach (var p in activePlayersInState)
            {
                contributions[p.UserId] = 0;
            }

            var roundMoves = gameState.LastMoves?.Where(m => m.Round == gameState.CurrentState).ToList() ??
                             new List<MoveDto>();
            foreach (var move in roundMoves)
            {
                if (contributions.ContainsKey(move.PlayerId) && (move.ActionType == "Bet" ||
                                                                 move.ActionType == "Call" ||
                                                                 move.ActionType == "Raise" ||
                                                                 move.ActionType == "AllIn"))
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
                string username = $"SimPlayer{DateTime.UtcNow.Ticks}_{i}";
                string email = $"{username}@testsim.com";
                string password = "Password123!";

                _output.WriteLine($"Attempting to register {username}...");
                var registerDto = new RegisterDto { Username = username, Email = email, Password = password };
                var registeredUser = await RegisterUserAsync(registerDto);

                if (registeredUser != null)
                {
                    _output.WriteLine($" > {username} registered. Attempting login...");
                    var loginDto = new LoginDto { Username = username, Password = password };
                    var loggedInUser = await LoginUserAsync(loginDto);
                    if (loggedInUser != null && !string.IsNullOrEmpty(loggedInUser.Token))
                    {
                        players.Add(loggedInUser);
                        _output.WriteLine($" > {username} logged in successfully.");
                    }
                    else
                    {
                        _output.WriteLine($" !! Failed to log in {username} after registration.");
                        // Test should fail later if not enough players setup
                    }
                }
                else
                {
                    _output.WriteLine($" !! Failed to register {username}.");
                    // Optionally try login anyway if needed
                }
            }

            return players;
        }

        private async Task RunGameLoop(int gameId, List<UserDto> players)
        {
            int turnCount = 0;
            const int maxTurns = 100; // Safety break

            while (turnCount < maxTurns)
            {
                turnCount++;
                _output.WriteLine($"\n--- Turn {turnCount} ---");

                // Use Player 1's token to get general game state
                var gameState = await GetGameStateAsync(gameId, players[0].Token);
                Assert.NotNull(gameState); // Assert state is retrieved
                if (gameState == null) break;

                LogGameState(gameState); // Log using _output

                // Check for Game End
                if (gameState.CurrentState == "Completed" || gameState.WinnerId.HasValue)
                {
                    _output.WriteLine($"\n--- Game Over ---");
                    if (gameState.WinnerId.HasValue)
                    {
                        var winner = players.FirstOrDefault(p => p.UserId == gameState.WinnerId.Value);
                        _output.WriteLine($"Winner: {winner?.Username ?? "Unknown"} (ID: {gameState.WinnerId.Value})");
                    }
                    else
                    {
                        _output.WriteLine("Game completed, winner ID not set.");
                    }

                    _output.WriteLine($"Final Pot: {gameState.PotSize}");
                    break;
                }

                // Check whose turn
                Assert.True(gameState.CurrentTurnUserId.HasValue, "No current turn user ID found.");
                if (!gameState.CurrentTurnUserId.HasValue)
                {
                    await Task.Delay(1000); // Wait if needed
                    continue;
                }

                int currentTurnPlayerId = gameState.CurrentTurnUserId.Value;
                var playerToAct = players.FirstOrDefault(p => p.UserId == currentTurnPlayerId);

                Assert.NotNull(playerToAct); // Ensure player exists in our list
                if (playerToAct == null)
                {
                    _output.WriteLine($" !! Player {currentTurnPlayerId} not found. Skipping.");
                    await Task.Delay(1000);
                    continue;
                }

                _output.WriteLine($" > Turn: {playerToAct.Username} (ID: {currentTurnPlayerId})");

                // Determine Simple Action (Check or Call/Bet) - Same logic as before
                string action = "Call";
                int amount = SimpleCallAmount;
                var lastMove = gameState.LastMoves?.OrderByDescending(m => m.MoveTime).FirstOrDefault();
                bool canCheck = true;

                if (lastMove != null && lastMove.Round == gameState.CurrentState)
                {
                    if ((lastMove.ActionType == "Bet" || lastMove.ActionType == "Raise") &&
                        lastMove.PlayerId != currentTurnPlayerId)
                    {
                        canCheck = false;
                        amount = lastMove.Amount;
                    }
                }

                if (canCheck && (lastMove == null || lastMove.Round != gameState.CurrentState ||
                                 lastMove.ActionType == "Check" || lastMove.ActionType == "Call"))
                {
                    action = "Check";
                    amount = 0;
                }
                else
                {
                    action = "Call";
                    if (amount == 0 && gameState.CurrentState == "PreFlop")
                        amount = SimpleCallAmount; // Min bet preflop fallback
                }

                var playerState = gameState.Players?.FirstOrDefault(p => p.UserId == currentTurnPlayerId);
                if (playerState != null)
                {
                    if (action == "Call" && amount >= playerState.ChipCount)
                    {
                        action = "AllIn";
                        amount = playerState.ChipCount;
                    }
                    else if (action == "Call" && amount == 0 && gameState.CurrentState != "PreFlop")
                    {
                        action = "Check";
                    }
                }

                // Make the move
                // *** Use DTO from API project directly ***
                var moveDto = new MakeMoveDto { ActionType = action, Amount = amount };
                _output.WriteLine($"   Action: {playerToAct.Username} performs {action} ({amount})");
                bool moveMade = await MakeMoveAsync(gameId, playerToAct.Token, moveDto);
                Assert.True(moveMade, $"Move {action} failed for {playerToAct.Username}"); // Assert move succeeds

                if (!moveMade)
                {
                    _output.WriteLine($" !! Move failed for {playerToAct.Username}. Trying fallback Check.");
                    moveDto = new MakeMoveDto { ActionType = "Check", Amount = 0 };
                    moveMade = await MakeMoveAsync(gameId, playerToAct.Token, moveDto);
                    Assert.True(moveMade, $"Fallback Check failed for {playerToAct.Username}");
                }


                // Small delay
                await Task.Delay(500); // Shorter delay for faster tests
            }

            Assert.True(turnCount < maxTurns, "Reached maximum simulation turns.");
        }

        // --- Logging ---
        private void LogGameState(GameStateDto state)
        {
            _output.WriteLine($"  State: {state.CurrentState}, Pot: {state.PotSize}");
            _output.WriteLine($"  Community Cards: ");
            _output.WriteLine(state.CommunityCards != null && state.CommunityCards.Any()
                ? string.Join(" ", state.CommunityCards.Select(c => $"{c.Value}{c.Suit.First()}"))
                : "None");

            _output.WriteLine("  Players:");
            if (state.Players != null)
            {
                foreach (var p in state.Players.OrderBy(pl => pl.SeatPosition))
                {
                    string turnMarker = state.CurrentTurnUserId == p.UserId ? " <<< TURN" : "";
                    string dealerMarker = p.IsDealer ? " (D)" : "";
                    string sbMarker = p.IsSmallBlind ? " (SB)" : "";
                    string bbMarker = p.IsBigBlind ? " (BB)" : "";
                    string activeMarker = p.IsActive ? "" : " (Folded)";
                    _output.WriteLine(
                        $"   - Seat {p.SeatPosition}: {p.Username} (ID: {p.UserId}), Chips: {p.ChipCount}{dealerMarker}{sbMarker}{bbMarker}{activeMarker}{turnMarker}");
                }
            }
            else
            {
                _output.WriteLine("   (Player list is null in game state)");
            }
            // Optionally log last few moves from state.LastMoves
        }


        // --- API Interaction Helpers (Using _client, _output, and API DTOs) ---

        private async Task<UserDto?> RegisterUserAsync(RegisterDto dto)
        {
            try
            {
                HttpResponseMessage response = await _client.PostAsJsonAsync("/api/users/register", dto);
                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadFromJsonAsync<UserDto>();
                }
                else
                {
                    // Log failure response here
                    _output.WriteLine(
                        $"!!! Register failed: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                _output.WriteLine($"!!! Exception during Register: {ex.Message}");
                return null;
            }
        }

        private async Task<UserDto?> LoginUserAsync(LoginDto dto)
        {
            try
            {
                HttpResponseMessage response = await _client.PostAsJsonAsync("/api/users/login", dto);
                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadFromJsonAsync<UserDto>();
                }
                else
                {
                    // Log failure response here
                    _output.WriteLine(
                        $"!!! Login failed for {dto.Username}: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                _output.WriteLine($"!!! Exception during Login: {ex.Message}");
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
                    var g = await response.Content.ReadFromJsonAsync<Game>();
                    return g?.GameId;
                }
                else
                {
                    // Log failure response here
                    _output.WriteLine(
                        $"!!! CreateGame failed: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                _output.WriteLine($"!!! Exception during CreateGame: {ex.Message}");
                _client.DefaultRequestHeaders.Authorization = null;
                return null;
            }
        }

        private async Task<bool> JoinAllPlayers(int gameId, List<UserDto> players)
        {
            int seat = 1;
            foreach (var player in players)
            {
                _output.WriteLine($" > {player.Username} attempting to join seat {seat}...");
                // JoinGame now handles logging on failure
                if (!await JoinGame(gameId, player.Token, seat, DefaultBuyIn))
                {
                    return false; // Stop if any player fails
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
                    // Log failure response here
                    _output.WriteLine(
                        $"!!! JoinGame failed for seat {seatPosition}: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                }

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _output.WriteLine($"!!! Exception during JoinGame: {ex.Message}");
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
                    _output.WriteLine(
                        $" !! StartGame failed: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _output.WriteLine($" !! Exception during StartGame: {ex.Message}");
                _client.DefaultRequestHeaders.Authorization = null;
                return false;
            }
        }

        private async Task<GameStateDto?> GetGameStateAsync(int gameId, string token)
        {
            try
            {
                _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
                // Use the endpoint that infers user from token, as the player-specific view might not be needed
                // for the simulation's decision making, unless you want to log hole cards.
                HttpResponseMessage response = await _client.GetAsync($"/api/games/{gameId}");
                _client.DefaultRequestHeaders.Authorization = null;

                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadFromJsonAsync<GameStateDto>(new JsonSerializerOptions
                        { PropertyNameCaseInsensitive = true });
                }

                _output.WriteLine(
                    $" !! GetGameState failed: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                return null;
            }
            catch (Exception ex)
            {
                _output.WriteLine($" !! Exception during GetGameState: {ex.Message}");
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
                    // Log failure response here - THIS IS CRUCIAL FOR DEBUGGING MOVE FAILURES
                    _output.WriteLine(
                        $"!!! MakeMove failed ({dto.ActionType} {dto.Amount}): {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
                }

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _output.WriteLine($"!!! Exception during MakeMove: {ex.Message}");
                _client.DefaultRequestHeaders.Authorization = null;
                return false;
            }
        }
    }
}