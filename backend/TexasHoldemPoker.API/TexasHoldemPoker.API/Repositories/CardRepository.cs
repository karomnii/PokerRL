using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class CardRepository : ICardRepository
    {
        private readonly PokerDbContext context;

        public CardRepository(PokerDbContext context)
        {
            this.context = context;
        }

        public async Task<Card> GetCardByIdAsync(int cardId)
        {
            return await context.Cards.FindAsync(cardId);
        }

        public async Task<IEnumerable<Card>> GetAllCardsAsync()
        {
            return await context.Cards.ToListAsync();
        }

        public async Task<IEnumerable<Card>> GetCommunityCardsByGameIdAsync(int gameId)
        {
            return await context.CommunityCards
                .Where(cc => cc.GameId == gameId)
                .Include(cc => cc.Card)
                .OrderBy(cc => cc.Position)
                .Select(cc => cc.Card)
                .ToListAsync();
        }

        public async Task<IEnumerable<Card>> GetPlayerCardsByGamePlayerIdAsync(int gamePlayerId)
        {
            return await context.PlayerCards
                .Where(pc => pc.GamePlayerId == gamePlayerId)
                .Include(pc => pc.Card)
                .OrderBy(pc => pc.Position)
                .Select(pc => pc.Card)
                .ToListAsync();
        }

        public async Task<bool> DealCommunityCardAsync(int gameId, int cardId, int position)
        {
            // Check if position is already taken
            var existingCard = await context.CommunityCards
                .FirstOrDefaultAsync(cc => cc.GameId == gameId && cc.Position == position);

            if (existingCard != null)
                return false;

            // Check if card is already used in this game
            var cardUsed = await context.CommunityCards
                .AnyAsync(cc => cc.GameId == gameId && cc.CardId == cardId);

            if (cardUsed)
                return false;

            // Check if card is used by any player in this game
            var cardUsedByPlayer = await context.PlayerCards
                .Include(pc => pc.GamePlayer)
                .AnyAsync(pc => pc.GamePlayer.GameId == gameId && pc.CardId == cardId);

            if (cardUsedByPlayer)
                return false;

            var communityCard = new CommunityCard
            {
                GameId = gameId,
                CardId = cardId,
                Position = position
            };

            context.CommunityCards.Add(communityCard);
            await context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DealPlayerCardAsync(int gamePlayerId, int cardId, int position)
        {
            // Check if position is already taken
            var existingCard = await context.PlayerCards
                .FirstOrDefaultAsync(pc => pc.GamePlayerId == gamePlayerId && pc.Position == position);

            if (existingCard != null)
                return false;

            // Get game ID for this player
            var gamePlayer = await context.GamePlayers.FindAsync(gamePlayerId);
            if (gamePlayer == null)
                return false;

            // Check if card is already used in community cards
            var cardUsedInCommunity = await context.CommunityCards
                .AnyAsync(cc => cc.GameId == gamePlayer.GameId && cc.CardId == cardId);

            if (cardUsedInCommunity)
                return false;

            // Check if card is used by any other player in this game
            var cardUsedByOtherPlayer = await context.PlayerCards
                .Include(pc => pc.GamePlayer)
                .AnyAsync(pc => pc.GamePlayer.GameId == gamePlayer.GameId &&
                           pc.CardId == cardId &&
                           pc.GamePlayer.GamePlayerId != gamePlayerId);

            if (cardUsedByOtherPlayer)
                return false;

            var playerCard = new PlayerCard
            {
                GamePlayerId = gamePlayerId,
                CardId = cardId,
                Position = position
            };

            context.PlayerCards.Add(playerCard);
            await context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ClearGameCardsAsync(int gameId)
        {
            // Remove community cards
            var communityCards = await context.CommunityCards
                .Where(cc => cc.GameId == gameId)
                .ToListAsync();

            context.CommunityCards.RemoveRange(communityCards);

            // Remove player cards
            var gamePlayers = await context.GamePlayers
                .Where(gp => gp.GameId == gameId)
                .ToListAsync();

            foreach (var gamePlayer in gamePlayers)
            {
                var playerCards = await context.PlayerCards
                    .Where(pc => pc.GamePlayerId == gamePlayer.GamePlayerId)
                    .ToListAsync();

                context.PlayerCards.RemoveRange(playerCards);
            }

            await context.SaveChangesAsync();
            return true;
        }
    }
}
