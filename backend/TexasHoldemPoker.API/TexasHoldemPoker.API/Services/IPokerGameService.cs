// IPokerGameService.cs
using System.Threading.Tasks;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Services
{
    public interface IPokerGameService
    {
        Task<Game> CreateGameAsync(int tableId);
        Task<bool> JoinGameAsync(int gameId, int userId, int seatPosition, int buyInAmount);
        Task<bool> AddModelToGameAsync(int gameId, int userId, int seatPosition, int buyInAmount);
        Task<bool> LeaveGameAsync(int gameId, int userId);
        Task<bool> KickModelOutOfGameAsync(int gameId, int userId);
        Task<bool> StartGameAsync(int gameId);
        Task<bool> PlaceBetAsync(int gameId, int userId, string actionType, int amount);
        Task<GameStateDto> GetGameStateAsync(int gameId, int userId);
        Task<IEnumerable<AgentDto>> GetAvailableAgentsAsync(int gameId);
        Task<bool> InitializeAgentsPlayingInGames();
        Task<IEnumerable<HintDto>> GetGameHints(int gameId, int userId);
    }
}