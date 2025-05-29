using TexasHoldemPoker.API.DTOs;

namespace TexasHoldemPoker.API.Services
{
    public interface IAiAgentService
    {
        Task<float[]> PredictActionAsync(float[] gameState);
        Task<MoveDto> GetBestActionAsync(GameStateDto gameState);
    }
}
