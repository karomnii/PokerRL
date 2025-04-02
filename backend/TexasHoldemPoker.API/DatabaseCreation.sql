-- Create database
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

-- Tables Table
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
    PotSize INT NOT NULL DEFAULT 0,
    WinnerId INT FOREIGN KEY REFERENCES Users(UserId),
    CONSTRAINT FK_Games_Tables FOREIGN KEY (TableId) REFERENCES PokerTables(TableId)
);
GO

-- GamePlayers Table (tracks players in each game and their positions)
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
    CONSTRAINT FK_GamePlayers_Games FOREIGN KEY (GameId) REFERENCES Games(GameId),
    CONSTRAINT FK_GamePlayers_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT UQ_GamePlayers_Game_User UNIQUE (GameId, UserId),
    CONSTRAINT UQ_GamePlayers_Game_Position UNIQUE (GameId, SeatPosition)
);
GO

-- Cards Table
CREATE TABLE Cards (
    CardId INT IDENTITY(1,1) PRIMARY KEY,
    Suit NVARCHAR(10) NOT NULL CHECK (Suit IN ('Hearts', 'Diamonds', 'Clubs', 'Spades')),
    Value NVARCHAR(5) NOT NULL CHECK (Value IN ('2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'))
);
GO

-- CommunityCards Table (for flop, turn, river)
CREATE TABLE CommunityCards (
    CommunityCardId INT IDENTITY(1,1) PRIMARY KEY,
    GameId INT NOT NULL,
    CardId INT NOT NULL,
    Position INT NOT NULL CHECK (Position BETWEEN 1 AND 5),
    CONSTRAINT FK_CommunityCards_Games FOREIGN KEY (GameId) REFERENCES Games(GameId),
    CONSTRAINT FK_CommunityCards_Cards FOREIGN KEY (CardId) REFERENCES Cards(CardId),
    CONSTRAINT UQ_CommunityCards_Game_Position UNIQUE (GameId, Position)
);
GO

-- PlayerCards Table (hole cards)
CREATE TABLE PlayerCards (
    PlayerCardId INT IDENTITY(1,1) PRIMARY KEY,
    GamePlayerId INT NOT NULL,
    CardId INT NOT NULL,
    Position INT NOT NULL CHECK (Position IN (1, 2)),
    CONSTRAINT FK_PlayerCards_GamePlayers FOREIGN KEY (GamePlayerId) REFERENCES GamePlayers(GamePlayerId),
    CONSTRAINT FK_PlayerCards_Cards FOREIGN KEY (CardId) REFERENCES Cards(CardId),
    CONSTRAINT UQ_PlayerCards_GamePlayer_Position UNIQUE (GamePlayerId, Position)
);
GO

-- Moves Table
CREATE TABLE Moves (
    MoveId INT IDENTITY(1,1) PRIMARY KEY,
    GameId INT NOT NULL,
    PlayerId INT NOT NULL,
    ActionType NVARCHAR(20) NOT NULL CHECK (ActionType IN ('Fold', 'Check', 'Call', 'Bet', 'Raise', 'AllIn')),
    Amount INT NOT NULL DEFAULT 0,
    MoveTime DATETIME NOT NULL DEFAULT GETDATE(),
    Round NVARCHAR(20) NOT NULL CHECK (Round IN ('PreFlop', 'Flop', 'Turn', 'River')),
    CONSTRAINT FK_Moves_Games FOREIGN KEY (GameId) REFERENCES Games(GameId),
    CONSTRAINT FK_Moves_Users FOREIGN KEY (PlayerId) REFERENCES Users(UserId)
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
    CONSTRAINT FK_Purchases_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Purchases_ShopItems FOREIGN KEY (ItemId) REFERENCES ShopItems(ItemId)
);
GO

