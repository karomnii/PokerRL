using Microsoft.AspNetCore.SignalR;
using System.Security.Claims;
using System.Text.RegularExpressions;
using TexasHoldemPoker.API.Services;

namespace TexasHoldemPoker.API.Hubs
{
    public class GameHub : Hub
    {
        private readonly IPokerGameService _gameService;

        public GameHub(IPokerGameService gameService)
        {
            _gameService = gameService;
        }

        public async Task JoinGameGroup(int gameId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, $"Game_{gameId}");
        }

        public async Task LeaveGameGroup(int gameId)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"Game_{gameId}");
        }

        public async Task SendGameUpdate(int gameId)
        {
            // This method would be called from the game service when the game state changes
            var gameState = await _gameService.GetGameStateAsync(gameId, 0); // 0 means get public state only
            await Clients.Group($"Game_{gameId}").SendAsync("ReceiveGameUpdate", gameState);
        }

        public async Task SendPlayerUpdate(int gameId, int userId)
        {
            // This method would be called to send private updates to a specific player
            var gameState = await _gameService.GetGameStateAsync(gameId, userId);
            await Clients.User(userId.ToString()).SendAsync("ReceivePlayerUpdate", gameState);
        }

        public async Task SendChatMessage(int gameId, string message)
        {
            var username = Context.User.FindFirst(ClaimTypes.Name)?.Value;
            await Clients.Group($"Game_{gameId}").SendAsync("ReceiveChatMessage", username, message);
        }
    }
}
