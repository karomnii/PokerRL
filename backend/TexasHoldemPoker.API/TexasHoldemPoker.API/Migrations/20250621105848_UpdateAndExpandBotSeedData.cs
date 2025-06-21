using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TexasHoldemPoker.API.Migrations
{
    public partial class UpdateAndExpandBotSeedData : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'");

            migrationBuilder.Sql("DELETE FROM [GameRoundWinners];");
            migrationBuilder.Sql("DELETE FROM [CommunityCards];");
            migrationBuilder.Sql("DELETE FROM [PlayerCards];");
            migrationBuilder.Sql("DELETE FROM [Moves];");
            migrationBuilder.Sql("DELETE FROM [GameRounds];");
            migrationBuilder.Sql("DELETE FROM [GamePlayers];");
            migrationBuilder.Sql("DELETE FROM [Games];");
            migrationBuilder.Sql("DELETE FROM [Purchases];");
            migrationBuilder.Sql("DELETE FROM [ChipTransactions];");
            migrationBuilder.Sql("DELETE FROM [UserModels];");
            migrationBuilder.Sql("DELETE FROM [Models];");
            migrationBuilder.Sql("DELETE FROM [Users];");
            migrationBuilder.Sql("DELETE FROM [ShopItems];");
            migrationBuilder.Sql("DELETE FROM [PokerTables];");
            migrationBuilder.Sql("DELETE FROM [Cards];");

            migrationBuilder.Sql("DBCC CHECKIDENT ('GameRoundWinners', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('CommunityCards', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('PlayerCards', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('Moves', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('GameRounds', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('GamePlayers', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('Games', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('Purchases', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('ChipTransactions', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('UserModels', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('Models', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('Users', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('ShopItems', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('PokerTables', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('Cards', RESEED, 0);");

            migrationBuilder.Sql("EXEC sp_msforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all'");

            migrationBuilder.Sql(@"
                INSERT INTO Cards (Suit, Value) VALUES
                ('Hearts', '2'), ('Hearts', '3'), ('Hearts', '4'), ('Hearts', '5'), ('Hearts', '6'), ('Hearts', '7'), ('Hearts', '8'), ('Hearts', '9'), ('Hearts', '10'), ('Hearts', 'J'), ('Hearts', 'Q'), ('Hearts', 'K'), ('Hearts', 'A'),
                ('Diamonds', '2'), ('Diamonds', '3'), ('Diamonds', '4'), ('Diamonds', '5'), ('Diamonds', '6'), ('Diamonds', '7'), ('Diamonds', '8'), ('Diamonds', '9'), ('Diamonds', '10'), ('Diamonds', 'J'), ('Diamonds', 'Q'), ('Diamonds', 'K'), ('Diamonds', 'A'),
                ('Clubs', '2'), ('Clubs', '3'), ('Clubs', '4'), ('Clubs', '5'), ('Clubs', '6'), ('Clubs', '7'), ('Clubs', '8'), ('Clubs', '9'), ('Clubs', '10'), ('Clubs', 'J'), ('Clubs', 'Q'), ('Clubs', 'K'), ('Clubs', 'A'),
                ('Spades', '2'), ('Spades', '3'), ('Spades', '4'), ('Spades', '5'), ('Spades', '6'), ('Spades', '7'), ('Spades', '8'), ('Spades', '9'), ('Spades', '10'), ('Spades', 'J'), ('Spades', 'Q'), ('Spades', 'K'), ('Spades', 'A');

                INSERT INTO PokerTables (Name, EntryFee, MinBuyIn, MaxBuyIn, SmallBlind, BigBlind, MaxPlayers, DifficultyLevel, IsActive) VALUES
                ('Beginner Table', 100, 500, 1000, 10, 20, 4, 'Beginner', 1),
                ('Intermediate Table', 500, 1000, 5000, 50, 100, 4, 'Intermediate', 1),
                ('Pro Table', 1000, 5000, 10000, 100, 200, 4, 'Pro', 1);

                INSERT INTO ShopItems (Name, Description, Price, ItemType, IsActive, Currency) VALUES 
                ('Basic Chips Pack', 'Get 1000 chips.', 4.99, 'Chips', 1, 'PLN'),
                ('Premium Chips Pack', 'Get 5000 chips.', 19.99, 'Chips', 1, 'PLN'),
                ('Golden Avatar', 'Unlock a golden avatar.', 9.99, 'Avatar', 1, 'PLN'),
                ('Luxury Card Deck', 'Upgrade your card deck to a luxury theme.', 14.99, 'CardDeck', 1, 'CHIPS'),
                ('Premium', 'Unlock a premium avatar for your profile.', 9.99, 'Avatar', 1, 'PLN'),
                ('Pro', 'Unlock a pro avatar for your profile.', 14.99, 'Avatar', 1, 'PLN'),
                ('Ultra', 'Unlock an ultra avatar for your profile.', 19.99, 'Avatar', 1, 'CHIPS');

                INSERT INTO Models (Name, Path, Difficulty) VALUES
                ('Stupid', 'dqn_model.onnx', 'Easy'),
                ('Aggressive', 'harmful.onnx', 'Medium'),
                ('Careful', 'harmless.onnx', 'Hard');

                INSERT INTO Users(Username, Email, PasswordHash, ChipsBalance, IsBot) VALUES
                ('Bot_Adam', 'email1', 'password', 2147483647, 1),
                ('Bot_Michal', 'email2', 'password', 2147483647, 1),
                ('Bot_Eva', 'email3', 'password', 2147483647, 1),
                ('Bot_Elizabeth', 'email4', 'password', 2147483647, 1),
                ('Bot_William', 'email5', 'password', 2147483647, 1),
                ('Bot_Olivia', 'email6', 'password', 2147483647, 1),
                ('Bot_Alice', 'email7', 'password', 2147483647, 1),
                ('Bot_Grace', 'email8', 'password', 2147483647, 1),
                ('Bot_Jack', 'email9', 'password', 2147483647, 1);

                INSERT INTO UserModels (UserId, ModelId) VALUES
                (1,1),
                (2,1),
                (3,1),
                (4,2),
                (5,2),
                (6,2),
                (7,3),
                (8,3),
                (9,3);
            ");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            
            migrationBuilder.Sql("EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'");

            migrationBuilder.Sql("DELETE FROM [GameRoundWinners];");
            migrationBuilder.Sql("DELETE FROM [CommunityCards];");
            migrationBuilder.Sql("DELETE FROM [PlayerCards];");
            migrationBuilder.Sql("DELETE FROM [Moves];");
            migrationBuilder.Sql("DELETE FROM [GameRounds];");
            migrationBuilder.Sql("DELETE FROM [GamePlayers];");
            migrationBuilder.Sql("DELETE FROM [Games];");
            migrationBuilder.Sql("DELETE FROM [Purchases];");
            migrationBuilder.Sql("DELETE FROM [ChipTransactions];");
            migrationBuilder.Sql("DELETE FROM [UserModels];");
            migrationBuilder.Sql("DELETE FROM [Models];");
            migrationBuilder.Sql("DELETE FROM [Users];");
            migrationBuilder.Sql("DELETE FROM [ShopItems];");
            migrationBuilder.Sql("DELETE FROM [PokerTables];");
            migrationBuilder.Sql("DELETE FROM [Cards];");

            migrationBuilder.Sql("DBCC CHECKIDENT ('GameRoundWinners', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('CommunityCards', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('PlayerCards', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('Moves', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('GameRounds', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('GamePlayers', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('Games', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('Purchases', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('ChipTransactions', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('UserModels', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('Models', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('Users', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('ShopItems', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('PokerTables', RESEED, 0);");
            migrationBuilder.Sql("DBCC CHECKIDENT ('Cards', RESEED, 0);");

            migrationBuilder.Sql("EXEC sp_msforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all'");

            migrationBuilder.Sql(@"
                INSERT INTO Cards (Suit, Value) VALUES
                ('Hearts', '2'), ('Hearts', '3'), ('Hearts', '4'), ('Hearts', '5'), ('Hearts', '6'), ('Hearts', '7'), ('Hearts', '8'), ('Hearts', '9'), ('Hearts', '10'), ('Hearts', 'J'), ('Hearts', 'Q'), ('Hearts', 'K'), ('Hearts', 'A'),
                ('Diamonds', '2'), ('Diamonds', '3'), ('Diamonds', '4'), ('Diamonds', '5'), ('Diamonds', '6'), ('Diamonds', '7'), ('Diamonds', '8'), ('Diamonds', '9'), ('Diamonds', '10'), ('Diamonds', 'J'), ('Diamonds', 'Q'), ('Diamonds', 'K'), ('Diamonds', 'A'),
                ('Clubs', '2'), ('Clubs', '3'), ('Clubs', '4'), ('Clubs', '5'), ('Clubs', '6'), ('Clubs', '7'), ('Clubs', '8'), ('Clubs', '9'), ('Clubs', '10'), ('Clubs', 'J'), ('Clubs', 'Q'), ('Clubs', 'K'), ('Clubs', 'A'),
                ('Spades', '2'), ('Spades', '3'), ('Spades', '4'), ('Spades', '5'), ('Spades', '6'), ('Spades', '7'), ('Spades', '8'), ('Spades', '9'), ('Spades', '10'), ('Spades', 'J'), ('Spades', 'Q'), ('Spades', 'K'), ('Spades', 'A');

                INSERT INTO PokerTables (Name, EntryFee, MinBuyIn, MaxBuyIn, SmallBlind, BigBlind, MaxPlayers, DifficultyLevel, IsActive) VALUES
                ('Beginner Table', 100, 500, 1000, 10, 20, 4, 'Beginner', 1),
                ('Intermediate Table', 500, 1000, 5000, 50, 100, 4, 'Intermediate', 1),
                ('Pro Table', 1000, 5000, 10000, 100, 200, 4, 'Pro', 1);

                INSERT INTO ShopItems (Name, Description, Price, ItemType, IsActive, Currency) VALUES 
                ('Basic Chips Pack', 'Get 1000 chips.', 4.99, 'Chips', 1, 'PLN'),
                ('Premium Chips Pack', 'Get 5000 chips.', 19.99, 'Chips', 1, 'PLN'),
                ('Golden Avatar', 'Unlock a golden avatar.', 9.99, 'Avatar', 1, 'PLN'),
                ('Luxury Card Deck', 'Upgrade your card deck to a luxury theme.', 14.99, 'CardDeck', 1, 'CHIPS'),
                ('Premium', 'Unlock a premium avatar for your profile.', 9.99, 'Avatar', 1, 'PLN'),
                ('Pro', 'Unlock a pro avatar for your profile.', 14.99, 'Avatar', 1, 'PLN'),
                ('Ultra', 'Unlock an ultra avatar for your profile.', 19.99, 'Avatar', 1, 'CHIPS');

                INSERT INTO Models (Name, Path, Difficulty) VALUES
                ('First', 'dqn_model.onnx', 'Easy');

                INSERT INTO Users(Username, Email, PasswordHash, ChipsBalance, IsBot) VALUES
                ('Bot_Adam', 'email1', 'password', 2147483647, 1),
                ('Bot_Michal', 'email2', 'password', 2147483647, 1),
                ('Bot_Eva', 'email3', 'password', 2147483647, 1);

                INSERT INTO UserModels (UserId, ModelId) VALUES
                (1,1),
                (2,1),
                (3,1);
            ");
        }
    }
}
