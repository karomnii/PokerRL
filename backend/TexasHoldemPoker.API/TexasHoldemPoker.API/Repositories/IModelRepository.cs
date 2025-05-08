using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories;

public interface IModelRepository
{
    Task<Model> AddAsync(string name, string path, string? difficulty);

    Task<bool> UpdateAsync(
        int modelId, 
        string? name = null,
        string? path = null,
        string? difficulty = null
    );
    Task<bool> DeleteAsync(int modelId);


    Task<Model?> GetAsync(int modelId);
    Task<IEnumerable<Model>>GetAllAsync();
    Task<IEnumerable<Model>>GetByDifficultyAsync(string difficulty);
    Task<bool> ExistsAsync(string name);
}