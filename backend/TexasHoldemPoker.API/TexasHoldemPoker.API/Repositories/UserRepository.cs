using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly PokerDbContext _context;

        public UserRepository(PokerDbContext context)
        {
            _context = context;
        }

        public async Task<User> GetByIdAsync(int userId)
        {
            return await _context.Users
                .Include(u => u.GamePlayers)
                .Include(u => u.Purchases)
                .Include(u => u.ChipTransactions)
                .Include(u => u.GameRoundWinners)
                .FirstOrDefaultAsync(u => u.UserId == userId && u.IsActive);
        }

        public async Task<User> GetByUsernameAsync(string username)
        {
            return await _context.Users
                .Include(u => u.GamePlayers)
                .Include(u => u.Purchases)
                .Include(u => u.ChipTransactions)
                .Include(u => u.GameRoundWinners)
                .FirstOrDefaultAsync(u => u.Username == username && u.IsActive);
        }

        public async Task<User> GetByEmailAsync(string email)
        {
            return await _context.Users
                .Include(u => u.GamePlayers)
                .Include(u => u.Purchases)
                .Include(u => u.ChipTransactions)
                .Include(u => u.GameRoundWinners)
                .FirstOrDefaultAsync(u => u.Email == email && u.IsActive);
        }

        public async Task<IEnumerable<User>> GetAllActiveAsync()
        {
            return await _context.Users
                .Where(u => u.IsActive)
                .ToListAsync();
        }

        public async Task<User> CreateUserAsync(User user)
        {
            user.IsActive = true;
            user.RegistrationDate = System.DateTime.UtcNow;
            _context.Users.Add(user);
            await _context.SaveChangesAsync();
            return user;
        }

        public async Task UpdateUserAsync(User user)
        {
            _context.Entry(user).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteUserAsync(int userId)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);
            if (user == null) return false;
            user.IsActive = false;
            _context.Entry(user).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> AdjustChipsAsync(int userId, int amountDelta)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId && u.IsActive);
            if (user == null) return false;
            user.ChipsBalance += amountDelta;
            if (user.ChipsBalance < 0) user.ChipsBalance = 0;
            _context.Entry(user).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> SaveChangesAsync()
        {
            return (await _context.SaveChangesAsync()) > 0;
        }
    }
}