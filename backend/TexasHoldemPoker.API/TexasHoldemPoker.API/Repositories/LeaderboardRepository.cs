using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
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
            return await _context.Set<LeaderboardView>() 
                .Take(count)
                .ToListAsync();
        }

        public async Task<LeaderboardView?> GetPlayerRankingAsync(int userId)
        {
            return await _context.Set<LeaderboardView>() 
                .FirstOrDefaultAsync(l => l.UserId == userId);
        }

        public async Task<int> GetPlayerRankPositionAsync(int userId)
        {
            var orderedUserIds = await _context.Set<LeaderboardView>() 
                .Select(l => l.UserId)
                .ToListAsync();

            int position = orderedUserIds.IndexOf(userId);

            return position >= 0 ? position + 1 : -1;
        }
        public async Task<IEnumerable<LeaderboardView>> GetTopPlayersSortedAsync(int count)
        {
            return await _context.Set<LeaderboardView>() 
                .OrderByDescending(l => l.ChipsBalance) // Sortowanie według ilości zetonow
                .Take(count) // Pobranie określonej liczby graczy
                .ToListAsync();
        }
    }
}