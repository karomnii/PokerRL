using Microsoft.EntityFrameworkCore;

using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class LeaderboardRepository : ILeaderboardRepository
    {
        private readonly ApplicationDbContext _context;

        public LeaderboardRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<LeaderboardView>> GetTopPlayersAsync(int count)
        {
            return await _context.LeaderboardViews
                .Take(count)
                .ToListAsync();
        }

        public async Task<LeaderboardView> GetPlayerRankingAsync(int userId)
        {
            return await _context.LeaderboardViews
                .FirstOrDefaultAsync(l => l.UserId == userId);
        }

        public async Task<int> GetPlayerRankPositionAsync(int userId)
        {
            var orderedUserIds = await _context.LeaderboardViews
                .Select(l => l.UserId)
                .ToListAsync();

            int position = orderedUserIds.IndexOf(userId);

            return position >= 0 ? position + 1 : -1;
        }
        public async Task<IEnumerable<LeaderboardView>> GetTopPlayersSortedAsync(int count)
        {
            return await _context.LeaderboardViews
                .OrderByDescending(l => l.ChipsBalance) // Sortowanie według ilości zetonow
                .Take(count) // Pobranie określonej liczby graczy
                .ToListAsync();
        }
    }
}