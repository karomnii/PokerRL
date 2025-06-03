using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TexasHoldemPoker.API.Migrations
{
    /// <inheritdoc />
    public partial class SeedInitialData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Cards (52 cards)
            migrationBuilder.Sql(@"
            INSERT INTO Cards (Suit, Value) VALUES
            ('Hearts', '2'), ('Hearts', '3'), ('Hearts', '4'), ('Hearts', '5'), ('Hearts', '6'), 
            ('Hearts', '7'), ('Hearts', '8'), ('Hearts', '9'), ('Hearts', '10'), ('Hearts', 'J'), 
            ('Hearts', 'Q'), ('Hearts', 'K'), ('Hearts', 'A'),
            ('Diamonds', '2'), ('Diamonds', '3'), ('Diamonds', '4'), ('Diamonds', '5'), 
            ('Diamonds', '6'), ('Diamonds', '7'), ('Diamonds', '8'), ('Diamonds', '9'), 
            ('Diamonds', '10'), ('Diamonds', 'J'), ('Diamonds', 'Q'), ('Diamonds', 'K'), ('Diamonds', 'A'),
            ('Clubs', '2'), ('Clubs', '3'), ('Clubs', '4'), ('Clubs', '5'), ('Clubs', '6'), 
            ('Clubs', '7'), ('Clubs', '8'), ('Clubs', '9'), ('Clubs', '10'), ('Clubs', 'J'), 
            ('Clubs', 'Q'), ('Clubs', 'K'), ('Clubs', 'A'),
            ('Spades', '2'), ('Spades', '3'), ('Spades', '4'), ('Spades', '5'), ('Spades', '6'), 
            ('Spades', '7'), ('Spades', '8'), ('Spades', '9'), ('Spades', '10'), ('Spades', 'J'), 
            ('Spades', 'Q'), ('Spades', 'K'), ('Spades', 'A');
        ");
            // PokerTables
            migrationBuilder.Sql(@"
            INSERT INTO PokerTables (Name, EntryFee, MinBuyIn, MaxBuyIn, SmallBlind, BigBlind, MaxPlayers, DifficultyLevel, IsActive) VALUES
            ('Beginner Table', 100, 500, 1000, 10, 20, 4, 'Beginner', 1),
            ('Intermediate Table', 500, 1000, 5000, 50, 100, 4, 'Intermediate', 1),
            ('Pro Table', 1000, 5000, 10000, 100, 200, 4, 'Pro', 1);
        ");
            // ShopItems
            migrationBuilder.Sql(@"
            INSERT INTO ShopItems (Name, Description, Price, ItemType, IsActive, Currency) VALUES 
            ('Basic Chips Pack', 'Get 1000 chips.', 4.99, 'Chips', 1, 'PLN'),
            ('Premium Chips Pack', 'Get 5000 chips.', 19.99, 'Chips', 1, 'PLN'),
            ('Golden Avatar', 'Unlock a golden avatar.', 9.99, 'Avatar', 1, 'PLN'),
            ('Luxury Card Deck', 'Upgrade your card deck to a luxury theme.', 14.99, 'CardDeck', 1, 'CHIPS'),
            ('Premium', 'Unlock a premium avatar for your profile.', 9.99, 'Avatar', 1, 'PLN'),
            ('Pro', 'Unlock a pro avatar for your profile.', 14.99, 'Avatar', 1, 'PLN'),
            ('Ultra', 'Unlock an ultra avatar for your profile.', 19.99, 'Avatar', 1, 'CHIPS');
        ");
            // Models
            migrationBuilder.Sql(@"
            INSERT INTO Models (Name, Path, Difficulty) VALUES
            ('First', 'dqn_model.onnx', 'Easy');
        ");

            // Users (Bots)
            migrationBuilder.Sql(@"
            INSERT INTO Users (Username, Email, PasswordHash, ChipsBalance, IsBot) VALUES
            ('Bot_Adam', 'email1', 'password', 2147483647, 1),
            ('Bot_Michal', 'email2', 'password', 2147483647, 1),
            ('Bot_Eva', 'email3', 'password', 2147483647, 1);
        ");

            // UserModels (Assume UserId 1-3 and ModelId 1 exist)
            migrationBuilder.Sql(@"
            INSERT INTO UserModels (UserId, ModelId) VALUES
            (1, 1),
            (2, 1),
            (3, 1);
        ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Delete in reverse order of insertion
            migrationBuilder.Sql("DELETE FROM UserModels;");
            migrationBuilder.Sql("DELETE FROM Users WHERE IsBot = 1;");
            migrationBuilder.Sql("DELETE FROM Models;");
            migrationBuilder.Sql("DELETE FROM ShopItems;");
            migrationBuilder.Sql("DELETE FROM PokerTables;");
            migrationBuilder.Sql("DELETE FROM Cards;");
        }
    }
}
