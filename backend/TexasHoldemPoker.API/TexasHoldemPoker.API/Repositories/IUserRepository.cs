using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IUserRepository
    {
        Task<User> GetByIdAsync(int userId);
        Task<User> GetByUsernameAsync(string username);
        Task<User> GetByEmailAsync(string email);
        Task<IEnumerable<User>> GetAllActiveAsync();
        Task<User> CreateUserAsync(User user);
        Task UpdateUserAsync(User user);
        Task<bool> DeleteUserAsync(int userId);
        Task<bool> AdjustChipsAsync(int userId, int amountDelta);
        Task<bool> SaveChangesAsync();
        Task<bool> SetUserDeckStyle(int userId, string deckStyle);
        Task<bool> SetUserAvatarImage(int userId, string avatarImage);
    }
}