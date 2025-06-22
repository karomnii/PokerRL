using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TexasHoldemPoker.API.Migrations
{
    /// <inheritdoc />
    public partial class AddDeckStyleToUser : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "DeckStyle",
                table: "Users",
                type: "nvarchar(255)",
                maxLength: 255,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DeckStyle",
                table: "Users");
        }
    }
}
