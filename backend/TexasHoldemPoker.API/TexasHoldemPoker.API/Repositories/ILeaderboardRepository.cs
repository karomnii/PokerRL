using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface ILeaderboardRepository
    {
        Task<IEnumerable<LeaderboardView>> GetTopPlayersAsync(int count);
        Task<LeaderboardView> GetPlayerRankingAsync(int userId);
        Task<int> GetPlayerRankPositionAsync(int userId);
        Task<IEnumerable<LeaderboardView>> GetTopPlayersSortedAsync(int count);
    }
}