using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class ShopRepository : IShopRepository
    {
        private readonly PokerDbContext _context;

        public ShopRepository(PokerDbContext context)
        {
            _context = context;
        }

        public async Task<ShopItem> GetItemByIdAsync(int itemId)
        {
            return await _context.ShopItems.FindAsync(itemId);
        }

        public async Task<IEnumerable<ShopItem>> GetAllItemsAsync()
        {
            return await _context.ShopItems
                .Where(i => i.IsActive)
                .ToListAsync();
        }

        public async Task<IEnumerable<ShopItem>> GetItemsByTypeAsync(string itemType)
        {
            return await _context.ShopItems
                .Where(i => i.ItemType == itemType && i.IsActive)
                .ToListAsync();
        }

        public async Task<ShopItem> CreateItemAsync(ShopItem item)
        {
            item.IsActive = true;
            _context.ShopItems.Add(item);
            await _context.SaveChangesAsync();
            return item;
        }

        public async Task UpdateItemAsync(ShopItem item)
        {
            _context.Entry(item).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeactivateItemAsync(int itemId)
        {
            var item = await _context.ShopItems.FindAsync(itemId);
            if (item == null) return false;

            item.IsActive = false;
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
