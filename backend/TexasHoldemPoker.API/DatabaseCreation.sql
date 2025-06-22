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
    AvatarType NVARCHAR(20) NOT NULL DEFAULT 'Standard',
	DeckStyle NVARCHAR(255),
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
    GamePlayerId INT,
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
    Currency NVARCHAR(10) NOT NULL DEFAULT 'PLN',
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

-- Check Constraints
ALTER TABLE GameRounds ADD CONSTRAINT CK_GameRounds_CurrentState CHECK (CurrentState IN ('Waiting', 'PreFlop', 'Flop', 'Turn', 'River', 'Showdown', 'Completed'));
ALTER TABLE Cards ADD CONSTRAINT CK_Cards_Suit CHECK (Suit IN ('Hearts', 'Diamonds', 'Clubs', 'Spades'));
ALTER TABLE Cards ADD CONSTRAINT CK_Cards_Value CHECK (Value IN ('2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'));
ALTER TABLE CommunityCards ADD CONSTRAINT CK_CommunityCards_Position CHECK (Position BETWEEN 1 AND 5);
ALTER TABLE PlayerCards ADD CONSTRAINT CK_PlayerCards_Position CHECK (Position IN (1, 2));
ALTER TABLE Moves ADD CONSTRAINT CK_Moves_ActionType CHECK (ActionType IN ('Fold', 'Check', 'Call', 'Bet', 'Raise', 'AllIn', 'Blind'));
ALTER TABLE Moves ADD CONSTRAINT CK_Moves_Round CHECK (Round IN ('PreFlop', 'Flop', 'Turn', 'River'));
ALTER TABLE ShopItems ADD CONSTRAINT CK_ShopItems_ItemType CHECK (ItemType IN ('Chips', 'Avatar', 'TableTheme', 'CardDeck', 'Emote'));
ALTER TABLE ShopItems ADD CONSTRAINT CK_ShopItems_Currency CHECK (Currency IN ('PLN', 'CHIPS'));
ALTER TABLE ChipTransactions ADD CONSTRAINT CK_ChipTransactions_TransactionType CHECK (TransactionType IN ('Purchase', 'GameWin', 'GameLoss', 'Bonus', 'Gift', 'Refund'));
GO

-- Leaderboard View
CREATE OR ALTER VIEW LeaderboardView AS
SELECT 
    u.UserId,
    u.Username,
    u.ChipsBalance,
    u.AvatarImage,
    (SELECT COUNT(*) FROM GameRoundWinners WHERE UserId = u.UserId) AS GamesWon,
    (SELECT COUNT(*) FROM GameRounds as GR INNER JOIN PlayerCards as PC ON GR.GameRoundId=PC.GameRoundId WHERE PC.UserId = u.UserId) AS GamesPlayed,
    CASE 
        WHEN (SELECT COUNT(*) FROM GameRoundWinners WHERE UserId = u.UserId) = 0 THEN 0
        ELSE CAST((SELECT COUNT(*) FROM GameRoundWinners WHERE UserId = u.UserId) AS FLOAT) /
             CAST((SELECT COUNT(*) FROM GameRounds as GR INNER JOIN PlayerCards as PC ON GR.GameRoundId=PC.GameRoundId WHERE PC.UserId = u.UserId) AS FLOAT)
    END AS WinRatio
FROM Users u
WHERE u.IsActive = 1;
GO

-- Indexes
CREATE INDEX IX_Games_TableId ON Games(TableId);
CREATE INDEX IX_GamePlayers_GameId ON GamePlayers(GameId);
CREATE INDEX IX_GamePlayers_UserId ON GamePlayers(UserId);
CREATE INDEX IX_Moves_PlayerId ON Moves(PlayerId);
CREATE INDEX IX_Purchases_UserId ON Purchases(UserId);
CREATE INDEX IX_ChipTransactions_UserId ON ChipTransactions(UserId);
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
('Beginner Table', 100, 500, 1000, 10, 20, 4, 'Beginner', 1),
('Intermediate Table', 500, 1000, 5000, 50, 100, 4, 'Intermediate', 1),
('Pro Table', 1000, 5000, 10000, 100, 200, 4, 'Pro', 1);
GO

