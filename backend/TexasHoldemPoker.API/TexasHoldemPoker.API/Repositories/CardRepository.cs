using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Data;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class CardRepository : ICardRepository
    {
        private readonly PokerDbContext _context;

        public CardRepository(PokerDbContext context)
        {
            _context = context;
        }

        public async Task<Card> GetCardByIdAsync(int cardId)
        {
            return await _context.Cards.FindAsync(cardId);
        }

        public async Task<IEnumerable<Card>> GetAllCardsAsync()
        {
            return await _context.Cards.ToListAsync();
        }

        public async Task<IEnumerable<Card>> GetCommunityCardsByGameIdAsync(int gameId)
        {
            return await _context.CommunityCards
                .Where(cc => cc.GameId == gameId)
                .Include(cc => cc.Card)
                .OrderBy(cc => cc.Position)
                .Select(cc => cc.Card)
                .ToListAsync();
        }

        public async Task<IEnumerable<Card>> GetPlayerCardsByGamePlayerIdAsync(int gamePlayerId)
        {
            return await _context.PlayerCards
                .Where(pc => pc.GamePlayerId == gamePlayerId)
                .Include(pc => pc.Card)
                .OrderBy(pc => pc.Position)
                .Select(pc => pc.Card)
                .ToListAsync();
        }

        public async Task<bool> DealCommunityCardAsync(int gameId, int cardId, int position)
        {
            // Check if position is already taken
            var existingCard = await _context.CommunityCards
                .FirstOrDefaultAsync(cc => cc.GameId == gameId && cc.Position == position);

            if (existingCard != null)
                return false;

            // Check if card is already used in this game
            var cardUsed = await _context.CommunityCards
                .AnyAsync(cc => cc.GameId == gameId && cc.CardId == cardId);

            if (cardUsed)
                return false;

            // Check if card is used by any player in this game
            var cardUsedByPlayer = await _context.PlayerCards
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

            _context.CommunityCards.Add(communityCard);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DealPlayerCardAsync(int gamePlayerId, int cardId, int position)
        {
            // Check if position is already taken
            var existingCard = await _context.PlayerCards
                .FirstOrDefaultAsync(pc => pc.GamePlayerId == gamePlayerId && pc.Position == position);

            if (existingCard != null)
                return false;

            // Get game ID for this player
            var gamePlayer = await _context.GamePlayers.FindAsync(gamePlayerId);
            if (gamePlayer == null)
                return false;

            // Check if card is already used in community cards
            var cardUsedInCommunity = await _context.CommunityCards
                .AnyAsync(cc => cc.GameId == gamePlayer.GameId && cc.CardId == cardId);

            if (cardUsedInCommunity)
                return false;

            // Check if card is used by any other player in this game
            var cardUsedByOtherPlayer = await _context.PlayerCards
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

            _context.PlayerCards.Add(playerCard);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ClearGameCardsAsync(int gameId)
        {
            // Remove community cards
            var communityCards = await _context.CommunityCards
                .Where(cc => cc.GameId == gameId)
                .ToListAsync();

            _context.CommunityCards.RemoveRange(communityCards);

            // Remove player cards
            var gamePlayers = await _context.GamePlayers
                .Where(gp => gp.GameId == gameId)
                .ToListAsync();

            foreach (var gamePlayer in gamePlayers)
            {
                var playerCards = await _context.PlayerCards
                    .Where(pc => pc.GamePlayerId == gamePlayer.GamePlayerId)
                    .ToListAsync();

                _context.PlayerCards.RemoveRange(playerCards);
            }

            await _context.SaveChangesAsync();
            return true;
        }
    }
}
