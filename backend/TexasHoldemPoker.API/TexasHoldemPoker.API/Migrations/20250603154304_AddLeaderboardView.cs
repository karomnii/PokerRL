using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TexasHoldemPoker.API.Migrations
{
    /// <inheritdoc />
    public partial class AddLeaderboardView : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
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
    ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("DROP VIEW LeaderboardView");
        }
    }
}
