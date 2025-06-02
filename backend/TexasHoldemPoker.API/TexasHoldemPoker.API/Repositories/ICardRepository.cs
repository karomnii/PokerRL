using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface ICardRepository
    {
        Task<Card> GetCardByIdAsync(int cardId);
        Task<IEnumerable<Card>> GetAllCardsAsync();
        Task<IEnumerable<Card>> GetCommunityCardsByGameIdAsync(int gameId);
        Task<IEnumerable<Card>> GetPlayerCardsByGamePlayerIdAsync(int gamePlayerId);
        Task<bool> DealCommunityCardAsync(int gameId, int cardId, int position);
        Task<bool> DealPlayerCardAsync(int gamePlayerId, int cardId, int position);
    }
}