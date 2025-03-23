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
            // Get all user IDs ordered by chips balance
            var orderedUserIds = await _context.LeaderboardEntries
                .Select(l => l.UserId)
                .ToListAsync();

            // Find the position of the specified user
            int position = orderedUserIds.IndexOf(userId);

            // Return 1-based position (or -1 if not found)
            return position >= 0 ? position + 1 : -1;
        }
    }

}