-- Populate ShopItems Table
INSERT INTO ShopItems (Name, Description, Price, ItemType, IsActive, Currency) VALUES 
('Basic Chips Pack', 'Get 1000 chips.', 4.99, 'Chips', 0, 'PLN'),
('Premium Chips Pack', 'Get 5000 chips.', 19.99, 'Chips', 0, 'PLN'),
('Golden Avatar', 'Unlock a golden avatar.', 9.99, 'Avatar', 0, 'PLN'),
('Luxury Card Deck', 'Upgrade your card deck to a luxury theme.', 14.99, 'CardDeck', 0, 'CHIPS'),
('Premium', 'Unlock a premium avatar for your profile.', 9.99, 'Avatar', 0, 'PLN'),
('Pro', 'Unlock a pro avatar for your profile.', 14.99, 'Avatar', 0, 'PLN'),
('Ultra', 'Unlock an ultra avatar for your profile.', 19.99, 'Avatar', 0, 'CHIPS');

INSERT INTO Models (Name, Path, Difficulty) VALUES
('Stupid', 'dqn_model.onnx', 'Easy'),
('Aggressive', 'harmful.onnx', 'Medium'),
('Careful', 'harmless.onnx', 'Hard');

INSERT INTO Users(Username, Email, PasswordHash, ChipsBalance, IsBot, AvatarImage) VALUES
('Bot_Adam', 'email1', 'password', 2147483647, 1,'lolipop'),
('Bot_Michal', 'email2', 'password', 2147483647, 1, 'lolipop'),
('Bot_Eva', 'email3', 'password', 2147483647, 1, 'lolipop'),
('Bot_Elizabeth', 'email4', 'password', 2147483647, 1, 'pumpkin'),
('Bot_William', 'email5', 'password', 2147483647, 1, 'pumpkin'),
('Bot_Olivia', 'email6', 'password', 2147483647, 1, 'pumpkin'),
('Bot_Alice', 'email7', 'password', 2147483647, 1, 'cat'),
('Bot_Grace', 'email8', 'password', 2147483647, 1, 'cat'),
('Bot_Jack', 'email9', 'password', 2147483647, 1, 'cat');

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

