using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories;

public class ModelRepository : IModelRepository
{
    private readonly ApplicationDbContext _context;
    public ModelRepository(ApplicationDbContext context) =>
                                            _context = context;

    public async Task<Model> AddAsync(string name, string? path, string? difficulty)
    {
        if(await ExistsAsync(name))
            throw new InvalidOperationException($"Model with name '{name}' already exists.");
        
        var entity = new Model
        {
            Name       = name,
            Path       = path,
            Difficulty = difficulty
        };
        await _context.Models.AddAsync(entity);
        await _context.SaveChangesAsync();
        return entity;
    }

    public async Task<bool> UpdateAsync(int modelId, string? name = null, string? path = null,
        string? difficulty = null)
    {
        var entity = await _context.Models.FindAsync(modelId);
        if(entity == null)
            return false;
        if(name is not null ) entity.Name   = name;
        if(path is not null ) entity.Path   = path;
        if(difficulty is not null ) entity.Difficulty = difficulty;
        
        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> DeleteAsync(int modelId)
    {
        var entity = await _context.Models.FindAsync(modelId);
        if(entity == null)
            return false;
        _context.Models.Remove(entity);
        await _context.SaveChangesAsync();
        return true;
    }
    
    public async Task<Model?> GetAsync(int modelId) =>
        await _context.Models
            .Include(m => m.UserModels)
            .ThenInclude(um => um.User)
            .FirstOrDefaultAsync(m => m.ModelId == modelId);
    
    public async Task<IEnumerable<Model>> GetAllAsync() =>
        await _context.Models
            .OrderBy(m => m.Name)
            .ToListAsync();
    
    
    public async Task<IEnumerable<Model>> GetByDifficultyAsync(string difficulty) =>
        await _context.Models
            .Where(m => m.Difficulty == difficulty)
            .OrderBy(m => m.Name)
            .ToListAsync();
    
    public async Task<bool> ExistsAsync(string name) =>
        await _context.Models.AnyAsync(m => m.Name == name);
}