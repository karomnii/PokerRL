using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TexasHoldemPoker.API.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Cards",
                columns: table => new
                {
                    CardId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Suit = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    Value = table.Column<string>(type: "nvarchar(5)", maxLength: 5, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cards", x => x.CardId);
                });

            migrationBuilder.CreateTable(
                name: "Models",
                columns: table => new
                {
                    ModelId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Path = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    Difficulty = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Models", x => x.ModelId);
                });

            migrationBuilder.CreateTable(
                name: "PokerTables",
                columns: table => new
                {
                    TableId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    EntryFee = table.Column<int>(type: "int", nullable: false),
                    MinBuyIn = table.Column<int>(type: "int", nullable: false),
                    MaxBuyIn = table.Column<int>(type: "int", nullable: false),
                    SmallBlind = table.Column<int>(type: "int", nullable: false),
                    BigBlind = table.Column<int>(type: "int", nullable: false),
                    MaxPlayers = table.Column<int>(type: "int", nullable: false, defaultValue: 4),
                    DifficultyLevel = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    IsActive = table.Column<bool>(type: "bit", nullable: false, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PokerTables", x => x.TableId);
                });

            migrationBuilder.CreateTable(
                name: "ShopItems",
                columns: table => new
                {
                    ItemId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    Price = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    Currency = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false, defaultValue: "PLN"),
                    ItemType = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ShopItems", x => x.ItemId);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Username = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(128)", maxLength: 128, nullable: false),
                    ChipsBalance = table.Column<int>(type: "int", nullable: false, defaultValue: 5000),
                    AvatarImage = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    AvatarType = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false, defaultValue: "Standard"),
                    RegistrationDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    LastLoginDate = table.Column<DateTime>(type: "datetime", nullable: true),
                    IsActive = table.Column<bool>(type: "bit", nullable: false, defaultValue: true),
                    IsBot = table.Column<bool>(type: "bit", nullable: true, defaultValue: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.UserId);
                });

            migrationBuilder.CreateTable(
                name: "ChipTransactions",
                columns: table => new
                {
                    TransactionId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Amount = table.Column<int>(type: "int", nullable: false),
                    TransactionType = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ReferenceId = table.Column<int>(type: "int", nullable: true),
                    TransactionDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    Description = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ChipTransactions", x => x.TransactionId);
                    table.ForeignKey(
                        name: "FK_ChipTransactions_Users",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateTable(
                name: "Purchases",
                columns: table => new
                {
                    PurchaseId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    ItemId = table.Column<int>(type: "int", nullable: false),
                    PurchaseDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    Price = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    PaymentMethod = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    TransactionId = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Purchases", x => x.PurchaseId);
                    table.ForeignKey(
                        name: "FK_Purchases_ShopItems",
                        column: x => x.ItemId,
                        principalTable: "ShopItems",
                        principalColumn: "ItemId");
                    table.ForeignKey(
                        name: "FK_Purchases_Users",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateTable(
                name: "UserModels",
                columns: table => new
                {
                    UserModelId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    ModelId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserModels", x => x.UserModelId);
                    table.ForeignKey(
                        name: "FK_UserModels_Models",
                        column: x => x.ModelId,
                        principalTable: "Models",
                        principalColumn: "ModelId");
                    table.ForeignKey(
                        name: "FK_UserModels_Users",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateTable(
                name: "CommunityCards",
                columns: table => new
                {
                    CommunityCardId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    GameRoundId = table.Column<int>(type: "int", nullable: false),
                    CardId = table.Column<int>(type: "int", nullable: false),
                    Position = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CommunityCards", x => x.CommunityCardId);
                    table.ForeignKey(
                        name: "FK_CommunityCards_Cards",
                        column: x => x.CardId,
                        principalTable: "Cards",
                        principalColumn: "CardId");
                });

            migrationBuilder.CreateTable(
                name: "GamePlayers",
                columns: table => new
                {
                    GamePlayerId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    GameId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    SeatPosition = table.Column<int>(type: "int", nullable: false),
                    InitialChips = table.Column<int>(type: "int", nullable: false),
                    CurrentChips = table.Column<int>(type: "int", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false, defaultValue: true),
                    IsDealer = table.Column<bool>(type: "bit", nullable: false),
                    IsSmallBlind = table.Column<bool>(type: "bit", nullable: false),
                    IsBigBlind = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GamePlayers", x => x.GamePlayerId);
                    table.ForeignKey(
                        name: "FK_GamePlayers_Users",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateTable(
                name: "Games",
                columns: table => new
                {
                    GameId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TableId = table.Column<int>(type: "int", nullable: false),
                    StartTime = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    EndTime = table.Column<DateTime>(type: "datetime", nullable: true),
                    CurrentTurnPlayerId = table.Column<int>(type: "int", nullable: true),
                    PotSize = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Games", x => x.GameId);
                    table.ForeignKey(
                        name: "FK_Games_GamePlayers",
                        column: x => x.CurrentTurnPlayerId,
                        principalTable: "GamePlayers",
                        principalColumn: "GamePlayerId");
                    table.ForeignKey(
                        name: "FK_Games_PokerTables",
                        column: x => x.TableId,
                        principalTable: "PokerTables",
                        principalColumn: "TableId");
                });

            migrationBuilder.CreateTable(
                name: "GameRounds",
                columns: table => new
                {
                    GameRoundId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    GameId = table.Column<int>(type: "int", nullable: false),
                    RoundNumber = table.Column<int>(type: "int", nullable: false),
                    CurrentState = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    StartTime = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    EndTime = table.Column<DateTime>(type: "datetime", nullable: true),
                    PotSize = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GameRounds", x => x.GameRoundId);
                    table.ForeignKey(
                        name: "FK_GameRounds_Games",
                        column: x => x.GameId,
                        principalTable: "Games",
                        principalColumn: "GameId");
                });

            migrationBuilder.CreateTable(
                name: "GameRoundWinners",
                columns: table => new
                {
                    GameRoundWinnerId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    GameRoundId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    AmountWon = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GameRoundWinners", x => x.GameRoundWinnerId);
                    table.ForeignKey(
                        name: "FK_GameRoundWinners_GameRounds",
                        column: x => x.GameRoundId,
                        principalTable: "GameRounds",
                        principalColumn: "GameRoundId");
                    table.ForeignKey(
                        name: "FK_GameRoundWinners_Users",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateTable(
                name: "Moves",
                columns: table => new
                {
                    MoveId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    GameRoundId = table.Column<int>(type: "int", nullable: false),
                    PlayerId = table.Column<int>(type: "int", nullable: false),
                    ActionType = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Amount = table.Column<int>(type: "int", nullable: false),
                    MoveTime = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    Round = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Moves", x => x.MoveId);
                    table.ForeignKey(
                        name: "FK_Moves_GameRounds",
                        column: x => x.GameRoundId,
                        principalTable: "GameRounds",
                        principalColumn: "GameRoundId");
                    table.ForeignKey(
                        name: "FK_Moves_Users",
                        column: x => x.PlayerId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateTable(
                name: "PlayerCards",
                columns: table => new
                {
                    PlayerCardId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    GamePlayerId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    GameRoundId = table.Column<int>(type: "int", nullable: false),
                    CardId = table.Column<int>(type: "int", nullable: false),
                    Position = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PlayerCards", x => x.PlayerCardId);
                    table.ForeignKey(
                        name: "FK_PlayerCards_Cards",
                        column: x => x.CardId,
                        principalTable: "Cards",
                        principalColumn: "CardId");
                    table.ForeignKey(
                        name: "FK_PlayerCards_GamePlayers",
                        column: x => x.GamePlayerId,
                        principalTable: "GamePlayers",
                        principalColumn: "GamePlayerId");
                    table.ForeignKey(
                        name: "FK_PlayerCards_GameRounds",
                        column: x => x.GameRoundId,
                        principalTable: "GameRounds",
                        principalColumn: "GameRoundId");
                    table.ForeignKey(
                        name: "FK_PlayerCards_Users",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateIndex(
                name: "IX_ChipTransactions_UserId",
                table: "ChipTransactions",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_CommunityCards_CardId",
                table: "CommunityCards",
                column: "CardId");

            migrationBuilder.CreateIndex(
                name: "UQ_CommunityCards_GamePosition",
                table: "CommunityCards",
                columns: new[] { "GameRoundId", "Position" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_GamePlayers_GameId",
                table: "GamePlayers",
                column: "GameId");

            migrationBuilder.CreateIndex(
                name: "IX_GamePlayers_UserId",
                table: "GamePlayers",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "UQ_GamePlayers_GamePosition",
                table: "GamePlayers",
                columns: new[] { "GameId", "SeatPosition" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "UQ_GamePlayers_GameUser",
                table: "GamePlayers",
                columns: new[] { "GameId", "UserId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_GameRounds_GameId",
                table: "GameRounds",
                column: "GameId");

            migrationBuilder.CreateIndex(
                name: "IX_GameRoundWinners_GameRoundId",
                table: "GameRoundWinners",
                column: "GameRoundId");

            migrationBuilder.CreateIndex(
                name: "IX_GameRoundWinners_UserId",
                table: "GameRoundWinners",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Games_CurrentTurnPlayerId",
                table: "Games",
                column: "CurrentTurnPlayerId");

            migrationBuilder.CreateIndex(
                name: "IX_Games_TableId",
                table: "Games",
                column: "TableId");

            migrationBuilder.CreateIndex(
                name: "UQ_Models_Name",
                table: "Models",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Moves_GameRoundId",
                table: "Moves",
                column: "GameRoundId");

            migrationBuilder.CreateIndex(
                name: "IX_Moves_PlayerId",
                table: "Moves",
                column: "PlayerId");

            migrationBuilder.CreateIndex(
                name: "IX_PlayerCards_CardId",
                table: "PlayerCards",
                column: "CardId");

            migrationBuilder.CreateIndex(
                name: "IX_PlayerCards_GamePlayerId",
                table: "PlayerCards",
                column: "GamePlayerId");

            migrationBuilder.CreateIndex(
                name: "IX_PlayerCards_UserId",
                table: "PlayerCards",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "UQ_PlayerCards_GamePlayerPosition",
                table: "PlayerCards",
                columns: new[] { "GameRoundId", "GamePlayerId", "Position" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Purchases_ItemId",
                table: "Purchases",
                column: "ItemId");

            migrationBuilder.CreateIndex(
                name: "IX_Purchases_UserId",
                table: "Purchases",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_UserModels_ModelId",
                table: "UserModels",
                column: "ModelId");

            migrationBuilder.CreateIndex(
                name: "IX_UserModels_UserId",
                table: "UserModels",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "UQ_Users_Email",
                table: "Users",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "UQ_Users_Username",
                table: "Users",
                column: "Username",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_CommunityCards_GameRounds",
                table: "CommunityCards",
                column: "GameRoundId",
                principalTable: "GameRounds",
                principalColumn: "GameRoundId");

            migrationBuilder.AddForeignKey(
                name: "FK_GamePlayers_Games",
                table: "GamePlayers",
                column: "GameId",
                principalTable: "Games",
                principalColumn: "GameId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_GamePlayers_Users",
                table: "GamePlayers");

            migrationBuilder.DropForeignKey(
                name: "FK_GamePlayers_Games",
                table: "GamePlayers");

            migrationBuilder.DropTable(
                name: "ChipTransactions");

            migrationBuilder.DropTable(
                name: "CommunityCards");

            migrationBuilder.DropTable(
                name: "GameRoundWinners");

            migrationBuilder.DropTable(
                name: "Moves");

            migrationBuilder.DropTable(
                name: "PlayerCards");

            migrationBuilder.DropTable(
                name: "Purchases");

            migrationBuilder.DropTable(
                name: "UserModels");

            migrationBuilder.DropTable(
                name: "Cards");

            migrationBuilder.DropTable(
                name: "GameRounds");

            migrationBuilder.DropTable(
                name: "ShopItems");

            migrationBuilder.DropTable(
                name: "Models");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "Games");

            migrationBuilder.DropTable(
                name: "GamePlayers");

            migrationBuilder.DropTable(
                name: "PokerTables");
        }
    }
}
