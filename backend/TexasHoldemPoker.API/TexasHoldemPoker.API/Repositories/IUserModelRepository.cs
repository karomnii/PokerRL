using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories;

public interface IUserModelRepository
{
    Task<UserModel> GetAsync(int userModelId);
    Task<Model> GetModelByUserAsync(int userId);
    Task<IEnumerable<User>> GetUsersByModelAsync(int modelId);
    Task<bool> IsUserAiAgent(int userId);
    Task<IEnumerable<User>> GetAllBotUsersAsync();
}