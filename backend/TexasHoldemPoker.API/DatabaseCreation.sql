-- Drop and recreate database for development
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'TexasHoldemPoker')
BEGIN
    ALTER DATABASE TexasHoldemPoker SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TexasHoldemPoker;
END
GO
CREATE DATABASE TexasHoldemPoker;
GO
USE TexasHoldemPoker;
GO

-- Users Table
CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(128) NOT NULL,
    ChipsBalance INT NOT NULL DEFAULT 1000,
    AvatarImage NVARCHAR(255),
    RegistrationDate DATETIME NOT NULL DEFAULT GETDATE(),
    LastLoginDate DATETIME,
    IsActive BIT NOT NULL DEFAULT 1
);
GO

-- PokerTables Table
CREATE TABLE PokerTables (
    TableId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    EntryFee INT NOT NULL,
    MinBuyIn INT NOT NULL,
    MaxBuyIn INT NOT NULL,
    SmallBlind INT NOT NULL,
    BigBlind INT NOT NULL,
    MaxPlayers INT NOT NULL DEFAULT 9,
    DifficultyLevel NVARCHAR(20) CHECK (DifficultyLevel IN ('Beginner', 'Intermediate', 'Advanced', 'Pro')),
    IsActive BIT NOT NULL DEFAULT 1
);
GO

-- Games Table
CREATE TABLE Games (
    GameId INT IDENTITY(1,1) PRIMARY KEY,
    TableId INT NOT NULL FOREIGN KEY REFERENCES PokerTables(TableId),
    StartTime DATETIME NOT NULL DEFAULT GETDATE(),
    EndTime DATETIME,
    CurrentState NVARCHAR(20) NOT NULL CHECK (CurrentState IN ('Waiting', 'PreFlop', 'Flop', 'Turn', 'River', 'Showdown', 'Completed')),
    CurrentTurnUserId INT NULL,
    PotSize INT NOT NULL DEFAULT 0,
    CONSTRAINT FKGamesTables FOREIGN KEY (TableId) REFERENCES PokerTables(TableId),
    CONSTRAINT FKGamesCurrentTurnUser FOREIGN KEY (CurrentTurnUserId) REFERENCES Users(UserId)
);
GO

-- GameRounds Table
CREATE TABLE GameRounds (
    GameRoundId INT IDENTITY(1,1) PRIMARY KEY,
    GameId INT NOT NULL FOREIGN KEY REFERENCES Games(GameId),
    RoundNumber INT NOT NULL,
    StartTime DATETIME NOT NULL DEFAULT GETDATE(),
    EndTime DATETIME,
    PotSize INT NOT NULL DEFAULT 0
);
GO

-- GameRoundWinners Table
CREATE TABLE GameRoundWinners (
    GameRoundWinnerId INT IDENTITY(1,1) PRIMARY KEY,
    GameRoundId INT NOT NULL FOREIGN KEY REFERENCES GameRounds(GameRoundId),
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId),
    AmountWon INT NOT NULL
);
GO

-- GamePlayers Table
CREATE TABLE GamePlayers (
    GamePlayerId INT IDENTITY(1,1) PRIMARY KEY,
    GameId INT NOT NULL,
    UserId INT NOT NULL,
    SeatPosition INT NOT NULL,
    InitialChips INT NOT NULL,
    CurrentChips INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    IsDealer BIT NOT NULL DEFAULT 0,
    IsSmallBlind BIT NOT NULL DEFAULT 0,
    IsBigBlind BIT NOT NULL DEFAULT 0,
    CONSTRAINT FKGamePlayersGames FOREIGN KEY (GameId) REFERENCES Games(GameId),
    CONSTRAINT FKGamePlayersUsers FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT UQGamePlayersGameUser UNIQUE (GameId, UserId),
    CONSTRAINT UQGamePlayersGamePosition UNIQUE (GameId, SeatPosition)
);
GO

