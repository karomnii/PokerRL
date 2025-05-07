using Microsoft.EntityFrameworkCore;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class CardRepository : ICardRepository
    {
        private readonly ApplicationDbContext context;

        public CardRepository(ApplicationDbContext context)
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
            var gameRound = await context.GameRounds
                .Where(gr => gr.GameId == gameId)
                .OrderByDescending(gr => gr.RoundNumber)
                .FirstOrDefaultAsync();

            if (gameRound == null)
                return Enumerable.Empty<Card>();

            return await context.CommunityCards
                .Where(cc => cc.GameRoundId == gameRound.GameRoundId)
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
            var gameRound = await context.GameRounds
                .Where(gr => gr.GameId == gameId)
                .OrderByDescending(gr => gr.RoundNumber)
                .FirstOrDefaultAsync();

            if (gameRound == null)
                return false;

            var existingCard = await context.CommunityCards
                .FirstOrDefaultAsync(cc => cc.GameRoundId == gameRound.GameRoundId && cc.Position == position);

            if (existingCard != null)
                return false;

            var cardUsed = await context.CommunityCards
                .AnyAsync(cc => cc.GameRoundId == gameRound.GameRoundId && cc.CardId == cardId);

            if (cardUsed)
                return false;

            var cardUsedByPlayer = await context.PlayerCards
                .Include(pc => pc.GamePlayer)
                .AnyAsync(pc => pc.GamePlayer.GameId == gameId && pc.CardId == cardId);

            if (cardUsedByPlayer)
                return false;

            var communityCard = new CommunityCard
            {
                GameRoundId = gameRound.GameRoundId,
                CardId = cardId,
                Position = position
            };

            context.CommunityCards.Add(communityCard);
            await context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DealPlayerCardAsync(int gamePlayerId, int cardId, int position)
        {

            var existingCard = await context.PlayerCards
                .FirstOrDefaultAsync(pc => pc.GamePlayerId == gamePlayerId && pc.Position == position);

            if (existingCard != null)
                return false;

            var gamePlayer = await context.GamePlayers.FindAsync(gamePlayerId);
            if (gamePlayer == null)
                return false;

            var gameRound = await context.GameRounds
                .Where(gr => gr.GameId == gamePlayer.GameId)
                .OrderByDescending(gr => gr.RoundNumber)
                .FirstOrDefaultAsync();

            if (gameRound == null)
                return false;

            var cardUsedInCommunity = await context.CommunityCards
                .AnyAsync(cc => cc.GameRoundId == gameRound.GameRoundId && cc.CardId == cardId);

            if (cardUsedInCommunity)
                return false;

            var cardUsedByOtherPlayer = await context.PlayerCards
                .Include(pc => pc.GamePlayer)
                .AnyAsync(pc => pc.GameRoundId == gameRound.GameRoundId &&
                                pc.CardId == cardId &&
                                pc.GamePlayer.GamePlayerId != gamePlayerId);

            if (cardUsedByOtherPlayer)
                return false;

            var playerCard = new PlayerCard
            {
                GameRoundId = gameRound.GameRoundId,
                GamePlayerId = gamePlayerId,
                CardId = cardId,
                Position = position
            };

            context.PlayerCards.Add(playerCard);
            await context.SaveChangesAsync();
            return true;
        }

        //public async Task<bool> ClearGameCardsAsync(int gameId)
        //{
        //    var communityCards = await context.CommunityCards
        //        .Where(cc => cc.GameId == gameId)
        //        .ToListAsync();

        //    context.CommunityCards.RemoveRange(communityCards);

        //    var gamePlayers = await context.GamePlayers
        //        .Where(gp => gp.GameId == gameId)
        //        .ToListAsync();

        //    foreach (var gamePlayer in gamePlayers)
        //    {
        //        var playerCards = await context.PlayerCards
        //            .Where(pc => pc.GamePlayerId == gamePlayer.GamePlayerId)
        //            .ToListAsync();

        //        context.PlayerCards.RemoveRange(playerCards);
        //    }

        //    await context.SaveChangesAsync();
        //    return true;
        //}
    }
}