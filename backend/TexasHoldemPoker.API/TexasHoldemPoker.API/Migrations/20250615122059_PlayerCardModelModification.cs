using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TexasHoldemPoker.API.Migrations
{
    /// <inheritdoc />
    public partial class PlayerCardModelModification : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "UQ_PlayerCards_GamePlayerPosition",
                table: "PlayerCards");

            migrationBuilder.AlterColumn<int>(
                name: "GamePlayerId",
                table: "PlayerCards",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.CreateIndex(
                name: "IX_PlayerCards_GameRoundId",
                table: "PlayerCards",
                column: "GameRoundId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_PlayerCards_GameRoundId",
                table: "PlayerCards");

            migrationBuilder.AlterColumn<int>(
                name: "GamePlayerId",
                table: "PlayerCards",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.CreateIndex(
                name: "UQ_PlayerCards_GamePlayerPosition",
                table: "PlayerCards",
                columns: new[] { "GameRoundId", "GamePlayerId", "Position" },
                unique: true);
        }
    }
}