-- Cards Table
CREATE TABLE Cards (
    CardId INT IDENTITY(1,1) PRIMARY KEY,
    Suit NVARCHAR(10) NOT NULL CHECK (Suit IN ('Hearts', 'Diamonds', 'Clubs', 'Spades')),
    Value NVARCHAR(5) NOT NULL CHECK (Value IN ('2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'))
);
GO

-- CommunityCards Table
CREATE TABLE CommunityCards (
    CommunityCardId INT IDENTITY(1,1) PRIMARY KEY,
    GameId INT NOT NULL,
    CardId INT NOT NULL,
    Position INT NOT NULL CHECK (Position BETWEEN 1 AND 5),
    CONSTRAINT FKCommunityCardsGames FOREIGN KEY (GameId) REFERENCES Games(GameId),
    CONSTRAINT FKCommunityCardsCards FOREIGN KEY (CardId) REFERENCES Cards(CardId),
    CONSTRAINT UQCommunityCardsGamePosition UNIQUE (GameId, Position)
);
GO

-- PlayerCards Table
CREATE TABLE PlayerCards (
    PlayerCardId INT IDENTITY(1,1) PRIMARY KEY,
    GamePlayerId INT NOT NULL,
    CardId INT NOT NULL,
    Position INT NOT NULL CHECK (Position IN (1, 2)),
    CONSTRAINT FKPlayerCardsGamePlayers FOREIGN KEY (GamePlayerId) REFERENCES GamePlayers(GamePlayerId),
    CONSTRAINT FKPlayerCardsCards FOREIGN KEY (CardId) REFERENCES Cards(CardId),
    CONSTRAINT UQPlayerCardsGamePlayerPosition UNIQUE (GamePlayerId, Position)
);
GO

-- Moves Table
CREATE TABLE Moves (
    MoveId INT IDENTITY(1,1) PRIMARY KEY,
    GameId INT NOT NULL,
    GameRoundId INT NOT NULL,
    PlayerId INT NOT NULL,
    ActionType NVARCHAR(20) NOT NULL CHECK (ActionType IN ('Fold', 'Check', 'Call', 'Bet', 'Raise', 'AllIn')),
    Amount INT NOT NULL DEFAULT 0,
    MoveTime DATETIME NOT NULL DEFAULT GETDATE(),
    Round NVARCHAR(20) NOT NULL CHECK (Round IN ('PreFlop', 'Flop', 'Turn', 'River')),
    CONSTRAINT FKMovesGames FOREIGN KEY (GameId) REFERENCES Games(GameId),
    CONSTRAINT FKMovesGameRounds FOREIGN KEY (GameRoundId) REFERENCES GameRounds(GameRoundId),
    CONSTRAINT FKMovesUsers FOREIGN KEY (PlayerId) REFERENCES Users(UserId)
);
GO

-- ShopItems Table
CREATE TABLE ShopItems (
    ItemId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    Price DECIMAL(10, 2) NOT NULL,
    ItemType NVARCHAR(50) NOT NULL CHECK (ItemType IN ('Chips', 'Avatar', 'TableTheme', 'CardDeck', 'Emote')),
    IsActive BIT NOT NULL DEFAULT 1
);
GO

-- Purchases Table
CREATE TABLE Purchases (
    PurchaseId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    ItemId INT NOT NULL,
    PurchaseDate DATETIME NOT NULL DEFAULT GETDATE(),
    Price DECIMAL(10, 2) NOT NULL,
    PaymentMethod NVARCHAR(50),
    TransactionId NVARCHAR(100),
    CONSTRAINT FKPurchasesUsers FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FKPurchasesShopItems FOREIGN KEY (ItemId) REFERENCES ShopItems(ItemId)
);
GO

