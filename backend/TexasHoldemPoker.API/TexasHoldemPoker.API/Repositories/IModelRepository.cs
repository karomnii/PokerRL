using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories;

public interface IModelRepository
{
    Task<Model> GetByIdAsync(int modelId);
    Task<Model> GetByUserIdAsync(int userId);
    Task<IEnumerable<Model>> GetAllAsync();
}