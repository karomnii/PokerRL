using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories;

public class UserModelRepository : IUserModelRepository
{
    private readonly ApplicationDbContext _context;

    public UserModelRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<UserModel> GetAsync(int userModelId)
    {
        return await _context.UserModels
            .Include(um => um.User)
            .Include(um => um.Model)
            .FirstOrDefaultAsync(um => um.UserModelId == userModelId);
    }

    public async Task<Model> GetModelByUserAsync(int userId)
    {
        return await _context.UserModels
            .Where(um => um.UserId == userId)
            .Select(um => um.Model)
            .FirstOrDefaultAsync();
    }

    public async Task<IEnumerable<User>> GetUsersByModelAsync(int modelId)
    {
        return await _context.UserModels
            .Where(um => um.ModelId == modelId)
            .Select(um => um.User)
            .ToListAsync();
    }

    public async Task<bool> IsUserAiAgent(int userId)
    {
        return await _context.UserModels
            .AnyAsync(um => um.UserId == userId);
    }

    public async Task<IEnumerable<User>> GetAllBotUsersAsync()
    {
        return await _context.Users
            .Where(u => u.IsBot == true)
            .Include(u => u.UserModels)
            .ThenInclude(um => um.Model)
            .ToListAsync();
    }
}