-- ChipTransactions Table
CREATE TABLE ChipTransactions (
    TransactionId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    Amount INT NOT NULL,
    TransactionType NVARCHAR(50) NOT NULL CHECK (TransactionType IN ('Purchase', 'GameWin', 'GameLoss', 'Bonus', 'Gift', 'Refund')),
    ReferenceId INT,
    TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
    Description NVARCHAR(255),
    CONSTRAINT FKChipTransactionsUsers FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
GO

-- Leaderboard View (GamesWon now needs to be updated in code to count GameRoundWinners)
CREATE VIEW LeaderboardView AS
SELECT
    u.UserId,
    u.Username,
    u.ChipsBalance,
    u.AvatarImage,
    -- GamesWon: count of rounds won
    (SELECT COUNT(*) FROM GameRoundWinners grw WHERE grw.UserId = u.UserId) AS GamesWon,
    -- GamesPlayed: count of rounds played
    (SELECT COUNT(*) FROM GamePlayers gp WHERE gp.UserId = u.UserId) AS GamesPlayed
FROM Users u
WHERE u.IsActive = 1;
GO

-- Indexes
CREATE INDEX IXGamesTableId ON Games(TableId);
CREATE INDEX IXGamePlayersGameId ON GamePlayers(GameId);
CREATE INDEX IXGamePlayersUserId ON GamePlayers(UserId);
CREATE INDEX IXMovesGameId ON Moves(GameId);
CREATE INDEX IXMovesPlayerId ON Moves(PlayerId);
CREATE INDEX IXPurchasesUserId ON Purchases(UserId);
CREATE INDEX IXChipTransactionsUserId ON ChipTransactions(UserId);
CREATE INDEX IXGameRoundWinnersGameRoundId ON GameRoundWinners(GameRoundId);
CREATE INDEX IXGameRoundWinnersUserId ON GameRoundWinners(UserId);
GO

-- Populate Cards Table
INSERT INTO Cards (Suit, Value) VALUES
('Hearts', '2'), ('Hearts', '3'), ('Hearts', '4'), ('Hearts', '5'), ('Hearts', '6'), ('Hearts', '7'), ('Hearts', '8'), ('Hearts', '9'), ('Hearts', '10'), ('Hearts', 'J'), ('Hearts', 'Q'), ('Hearts', 'K'), ('Hearts', 'A'),
('Diamonds', '2'), ('Diamonds', '3'), ('Diamonds', '4'), ('Diamonds', '5'), ('Diamonds', '6'), ('Diamonds', '7'), ('Diamonds', '8'), ('Diamonds', '9'), ('Diamonds', '10'), ('Diamonds', 'J'), ('Diamonds', 'Q'), ('Diamonds', 'K'), ('Diamonds', 'A'),
('Clubs', '2'), ('Clubs', '3'), ('Clubs', '4'), ('Clubs', '5'), ('Clubs', '6'), ('Clubs', '7'), ('Clubs', '8'), ('Clubs', '9'), ('Clubs', '10'), ('Clubs', 'J'), ('Clubs', 'Q'), ('Clubs', 'K'), ('Clubs', 'A'),
('Spades', '2'), ('Spades', '3'), ('Spades', '4'), ('Spades', '5'), ('Spades', '6'), ('Spades', '7'), ('Spades', '8'), ('Spades', '9'), ('Spades', '10'), ('Spades', 'J'), ('Spades', 'Q'), ('Spades', 'K'), ('Spades', 'A');
GO

-- Populate PokerTables Table
INSERT INTO PokerTables (Name, EntryFee, MinBuyIn, MaxBuyIn, SmallBlind, BigBlind, MaxPlayers, DifficultyLevel, IsActive) VALUES
('Beginner Table', 100, 500, 1000, 10, 20, 9, 'Beginner', 1),
('Intermediate Table', 500, 1000, 5000, 50, 100, 9, 'Intermediate', 1),
('Pro Table', 1000, 5000, 10000, 100, 200, 9, 'Pro', 1);
GO

-- Populate ShopItems Table
INSERT INTO ShopItems (Name, Description, Price, ItemType, IsActive) VALUES
('Basic Chips Pack', 'Get 1000 chips.', 4.99, 'Chips', 1),
('Premium Chips Pack', 'Get 5000 chips.', 19.99, 'Chips', 1),
('Golden Avatar', 'Unlock a golden avatar.', 9.99, 'Avatar', 1),
('Luxury Card Deck', 'Upgrade your card deck to a luxury theme.', 14.99, 'CardDeck', 1);
GO
