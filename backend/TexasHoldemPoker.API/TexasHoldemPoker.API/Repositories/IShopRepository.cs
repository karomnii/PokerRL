using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IShopRepository
    {
        Task<ShopItem> GetItemByIdAsync(int itemId);
        Task<IEnumerable<ShopItem>> GetAllItemsAsync();
        Task<IEnumerable<ShopItem>> GetItemsByTypeAsync(string itemType);
        Task<ShopItem> CreateItemAsync(ShopItem item);
        Task UpdateItemAsync(ShopItem item);
        Task<bool> DeactivateItemAsync(int itemId);
    }
}