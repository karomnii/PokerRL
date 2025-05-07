using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories;

public class UserModelRepository : IUserModelRepository
{
    private readonly ApplicationDbContext _context;
    public UserModelRepository(ApplicationDbContext context) => _context = context;


    public async Task<UserModel> AddAsync(int userId, int modelId)
    {
        if (await ExistsAsync(userId, modelId))
            throw new InvalidOperationException(
                $"User {userId} already owns model {modelId}");

        var entity = new UserModel
        {
            UserId  = userId,
            ModelId = modelId
        };

        await _context.UserModels.AddAsync(entity);
        await _context.SaveChangesAsync();
        return entity;
    }

    public async Task<bool> RemoveAsync(int userId, int modelId)
    {
        var ent = await _context.UserModels
            .FirstOrDefaultAsync(um => um.UserId == userId && um.ModelId == modelId);
        if(ent is null) 
            return false;
        
        _context.UserModels.Remove(ent);
        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> RemoveAsync(int userModelId)
    {
        var ent = await _context.UserModels.FindAsync(userModelId);
        if(ent is null)
            return false;
        _context.UserModels.Remove(ent);
        await _context.SaveChangesAsync();
        return true;
    }
    
    
    public async Task<UserModel?> GetAsync(int userModelId) =>
        await _context.UserModels
            .Include(um => um.User)
            .Include(um => um.Model)
            .FirstOrDefaultAsync(um => um.UserModelId == userModelId);

    public async Task<UserModel?> GetAsync(int userId, int modelId) =>
        await _context.UserModels
            .Include(um => um.User)
            .Include(um => um.Model)
            .FirstOrDefaultAsync(um => um.UserId == userId && um.ModelId == modelId);
    
    public async Task<IEnumerable<Model>> GetModelsByUserAsync(int userId) =>
        await _context.UserModels
            .Where(um => um.UserId == userId)
            .Select(um => um.Model)
            .ToListAsync();

    public async Task<IEnumerable<User>> GetUsersByModelAsync(int modelId) =>
        await _context.UserModels
            .Where(um => um.ModelId == modelId)
            .Select(um => um.User)
            .ToListAsync();

    public async Task<bool> ExistsAsync(int userId, int modelId) =>
        await _context.UserModels
            .AnyAsync(um => um.UserId == userId && um.ModelId == modelId);
}