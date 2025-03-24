using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IUserRepository
    {
        Task<User> GetByIdAsync(int userId);
        Task<User> GetByUsernameAsync(string username);
        Task<User> GetByEmailAsync(string email);
        Task<IEnumerable<User>> GetAllAsync();
        Task<User> CreateAsync(User user);
        Task UpdateAsync(User user);
        Task<bool> UpdateChipsBalanceAsync(int userId, int amount);
        Task<bool> DeleteAsync(int userId);
        Task<bool> DeactivateAsync(int userId);
        Task<bool> VerifyPasswordAsync(string username, string password);
    }
}