-- ChipTransactions Table
CREATE TABLE ChipTransactions (
    TransactionId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    Amount INT NOT NULL,
    TransactionType NVARCHAR(50) NOT NULL CHECK (TransactionType IN ('Purchase', 'GameWin', 'GameLoss', 'Bonus', 'Gift', 'Refund')),
    ReferenceId INT,  -- Can reference GameId or PurchaseId depending on TransactionType
    TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
    Description NVARCHAR(255),
    CONSTRAINT FK_ChipTransactions_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
GO

-- Leaderboard View
CREATE OR ALTER VIEW LeaderboardView AS
SELECT 
    u.UserId,
    u.Username,
    u.ChipsBalance,
    u.AvatarImage,
    (SELECT COUNT(*) FROM Games WHERE WinnerId = u.UserId) AS GamesWon,
    (SELECT COUNT(*) FROM GamePlayers WHERE UserId = u.UserId) AS GamesPlayed,
    CASE 
        WHEN (SELECT COUNT(*) FROM GamePlayers WHERE UserId = u.UserId) = 0 THEN 0
        ELSE CAST((SELECT COUNT(*) FROM Games WHERE WinnerId = u.UserId) AS FLOAT) /
             CAST((SELECT COUNT(*) FROM GamePlayers WHERE UserId = u.UserId) AS FLOAT)
    END AS WinRatio
FROM Users u
WHERE u.IsActive = 1;

-- Indexes for better performance
CREATE INDEX IX_Games_TableId ON Games(TableId);
CREATE INDEX IX_Games_WinnerId ON Games(WinnerId);
CREATE INDEX IX_GamePlayers_GameId ON GamePlayers(GameId);
CREATE INDEX IX_GamePlayers_UserId ON GamePlayers(UserId);
CREATE INDEX IX_Moves_GameId ON Moves(GameId);
CREATE INDEX IX_Moves_PlayerId ON Moves(PlayerId);
CREATE INDEX IX_Purchases_UserId ON Purchases(UserId);
CREATE INDEX IX_ChipTransactions_UserId ON ChipTransactions(UserId);
GO

-- Create a new game
CREATE PROCEDURE CreateGame
    @TableId INT,
    @CurrentState NVARCHAR(20) = 'Waiting'
AS
BEGIN
    INSERT INTO Games (TableId, CurrentState)
    VALUES (@TableId, @CurrentState);
    
    RETURN SCOPE_IDENTITY();
END;
GO

-- Add player to game
CREATE PROCEDURE AddPlayerToGame
    @GameId INT,
    @UserId INT,
    @SeatPosition INT,
    @BuyInAmount INT
AS
BEGIN
    -- Check if user has enough chips
    DECLARE @UserChips INT;
    SELECT @UserChips = ChipsBalance FROM Users WHERE UserId = @UserId;
    
    IF @UserChips < @BuyInAmount
    BEGIN
        RAISERROR('Not enough chips for buy-in', 16, 1);
        RETURN;
    END
    
    BEGIN TRANSACTION;
    
    -- Deduct chips from user balance
    UPDATE Users
    SET ChipsBalance = ChipsBalance - @BuyInAmount
    WHERE UserId = @UserId;
    
    -- Add player to game
    INSERT INTO GamePlayers (GameId, UserId, SeatPosition, InitialChips, CurrentChips)
    VALUES (@GameId, @UserId, @SeatPosition, @BuyInAmount, @BuyInAmount);
    
    -- Log transaction
    INSERT INTO ChipTransactions (UserId, Amount, TransactionType, ReferenceId, Description)
    VALUES (@UserId, -@BuyInAmount, 'GameLoss', @GameId, 'Buy-in for game');
    
    COMMIT TRANSACTION;
END;
GO

-- Record player move
CREATE PROCEDURE RecordMove
    @GameId INT,
    @PlayerId INT,
    @ActionType NVARCHAR(20),
    @Amount INT,
    @Round NVARCHAR(20)
AS
BEGIN
    INSERT INTO Moves (GameId, PlayerId, ActionType, Amount, Round)
    VALUES (@GameId, @PlayerId, @ActionType, @Amount, @Round);
    
    -- Update pot size
    IF @ActionType IN ('Bet', 'Call', 'Raise', 'AllIn')
    BEGIN
        UPDATE Games
        SET PotSize = PotSize + @Amount
        WHERE GameId = @GameId;
        
        -- Update player's current chips
        UPDATE GamePlayers
        SET CurrentChips = CurrentChips - @Amount
        WHERE GameId = @GameId AND UserId = @PlayerId;
    END
END;
GO

-- End game and distribute winnings
CREATE PROCEDURE EndGame
    @GameId INT,
    @WinnerId INT
AS
BEGIN
    DECLARE @PotSize INT;
    SELECT @PotSize = PotSize FROM Games WHERE GameId = @GameId;
    
    BEGIN TRANSACTION;
    
    -- Update game
    UPDATE Games
    SET EndTime = GETDATE(),
        CurrentState = 'Completed',
        WinnerId = @WinnerId
    WHERE GameId = @GameId;
    
    -- Add chips to winner
    UPDATE Users
    SET ChipsBalance = ChipsBalance + @PotSize
    WHERE UserId = @WinnerId;
    
    -- Log transaction
    INSERT INTO ChipTransactions (UserId, Amount, TransactionType, ReferenceId, Description)
    VALUES (@WinnerId, @PotSize, 'GameWin', @GameId, 'Winnings from game');
    
    COMMIT TRANSACTION;
END;
GO

-- Populate Cards Table
INSERT INTO Cards (Suit, Value) VALUES 
('Hearts', '2'), ('Hearts', '3'), ('Hearts', '4'), ('Hearts', '5'), ('Hearts', '6'),
('Hearts', '7'), ('Hearts', '8'), ('Hearts', '9'), ('Hearts', '10'), ('Hearts', 'J'),
('Hearts', 'Q'), ('Hearts', 'K'), ('Hearts', 'A'),
('Diamonds', '2'), ('Diamonds', '3'), ('Diamonds', '4'), ('Diamonds', '5'), ('Diamonds', '6'),
('Diamonds', '7'), ('Diamonds', '8'), ('Diamonds', '9'), ('Diamonds', '10'), ('Diamonds', 'J'),
('Diamonds', 'Q'), ('Diamonds', 'K'), ('Diamonds', 'A'),
('Clubs', '2'), ('Clubs', '3'), ('Clubs', '4'), ('Clubs', '5'), ('Clubs', '6'),
('Clubs', '7'), ('Clubs', '8'), ('Clubs', '9'), ('Clubs', '10'), ('Clubs', 'J'),
('Clubs', 'Q'), ('Clubs', 'K'), ('Clubs', 'A'),
('Spades', '2'), ('Spades', '3'), ('Spades', '4'), ('Spades', '5'), ('Spades', '6'),
('Spades', '7'), ('Spades', '8'), ('Spades', '9'), ('Spades', '10'), ('Spades', 'J'),
('Spades', 'Q'), ('Spades', 'K'), ('Spades', 'A');

-- Populate PokerTables Table
INSERT INTO PokerTables (Name, EntryFee, MinBuyIn, MaxBuyIn, SmallBlind, BigBlind, MaxPlayers, DifficultyLevel, IsActive) VALUES 
('Beginner Table', 100, 500, 1000, 10, 20, 9, 'Beginner', 1),
('Intermediate Table', 500, 1000, 5000, 50, 100, 9, 'Intermediate', 1),
('Pro Table', 1000, 5000, 10000, 100, 200, 9, 'Pro', 1);

-- Populate ShopItems Table
INSERT INTO ShopItems (Name, Description, Price, ItemType, IsActive) VALUES 
('Basic Chips Pack', 'Get 1000 chips.', 4.99, 'Chips', 1),
('Premium Chips Pack', 'Get 5000 chips.', 19.99, 'Chips', 1),
('Golden Avatar', 'Unlock a golden avatar.', 9.99, 'Avatar', 1),
('Luxury Card Deck', 'Upgrade your card deck to a luxury theme.', 14.99, 'CardDeck', 1);
