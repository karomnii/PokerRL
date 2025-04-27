using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface ILeaderboardRepository
    {
        Task<IEnumerable<LeaderboardEntry>> GetTopPlayersAsync(int count);
        Task<LeaderboardEntry> GetPlayerRankingAsync(int userId);
        Task<int> GetPlayerRankPositionAsync(int userId);
    }
}