USE master;
GO
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
    UserId INT IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    PasswordHash NVARCHAR(128) NOT NULL,
    ChipsBalance INT NOT NULL DEFAULT 5000,
    AvatarImage NVARCHAR(255),
    RegistrationDate DATETIME NOT NULL DEFAULT GETDATE(),
    LastLoginDate DATETIME,
    IsActive BIT NOT NULL DEFAULT 1,
	IsBot BIT DEFAULT 0
);
GO

-- Models Table
CREATE TABLE Models (
    ModelId INT IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Path NVARCHAR(255) NULL,
	Difficulty NVARCHAR(100) NULL
);
GO

-- UserModels Table
CREATE TABLE UserModels (
    UserModelId INT IDENTITY(1,1),
    UserId INT NOT NULL,
	ModelId INT NOT NULL
);
GO

-- PokerTables Table
CREATE TABLE PokerTables (
    TableId INT IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL,
    EntryFee INT NOT NULL,
    MinBuyIn INT NOT NULL,
    MaxBuyIn INT NOT NULL,
    SmallBlind INT NOT NULL,
    BigBlind INT NOT NULL,
    MaxPlayers INT NOT NULL DEFAULT 4,
    DifficultyLevel NVARCHAR(20),
    IsActive BIT NOT NULL DEFAULT 1
);
GO

-- Games Table
CREATE TABLE Games (
    GameId INT IDENTITY(1,1),
    TableId INT NOT NULL,
    StartTime DATETIME NOT NULL DEFAULT GETDATE(),
    EndTime DATETIME,
    CurrentTurnPlayerId INT NULL,
    PotSize INT NOT NULL DEFAULT 0
);
GO

-- GameRounds Table
CREATE TABLE GameRounds (
    GameRoundId INT IDENTITY(1,1),
    GameId INT NOT NULL,
    RoundNumber INT NOT NULL,
	CurrentState NVARCHAR(20) NOT NULL,
    StartTime DATETIME NOT NULL DEFAULT GETDATE(),
    EndTime DATETIME,
    PotSize INT NOT NULL DEFAULT 0
);
GO

-- GameRoundWinners Table
CREATE TABLE GameRoundWinners (
    GameRoundWinnerId INT IDENTITY(1,1),
    GameRoundId INT NOT NULL,
    UserId INT NOT NULL,
    AmountWon INT NOT NULL
);
GO

-- GamePlayers Table
CREATE TABLE GamePlayers (
    GamePlayerId INT IDENTITY(1,1),
    GameId INT NOT NULL,
    UserId INT NOT NULL,
    SeatPosition INT NOT NULL,
    InitialChips INT NOT NULL,
    CurrentChips INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    IsDealer BIT NOT NULL DEFAULT 0,
    IsSmallBlind BIT NOT NULL DEFAULT 0,
    IsBigBlind BIT NOT NULL DEFAULT 0
);
GO

-- Cards Table
CREATE TABLE Cards (
    CardId INT IDENTITY(1,1),
    Suit NVARCHAR(10) NOT NULL,
    Value NVARCHAR(5) NOT NULL
);
GO

-- CommunityCards Table
CREATE TABLE CommunityCards (
    CommunityCardId INT IDENTITY(1,1),
    GameRoundId INT NOT NULL,
    CardId INT NOT NULL,
    Position INT NOT NULL
);
GO

-- PlayerCards Table
CREATE TABLE PlayerCards (
    PlayerCardId INT IDENTITY(1,1),
    GamePlayerId INT NOT NULL,
	UserId INT NOT NULL,
	GameRoundId INT NOT NULL,
    CardId INT NOT NULL,
    Position INT NOT NULL
);
GO

-- Moves Table
CREATE TABLE Moves (
    MoveId INT IDENTITY(1,1),
    GameRoundId INT NOT NULL,
    PlayerId INT NOT NULL,
    ActionType NVARCHAR(20) NOT NULL,
    Amount INT NOT NULL DEFAULT 0,
    MoveTime DATETIME NOT NULL DEFAULT GETDATE(),
    Round NVARCHAR(20) NOT NULL
);
GO

