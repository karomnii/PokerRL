using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Services
{
    public interface IPokerGameService
    {
        Task<Game> CreateGameAsync(int tableId);
        Task<bool> JoinGameAsync(int gameId, int userId, int seatPosition, int buyInAmount);
        Task<bool> LeaveGameAsync(int gameId, int userId);
        Task<bool> StartGameAsync(int gameId);
        Task<bool> DealCardsAsync(int gameId);
        Task<bool> PlaceBetAsync(int gameId, int userId, string actionType, int amount);
        Task<bool> DealFlopAsync(int gameId);
        Task<bool> DealTurnAsync(int gameId);
        Task<bool> DealRiverAsync(int gameId);
        Task<bool> DetermineWinnerAsync(int gameId);
        Task<GameState> GetGameStateAsync(int gameId, int userId);
    }

}
