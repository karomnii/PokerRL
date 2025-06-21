using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class ShopRepository : IShopRepository
    {
        private readonly ApplicationDbContext _context;
        private readonly IUserRepository _userRepository;

        public ShopRepository(ApplicationDbContext context, IUserRepository userRepository)
        {
            _context = context;
            _userRepository = userRepository;
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

        public async Task<IEnumerable<ShopItemDto>> GetAllActiveItemsForUserAsync(int userId)
        {
            var allActiveItems = await GetAllItemsAsync();
            var itemsOwned = await GetItemsOwnedByUser(userId);

            return allActiveItems
                .Where(item => !itemsOwned.Any(owned => owned.ItemId == item.ItemId))
                .Select(item => new ShopItemDto
                {
                    ItemId = item.ItemId,
                    Name = item.Name,
                    Description = item.Description,
                    Price = item.Price,
                    Currency = item.Currency,
                    ItemType = item.ItemType
                });
        }

        public async Task<IEnumerable<ShopItemDto>> GetBoughtItemsForUserAsync(int userId)
        {
            var itemsOwned = await GetItemsOwnedByUser(userId);
            return itemsOwned.Select(item => new ShopItemDto
            {
                ItemId = item.ItemId,
                Name = item.Name,
                Description = item.Description,
                Price = item.Price,
                Currency = item.Currency,
                ItemType = item.ItemType
            });
        }

        public async Task<bool> SetItemForUser(int userId, int itemId)
        {
            var ownedItems = await GetItemsOwnedByUser(userId);
            var item = await _context.ShopItems.FindAsync(itemId);

            if (item == null || !item.IsActive)
                return false;

            if (ownedItems.All(i => i.ItemId != itemId)) return false;

            switch (item.ItemType)
            {
                case "Avatar":
                    return await _userRepository.SetUserAvatarImage(userId, item.Name);
                case "CardDeck":
                    return await _userRepository.SetUserDeckStyle(userId, item.Name);
                default:
                    return false;
            }
        }

        private async Task<IEnumerable<ShopItem>> GetItemsOwnedByUser(int userId)
        {
            return await _context.Purchases
                .Where(p => p.UserId == userId)
                .Include(p => p.Item)
                .Select(p => p.Item)
                .ToListAsync();
        }
    }
}