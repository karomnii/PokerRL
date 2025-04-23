using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Data
{
    public class PokerDbContext : DbContext
    {
        public PokerDbContext(DbContextOptions<PokerDbContext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<PokerTable> PokerTables { get; set; }
        public DbSet<Game> Games { get; set; }
        public DbSet<GamePlayer> GamePlayers { get; set; }
        public DbSet<Card> Cards { get; set; }
        public DbSet<CommunityCard> CommunityCards { get; set; }
        public DbSet<PlayerCard> PlayerCards { get; set; }
        public DbSet<Move> Moves { get; set; }
        public DbSet<ShopItem> ShopItems { get; set; }
        public DbSet<Purchase> Purchases { get; set; }
        public DbSet<ChipTransaction> ChipTransactions { get; set; }
        public DbSet<GameRound> GameRounds { get; set; }
        public DbSet<GameRoundWinner> GameRoundWinners { get; set; }
        public DbSet<LeaderboardEntry> LeaderboardEntries { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure view for leaderboard
            modelBuilder.Entity<LeaderboardEntry>().HasNoKey().ToView("LeaderboardView");

            // Remove WinnerId relationship (no longer exists)
            // modelBuilder.Entity<Game>()
            //     .HasOne(g => g.Winner)
            //     .WithMany(u => u.WonGames)
            //     .HasForeignKey(g => g.WinnerId)
            //     .IsRequired(false);

            // Game <-> PokerTable
            modelBuilder.Entity<Game>()
                .HasOne(g => g.Table)
                .WithMany(t => t.Games)
                .HasForeignKey(g => g.TableId)
                .OnDelete(DeleteBehavior.Cascade);

            // Game <-> CurrentTurnUser
            modelBuilder.Entity<Game>()
                .HasOne(g => g.CurrentTurnUser)
                .WithMany()
                .HasForeignKey(g => g.CurrentTurnUserId)
                .OnDelete(DeleteBehavior.SetNull);

            // GamePlayer <-> Game
            modelBuilder.Entity<GamePlayer>()
                .HasOne(gp => gp.Game)
                .WithMany(g => g.GamePlayers)
                .HasForeignKey(gp => gp.GameId)
                .OnDelete(DeleteBehavior.Cascade);

            // GamePlayer <-> User
            modelBuilder.Entity<GamePlayer>()
                .HasOne(gp => gp.User)
                .WithMany(u => u.GamePlayers)
                .HasForeignKey(gp => gp.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            // GameRound <-> Game
            modelBuilder.Entity<GameRound>()
                .HasOne(gr => gr.Game)
                .WithMany(g => g.GameRounds)
                .HasForeignKey(gr => gr.GameId)
                .OnDelete(DeleteBehavior.Cascade);

            // GameRoundWinner <-> GameRound
            modelBuilder.Entity<GameRoundWinner>()
                .HasOne(grw => grw.GameRound)
                .WithMany(gr => gr.Winners)
                .HasForeignKey(grw => grw.GameRoundId)
                .OnDelete(DeleteBehavior.Cascade);

            // GameRoundWinner <-> User
            modelBuilder.Entity<GameRoundWinner>()
                .HasOne(grw => grw.User)
                .WithMany(u => u.GameRoundWinners)
                .HasForeignKey(grw => grw.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            // GamePlayer: Unique constraints
            modelBuilder.Entity<GamePlayer>()
                .HasIndex(gp => new { gp.GameId, gp.UserId })
                .IsUnique();
            modelBuilder.Entity<GamePlayer>()
                .HasIndex(gp => new { gp.GameId, gp.SeatPosition })
                .IsUnique();

            // CommunityCard: Unique constraint
            modelBuilder.Entity<CommunityCard>()
                .HasIndex(cc => new { cc.GameId, cc.Position })
                .IsUnique();

            // PlayerCard: Unique constraint
            modelBuilder.Entity<PlayerCard>()
                .HasIndex(pc => new { pc.GamePlayerId, pc.Position })
                .IsUnique();

            // Seeding Cards
            SeedCards(modelBuilder);

            // Seeding PokerTables
            SeedPokerTables(modelBuilder);

            // Seeding ShopItems
            SeedShopItems(modelBuilder);
        }

        private void SeedCards(ModelBuilder modelBuilder)
        {
            var cards = new List<Card>();
            int id = 1;
            foreach (var suit in new[] { "Hearts", "Diamonds", "Clubs", "Spades" })
            {
                foreach (var value in new[] { "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A" })
                {
                    cards.Add(new Card { CardId = id++, Suit = suit, Value = value });
                }
            }

            modelBuilder.Entity<Card>().HasData(cards);
        }

        private void SeedPokerTables(ModelBuilder modelBuilder)
        {
            var pokerTables = new List<PokerTable>
            {
                new PokerTable
                {
                    TableId = 1, Name = "Beginner Table", EntryFee = 100, MinBuyIn = 500, MaxBuyIn = 1000,
                    SmallBlind = 10, BigBlind = 20, MaxPlayers = 9, DifficultyLevel = "Beginner", IsActive = true
                },
                new PokerTable
                {
                    TableId = 2, Name = "Intermediate Table", EntryFee = 500, MinBuyIn = 1000, MaxBuyIn = 5000,
                    SmallBlind = 50, BigBlind = 100, MaxPlayers = 9, DifficultyLevel = "Intermediate", IsActive = true
                },
                new PokerTable
                {
                    TableId = 3, Name = "Pro Table", EntryFee = 1000, MinBuyIn = 5000, MaxBuyIn = 10000,
                    SmallBlind = 100, BigBlind = 200, MaxPlayers = 9, DifficultyLevel = "Pro", IsActive = true
                }
            };
            modelBuilder.Entity<PokerTable>().HasData(pokerTables);
        }

        private void SeedShopItems(ModelBuilder modelBuilder)
        {
            var shopItems = new List<ShopItem>
            {
                new ShopItem
                {
                    ItemId = 1, Name = "Basic Chips Pack", Description = "Get 1000 chips.", Price = 4.99m,
                    ItemType = "Chips", IsActive = true
                },
                new ShopItem
                {
                    ItemId = 2, Name = "Premium Chips Pack", Description = "Get 5000 chips.", Price = 19.99m,
                    ItemType = "Chips", IsActive = true
                },
                new ShopItem
                {
                    ItemId = 3, Name = "Golden Avatar", Description = "Unlock a golden avatar.", Price = 9.99m,
                    ItemType = "Avatar", IsActive = true
                },
                new ShopItem
                {
                    ItemId = 4, Name = "Luxury Card Deck", Description = "Upgrade your card deck to a luxury theme.",
                    Price = 14.99m, ItemType = "CardDeck", IsActive = true
                }
            };
            modelBuilder.Entity<ShopItem>().HasData(shopItems);
        }
    }
}