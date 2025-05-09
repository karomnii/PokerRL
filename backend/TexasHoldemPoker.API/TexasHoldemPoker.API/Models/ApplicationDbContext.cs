using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace TexasHoldemPoker.API.Models;

public partial class ApplicationDbContext : DbContext
{
    public ApplicationDbContext()
    {
    }

    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Card> Cards { get; set; }

    public virtual DbSet<ChipTransaction> ChipTransactions { get; set; }

    public virtual DbSet<CommunityCard> CommunityCards { get; set; }

    public virtual DbSet<Game> Games { get; set; }

    public virtual DbSet<GamePlayer> GamePlayers { get; set; }

    public virtual DbSet<GameRound> GameRounds { get; set; }

    public virtual DbSet<GameRoundWinner> GameRoundWinners { get; set; }

    public virtual DbSet<LeaderboardView> LeaderboardViews { get; set; }

    public virtual DbSet<Model> Models { get; set; }

    public virtual DbSet<Move> Moves { get; set; }

    public virtual DbSet<PlayerCard> PlayerCards { get; set; }

    public virtual DbSet<PokerTable> PokerTables { get; set; }

    public virtual DbSet<Purchase> Purchases { get; set; }

    public virtual DbSet<ShopItem> ShopItems { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserModel> UserModels { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlServer("Name=ConnectionStrings:DefaultConnection");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Card>(entity =>
        {
            entity.Property(e => e.Suit).HasMaxLength(10);
            entity.Property(e => e.Value).HasMaxLength(5);
        });

        modelBuilder.Entity<ChipTransaction>(entity =>
        {
            entity.HasKey(e => e.TransactionId);

            entity.HasIndex(e => e.UserId, "IX_ChipTransactions_UserId");

            entity.Property(e => e.Description).HasMaxLength(255);
            entity.Property(e => e.TransactionDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.TransactionType).HasMaxLength(50);

            entity.HasOne(d => d.User).WithMany(p => p.ChipTransactions)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ChipTransactions_Users");
        });

        modelBuilder.Entity<CommunityCard>(entity =>
        {
            entity.HasIndex(e => new { e.GameRoundId, e.Position }, "UQ_CommunityCards_GamePosition").IsUnique();

            entity.HasOne(d => d.Card).WithMany(p => p.CommunityCards)
                .HasForeignKey(d => d.CardId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CommunityCards_Cards");

            entity.HasOne(d => d.GameRound).WithMany(p => p.CommunityCards)
                .HasForeignKey(d => d.GameRoundId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CommunityCards_GameRounds");
        });

        modelBuilder.Entity<Game>(entity =>
        {
            entity.HasIndex(e => e.TableId, "IX_Games_TableId");

            entity.Property(e => e.EndTime).HasColumnType("datetime");
            entity.Property(e => e.StartTime)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.CurrentTurnPlayer).WithMany(p => p.Games)
                .HasForeignKey(d => d.CurrentTurnPlayerId)
                .HasConstraintName("FK_Games_GamePlayers");

            entity.HasOne(d => d.Table).WithMany(p => p.Games)
                .HasForeignKey(d => d.TableId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Games_PokerTables");
        });

        modelBuilder.Entity<GamePlayer>(entity =>
        {
            entity.HasIndex(e => e.GameId, "IX_GamePlayers_GameId");

            entity.HasIndex(e => e.UserId, "IX_GamePlayers_UserId");

            entity.HasIndex(e => new { e.GameId, e.SeatPosition }, "UQ_GamePlayers_GamePosition").IsUnique();

            entity.HasIndex(e => new { e.GameId, e.UserId }, "UQ_GamePlayers_GameUser").IsUnique();

            entity.Property(e => e.IsActive).HasDefaultValue(true);

            entity.HasOne(d => d.Game).WithMany(p => p.GamePlayers)
                .HasForeignKey(d => d.GameId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GamePlayers_Games");

            entity.HasOne(d => d.User).WithMany(p => p.GamePlayers)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GamePlayers_Users");
        });

        modelBuilder.Entity<GameRound>(entity =>
        {
            entity.Property(e => e.CurrentState).HasMaxLength(20);
            entity.Property(e => e.EndTime).HasColumnType("datetime");
            entity.Property(e => e.StartTime)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Game).WithMany(p => p.GameRounds)
                .HasForeignKey(d => d.GameId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GameRounds_Games");
        });

        modelBuilder.Entity<GameRoundWinner>(entity =>
        {
            entity.HasOne(d => d.GameRound).WithMany(p => p.GameRoundWinners)
                .HasForeignKey(d => d.GameRoundId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GameRoundWinners_GameRounds");

            entity.HasOne(d => d.User).WithMany(p => p.GameRoundWinners)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GameRoundWinners_Users");
        });

        modelBuilder.Entity<LeaderboardView>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("LeaderboardView");

            entity.Property(e => e.AvatarImage).HasMaxLength(255);
            entity.Property(e => e.UserId).ValueGeneratedOnAdd();
            entity.Property(e => e.Username).HasMaxLength(50);
        });

        modelBuilder.Entity<Model>(entity =>
        {
            entity.HasIndex(e => e.Name, "UQ_Models_Name").IsUnique();

            entity.Property(e => e.Difficulty).HasMaxLength(100);
            entity.Property(e => e.Name).HasMaxLength(100);
            entity.Property(e => e.Path).HasMaxLength(255);
        });

        modelBuilder.Entity<Move>(entity =>
        {
            entity.HasIndex(e => e.PlayerId, "IX_Moves_PlayerId");

            entity.Property(e => e.ActionType).HasMaxLength(20);
            entity.Property(e => e.MoveTime)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Round).HasMaxLength(20);

            entity.HasOne(d => d.GameRound).WithMany(p => p.Moves)
                .HasForeignKey(d => d.GameRoundId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Moves_GameRounds");

            entity.HasOne(d => d.Player).WithMany(p => p.Moves)
                .HasForeignKey(d => d.PlayerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Moves_Users");
        });

        modelBuilder.Entity<PlayerCard>(entity =>
        {
            entity.HasIndex(e => new { e.GameRoundId, e.GamePlayerId, e.Position }, "UQ_PlayerCards_GamePlayerPosition").IsUnique();

            entity.HasOne(d => d.Card).WithMany(p => p.PlayerCards)
                .HasForeignKey(d => d.CardId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PlayerCards_Cards");

            entity.HasOne(d => d.GamePlayer).WithMany(p => p.PlayerCards)
                .HasForeignKey(d => d.GamePlayerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PlayerCards_GamePlayers");

            entity.HasOne(d => d.GameRound).WithMany(p => p.PlayerCards)
                .HasForeignKey(d => d.GameRoundId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PlayerCards_GameRounds");

            entity.HasOne(d => d.User).WithMany(p => p.PlayerCards)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PlayerCards_Users");
        });

        modelBuilder.Entity<PokerTable>(entity =>
        {
            entity.HasKey(e => e.TableId);

            entity.Property(e => e.DifficultyLevel).HasMaxLength(20);
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.MaxPlayers).HasDefaultValue(4);
            entity.Property(e => e.Name).HasMaxLength(50);
        });

        modelBuilder.Entity<Purchase>(entity =>
        {
            entity.HasIndex(e => e.UserId, "IX_Purchases_UserId");

            entity.Property(e => e.PaymentMethod).HasMaxLength(50);
            entity.Property(e => e.Price).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.PurchaseDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.TransactionId).HasMaxLength(100);

            entity.HasOne(d => d.Item).WithMany(p => p.Purchases)
                .HasForeignKey(d => d.ItemId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Purchases_ShopItems");

            entity.HasOne(d => d.User).WithMany(p => p.Purchases)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Purchases_Users");
        });

        modelBuilder.Entity<ShopItem>(entity =>
        {
            entity.HasKey(e => e.ItemId);

            entity.Property(e => e.Currency)
                .HasMaxLength(10)
                .HasDefaultValue("PLN");
            entity.Property(e => e.Description).HasMaxLength(500);
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.ItemType).HasMaxLength(50);
            entity.Property(e => e.Name).HasMaxLength(100);
            entity.Property(e => e.Price).HasColumnType("decimal(10, 2)");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasIndex(e => e.Email, "UQ_Users_Email").IsUnique();

            entity.HasIndex(e => e.Username, "UQ_Users_Username").IsUnique();

            entity.Property(e => e.AvatarImage).HasMaxLength(255);
            entity.Property(e => e.AvatarType)
                .HasMaxLength(20)
                .HasDefaultValue("Standard");
            entity.Property(e => e.ChipsBalance).HasDefaultValue(5000);
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.IsBot).HasDefaultValue(false);
            entity.Property(e => e.LastLoginDate).HasColumnType("datetime");
            entity.Property(e => e.PasswordHash).HasMaxLength(128);
            entity.Property(e => e.RegistrationDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Username).HasMaxLength(50);
        });

        modelBuilder.Entity<UserModel>(entity =>
        {
            entity.HasOne(d => d.Model).WithMany(p => p.UserModels)
                .HasForeignKey(d => d.ModelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UserModels_Models");

            entity.HasOne(d => d.User).WithMany(p => p.UserModels)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UserModels_Users");
        });


        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);

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