INSERT INTO ShopItems (Name, Description, Price, ItemType, IsActive, Currency) VALUES 
('Bat', 'Embrace the night with this spooky and mysterious bat avatar.', 9.99, 'Avatar', 1, 'PLN'),
('Beer', 'Cheers! The perfect avatar for celebrating a big win.', 1500, 'Avatar', 1, 'CHIPS'),
('Bones', 'A chilling collection of bones to intimidate your opponents.', 9.99, 'Avatar', 1, 'PLN'),
('Brown Bunny', 'A cute and cuddly brown bunny avatar for a friendly profile.', 1000, 'Avatar', 1, 'CHIPS'),
('Cake', 'A delicious slice of cake to celebrate your victories. Sweet!', 4.99, 'Avatar', 1, 'PLN'),
('Candle', 'Light up the table with this elegant and flickering candle avatar.', 4.99, 'Avatar', 1, 'PLN'),
('Candy', 'A sweet treat for your profile. Good enough to eat!', 1000, 'Avatar', 1, 'CHIPS'),
('Cat', 'A sleek and cunning cat avatar. Perfect for a sly player.', 14.99, 'Avatar', 1, 'PLN'),
('Clover', 'Bring some luck to the table with this four-leaf clover.', 14.99, 'Avatar', 1, 'PLN'),
('Coffin', 'A hauntingly cool coffin avatar. Rest in peace, rivals.', 9.99, 'Avatar', 1, 'PLN'),
('Cross Grave', 'A spooky and solemn grave marker for the serious player.', 9.99, 'Avatar', 1, 'PLN'),
('Duck', 'A cheerful and charming duck avatar to brighten up the game.', 1000, 'Avatar', 1, 'CHIPS'),
('Easter Egg', 'A beautifully decorated Easter egg to celebrate the spring season.', 4.99, 'Avatar', 1, 'PLN'),
('Blue Egg', 'A simple and elegant blue egg avatar. A sign of new beginnings.', 4.99, 'Avatar', 1, 'PLN'),
('Eyeball', 'Keep an eye on the competition with this unsettling eyeball avatar.', 14.99, 'Avatar', 1, 'PLN'),
('Flame Pot', 'A magical pot with an eternal flame. Shows you mean business.', 14.99, 'Avatar', 1, 'PLN'),
('Ghost', 'A friendly ghost to haunt your profile. Boo!', 9.99, 'Avatar', 1, 'PLN'),
('Grill', 'Show off your skills as the master of the grill. Sizzling hot!', 4.99, 'Avatar', 1, 'PLN'),
('Half Moon', 'A mysterious half-moon avatar for the night owl player.', 4.99, 'Avatar', 1, 'PLN'),
('Horseshoe', 'A classic symbol of good fortune. May the cards be in your favor!', 14.99, 'Avatar', 1, 'PLN'),
('Lollipop', 'A colorful and sweet lollipop avatar for a playful personality.', 4.99, 'Avatar', 1, 'PLN'),
('Lucky Boot', 'An old, worn boot that is surprisingly lucky. Kick the competition!', 9.99, 'Avatar', 1, 'PLN'),
('Lucky Hat', 'A dapper green hat brimming with Irish luck.', 14.99, 'Avatar', 1, 'PLN'),
('Magic Pot', 'A bubbling cauldron of magic. What secrets does it hold?', 19.99, 'Avatar', 1, 'PLN'),
('Moon', 'The full moon avatar, for players who come alive at night.', 4.99, 'Avatar', 1, 'PLN'),
('Pipe', 'A sophisticated pipe for the distinguished and thoughtful player.', 9.99, 'Avatar', 1, 'PLN'),
('Pride Hat', 'A vibrant and colorful hat to show your pride all year long!', 14.99, 'Avatar', 1, 'PLN'),
('Pumpkin', 'A classic Jack-o''-lantern for the Halloween enthusiast.', 9.99, 'Avatar', 1, 'PLN'),
('Skull', 'A fearsome skull avatar. A timeless symbol of danger.', 14.99, 'Avatar', 1, 'PLN'),
('Spider', 'Weave a web of complex strategies with this creepy spider avatar.', 9.99, 'Avatar', 1, 'PLN'),
('Spring Egg', 'A freshly hatched egg, symbolizing a fresh start in the new season.', 4.99, 'Avatar', 1, 'PLN'),
('Star', 'Shine bright like a star and be the envy of the table.', 9.99, 'Avatar', 1, 'PLN'),
('Turkey', 'A festive turkey avatar, perfect for the Thanksgiving season.', 4.99, 'Avatar', 1, 'PLN'),
('White Bunny', 'An adorable and fluffy white bunny to hop its way into everyone''s heart.', 1000, 'Avatar', 1, 'CHIPS'),
('Wizard Hat', 'A magical wizard hat imbued with powerful enchantments. Pure magic!', 19.99, 'Avatar', 1, 'PLN'),
('Aqua Deck', 'Dive into the game with this refreshing and fluid aqua-themed card deck.', 9.99, 'CardDeck', 1, 'PLN'),
('Dusky Deck', 'A mysterious and elegant dusky theme for your cards, perfect for late-night games.', 14.99, 'CardDeck', 1, 'PLN'),
('Forest Deck', 'Bring the tranquility of the forest to your table with this lush green card deck.', 9.99, 'CardDeck', 1, 'PLN'),
('Green Magenta Swap Deck', 'A vibrant, high-contrast deck that swaps traditional colors for a bold new look.', 14.99, 'CardDeck', 1, 'PLN'),
('Inverse Deck', 'Challenge perception with this striking inverse color deck. A true mind-bender!', 19.99, 'CardDeck', 1, 'PLN'),
('Magenta Deck', 'A bold and beautiful magenta deck that makes every card pop.', 9.99, 'CardDeck', 1, 'PLN'),
('Night Deck', 'A sleek, dark theme with neon highlights, designed for the ultimate night owl.', 19.99, 'CardDeck', 1, 'PLN'),
('Origin Deck', 'Go back to basics with this clean, classic, and easy-to-read original deck design.', 5000, 'CardDeck', 1, 'CHIPS'),
('Pastel Deck', 'A soft and dreamy pastel color palette for a more relaxed and stylish game.', 9.99, 'CardDeck', 1, 'PLN'),
('Psychedelic Deck', 'A wild, mind-bending design with swirling colors for the boldest players.', 24.99, 'CardDeck', 1, 'PLN'),
('Rose Deck', 'An elegant and romantic rose-tinted deck, adding a touch of class to your hand.', 14.99, 'CardDeck', 1, 'PLN'),
('Sepia Deck', 'A cool, classic sepia tone for a vintage, old-western saloon feel.', 8500, 'CardDeck', 1, 'CHIPS');
