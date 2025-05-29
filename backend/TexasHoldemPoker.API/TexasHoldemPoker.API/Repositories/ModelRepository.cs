using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories;

public class ModelRepository : IModelRepository
{
    private readonly ApplicationDbContext _context;

    public ModelRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Model> GetByIdAsync(int modelId)
    {
        return await _context.Models
                   .Include(m => m.UserModels)
                   .ThenInclude(um => um.User)
                   .FirstOrDefaultAsync(m => m.ModelId == modelId);
    }

    public async Task<Model> GetByUserIdAsync(int userId)
    {
        return await _context.Models
                   .Include(m => m.UserModels)
                   .ThenInclude(um => um.User)
                   .FirstOrDefaultAsync(m => m.UserModels.Any(um => um.UserId == userId));
    }

    public async Task<IEnumerable<Model>> GetAllAsync()
    {
        return await _context.Models
            .Include(m => m.UserModels)
            .ThenInclude(um => um.User)
            .ToListAsync();
    }
}