using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Services
{
    public interface IAiAgentService
    {
        Task<float[]> PredictActionAsync(float[] gameState);
        Task<MoveDto> GetBestActionAsync(GameStateDto gameState);
    }
}
