using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories;

public interface IUserModelRepository
{
    Task<UserModel> AddAsync(int userId, int modelId);
    Task<bool> RemoveAsync(int userModelId);
    Task<bool> RemoveAsync(int userId, int modelId);
    Task<UserModel?> GetAsync(int userModelId);
    Task<UserModel?> GetAsync(int userId, int modelId);
    
    
    Task<IEnumerable<Model>> GetModelsByUserAsync(int userId);
    Task<IEnumerable<User>> GetUsersByModelAsync(int modelId);
    Task<bool> ExistsAsync(int userId, int modelId);
}