-- ShopItems Table
CREATE TABLE ShopItems (
    ItemId INT IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    Price DECIMAL(10, 2) NOT NULL,
    ItemType NVARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
GO

-- Purchases Table
CREATE TABLE Purchases (
    PurchaseId INT IDENTITY(1,1),
    UserId INT NOT NULL,
    ItemId INT NOT NULL,
    PurchaseDate DATETIME NOT NULL DEFAULT GETDATE(),
    Price DECIMAL(10, 2) NOT NULL,
    PaymentMethod NVARCHAR(50),
    TransactionId NVARCHAR(100)
);
GO

-- ChipTransactions Table
CREATE TABLE ChipTransactions (
    TransactionId INT IDENTITY(1,1),
    UserId INT NOT NULL,
    Amount INT NOT NULL,
    TransactionType NVARCHAR(50) NOT NULL,
    ReferenceId INT,
    TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
    Description NVARCHAR(255)
);
GO

-- Primary Key Constraints
ALTER TABLE Users ADD CONSTRAINT PK_Users PRIMARY KEY (UserId);
ALTER TABLE Models ADD CONSTRAINT PK_Models PRIMARY KEY (ModelId);
ALTER TABLE UserModels ADD CONSTRAINT PK_UserModels PRIMARY KEY (UserModelId);
ALTER TABLE PokerTables ADD CONSTRAINT PK_PokerTables PRIMARY KEY (TableId);
ALTER TABLE Games ADD CONSTRAINT PK_Games PRIMARY KEY (GameId);
ALTER TABLE GameRounds ADD CONSTRAINT PK_GameRounds PRIMARY KEY (GameRoundId);
ALTER TABLE GameRoundWinners ADD CONSTRAINT PK_GameRoundWinners PRIMARY KEY (GameRoundWinnerId);
ALTER TABLE GamePlayers ADD CONSTRAINT PK_GamePlayers PRIMARY KEY (GamePlayerId);
ALTER TABLE Cards ADD CONSTRAINT PK_Cards PRIMARY KEY (CardId);
ALTER TABLE CommunityCards ADD CONSTRAINT PK_CommunityCards PRIMARY KEY (CommunityCardId);
ALTER TABLE PlayerCards ADD CONSTRAINT PK_PlayerCards PRIMARY KEY (PlayerCardId);
ALTER TABLE Moves ADD CONSTRAINT PK_Moves PRIMARY KEY (MoveId);
ALTER TABLE ShopItems ADD CONSTRAINT PK_ShopItems PRIMARY KEY (ItemId);
ALTER TABLE Purchases ADD CONSTRAINT PK_Purchases PRIMARY KEY (PurchaseId);
ALTER TABLE ChipTransactions ADD CONSTRAINT PK_ChipTransactions PRIMARY KEY (TransactionId);

-- Foreign Key Constraints
ALTER TABLE UserModels ADD CONSTRAINT FK_UserModels_Users FOREIGN KEY (UserId) REFERENCES Users(UserId);
ALTER TABLE UserModels ADD CONSTRAINT FK_UserModels_Models FOREIGN KEY (ModelId) REFERENCES Models(ModelId);
ALTER TABLE Games ADD CONSTRAINT FK_Games_PokerTables FOREIGN KEY (TableId) REFERENCES PokerTables(TableId);
ALTER TABLE Games ADD CONSTRAINT FK_Games_GamePlayers FOREIGN KEY (CurrentTurnPlayerId) REFERENCES GamePlayers(GamePlayerId);
ALTER TABLE GameRounds ADD CONSTRAINT FK_GameRounds_Games FOREIGN KEY (GameId) REFERENCES Games(GameId);
ALTER TABLE GameRoundWinners ADD CONSTRAINT FK_GameRoundWinners_GameRounds FOREIGN KEY (GameRoundId) REFERENCES GameRounds(GameRoundId);
ALTER TABLE GameRoundWinners ADD CONSTRAINT FK_GameRoundWinners_Users FOREIGN KEY (UserId) REFERENCES Users(UserId);
ALTER TABLE GamePlayers ADD CONSTRAINT FK_GamePlayers_Games FOREIGN KEY (GameId) REFERENCES Games(GameId);
ALTER TABLE GamePlayers ADD CONSTRAINT FK_GamePlayers_Users FOREIGN KEY (UserId) REFERENCES Users(UserId);
ALTER TABLE CommunityCards ADD CONSTRAINT FK_CommunityCards_GameRounds FOREIGN KEY (GameRoundId) REFERENCES GameRounds(GameRoundId);
ALTER TABLE CommunityCards ADD CONSTRAINT FK_CommunityCards_Cards FOREIGN KEY (CardId) REFERENCES Cards(CardId);
ALTER TABLE PlayerCards ADD CONSTRAINT FK_PlayerCards_GamePlayers FOREIGN KEY (GamePlayerId) REFERENCES GamePlayers(GamePlayerId);
ALTER TABLE PlayerCards ADD CONSTRAINT FK_PlayerCards_GameRounds FOREIGN KEY (GameRoundId) REFERENCES GameRounds(GameRoundId);
ALTER TABLE PlayerCards ADD CONSTRAINT FK_PlayerCards_Users FOREIGN KEY (UserId) REFERENCES Users(UserId);
ALTER TABLE PlayerCards ADD CONSTRAINT FK_PlayerCards_Cards FOREIGN KEY (CardId) REFERENCES Cards(CardId);
ALTER TABLE Moves ADD CONSTRAINT FK_Moves_GameRounds FOREIGN KEY (GameRoundId) REFERENCES GameRounds(GameRoundId);
ALTER TABLE Moves ADD CONSTRAINT FK_Moves_Users FOREIGN KEY (PlayerId) REFERENCES Users(UserId);
ALTER TABLE Purchases ADD CONSTRAINT FK_Purchases_Users FOREIGN KEY (UserId) REFERENCES Users(UserId);
ALTER TABLE Purchases ADD CONSTRAINT FK_Purchases_ShopItems FOREIGN KEY (ItemId) REFERENCES ShopItems(ItemId);
ALTER TABLE ChipTransactions ADD CONSTRAINT FK_ChipTransactions_Users FOREIGN KEY (UserId) REFERENCES Users(UserId);

-- Unique Constraints
ALTER TABLE Users ADD CONSTRAINT UQ_Users_Username UNIQUE (Username);
ALTER TABLE Users ADD CONSTRAINT UQ_Users_Email UNIQUE (Email);
ALTER TABLE Models ADD CONSTRAINT UQ_Models_Name UNIQUE (Name);
ALTER TABLE GamePlayers ADD CONSTRAINT UQ_GamePlayers_GameUser UNIQUE (GameId, UserId);
ALTER TABLE GamePlayers ADD CONSTRAINT UQ_GamePlayers_GamePosition UNIQUE (GameId, SeatPosition);
ALTER TABLE CommunityCards ADD CONSTRAINT UQ_CommunityCards_GamePosition UNIQUE (GameRoundId, Position);
ALTER TABLE PlayerCards ADD CONSTRAINT UQ_PlayerCards_GamePlayerPosition UNIQUE (GameRoundId, GamePlayerId, Position);

-- Check Constraints
ALTER TABLE GameRounds ADD CONSTRAINT CK_GameRounds_CurrentState CHECK (CurrentState IN ('Waiting', 'PreFlop', 'Flop', 'Turn', 'River', 'Showdown', 'Completed'));
ALTER TABLE Cards ADD CONSTRAINT CK_Cards_Suit CHECK (Suit IN ('Hearts', 'Diamonds', 'Clubs', 'Spades'));
ALTER TABLE Cards ADD CONSTRAINT CK_Cards_Value CHECK (Value IN ('2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'));
ALTER TABLE CommunityCards ADD CONSTRAINT CK_CommunityCards_Position CHECK (Position BETWEEN 1 AND 5);
ALTER TABLE PlayerCards ADD CONSTRAINT CK_PlayerCards_Position CHECK (Position IN (1, 2));
ALTER TABLE Moves ADD CONSTRAINT CK_Moves_ActionType CHECK (ActionType IN ('Fold', 'Check', 'Call', 'Bet', 'Raise', 'AllIn', 'Blind'));
ALTER TABLE Moves ADD CONSTRAINT CK_Moves_Round CHECK (Round IN ('PreFlop', 'Flop', 'Turn', 'River'));
ALTER TABLE ShopItems ADD CONSTRAINT CK_ShopItems_ItemType CHECK (ItemType IN ('Chips', 'Avatar', 'TableTheme', 'CardDeck', 'Emote'));
ALTER TABLE ChipTransactions ADD CONSTRAINT CK_ChipTransactions_TransactionType CHECK (TransactionType IN ('Purchase', 'GameWin', 'GameLoss', 'Bonus', 'Gift', 'Refund'));

-- Indexes
CREATE INDEX IXGamesTableId ON Games(TableId);
CREATE INDEX IXGamePlayersGameId ON GamePlayers(GameId);
CREATE INDEX IXGamePlayersUserId ON GamePlayers(UserId);
CREATE INDEX IXMovesGameId ON Moves(GameRoundId);
CREATE INDEX IXMovesPlayerId ON Moves(PlayerId);
CREATE INDEX IXPurchasesUserId ON Purchases(UserId);
CREATE INDEX IXChipTransactionsUserId ON ChipTransactions(UserId);
CREATE INDEX IXGameRoundWinnersGameRoundId ON GameRoundWinners(GameRoundId);
CREATE INDEX IXGameRoundWinnersUserId ON GameRoundWinners(UserId);
GO

-- Leaderboard View
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

ALTER TABLE PlayerCards ADD UserId INT NOT NULL; 