using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class LeaderboardRepository : ILeaderboardRepository
    {
        private readonly PokerDbContext _context;

        public LeaderboardRepository(PokerDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<LeaderboardEntry>> GetTopPlayersAsync(int count)
        {
            return await _context.LeaderboardEntries
                .Take(count)
                .ToListAsync();
        }

        public async Task<LeaderboardEntry> GetPlayerRankingAsync(int userId)
        {
            return await _context.LeaderboardEntries
                .FirstOrDefaultAsync(l => l.UserId == userId);
        }

        public async Task<int> GetPlayerRankPositionAsync(int userId)
        {
            var orderedUserIds = await _context.LeaderboardEntries
                .Select(l => l.UserId)
                .ToListAsync();

            int position = orderedUserIds.IndexOf(userId);

            return position >= 0 ? position + 1 : -1;
        }
    }
}