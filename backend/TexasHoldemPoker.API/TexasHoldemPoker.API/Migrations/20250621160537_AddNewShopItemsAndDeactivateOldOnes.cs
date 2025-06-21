using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TexasHoldemPoker.API.Migrations
{
    /// <inheritdoc />
    public partial class AddNewShopItemsAndDeactivateOldOnes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
                UPDATE ShopItems
                SET IsActive = 0
                WHERE Name IN (
                    'Basic Chips Pack',
                    'Premium Chips Pack',
                    'Golden Avatar',
                    'Luxury Card Deck',
                    'Premium',
                    'Pro',
                    'Ultra'
                );
            ");

            migrationBuilder.InsertData(
                table: "ShopItems",
                columns: new[] { "Name", "Description", "Price", "ItemType", "IsActive", "Currency" },
                values: new object[,]
                {
                    // Avatars
                    { "Bat", "Embrace the night with this spooky and mysterious bat avatar.", 9.99m, "Avatar", true, "PLN" },
                    { "Beer", "Cheers! The perfect avatar for celebrating a big win.", 1500, "Avatar", true, "CHIPS" },
                    { "Bones", "A chilling collection of bones to intimidate your opponents.", 9.99m, "Avatar", true, "PLN" },
                    { "Brown Bunny", "A cute and cuddly brown bunny avatar for a friendly profile.", 1000, "Avatar", true, "CHIPS" },
                    { "Cake", "A delicious slice of cake to celebrate your victories. Sweet!", 4.99m, "Avatar", true, "PLN" },
                    { "Candle", "Light up the table with this elegant and flickering candle avatar.", 4.99m, "Avatar", true, "PLN" },
                    { "Candy", "A sweet treat for your profile. Good enough to eat!", 1000, "Avatar", true, "CHIPS" },
                    { "Cat", "A sleek and cunning cat avatar. Perfect for a sly player.", 14.99m, "Avatar", true, "PLN" },
                    { "Clover", "Bring some luck to the table with this four-leaf clover.", 14.99m, "Avatar", true, "PLN" },
                    { "Coffin", "A hauntingly cool coffin avatar. Rest in peace, rivals.", 9.99m, "Avatar", true, "PLN" },
                    { "Cross Grave", "A spooky and solemn grave marker for the serious player.", 9.99m, "Avatar", true, "PLN" },
                    { "Duck", "A cheerful and charming duck avatar to brighten up the game.", 1000, "Avatar", true, "CHIPS" },
                    { "Easter Egg", "A beautifully decorated Easter egg to celebrate the spring season.", 4.99m, "Avatar", true, "PLN" },
                    { "Blue Egg", "A simple and elegant blue egg avatar. A sign of new beginnings.", 4.99m, "Avatar", true, "PLN" },
                    { "Eyeball", "Keep an eye on the competition with this unsettling eyeball avatar.", 14.99m, "Avatar", true, "PLN" },
                    { "Flame Pot", "A magical pot with an eternal flame. Shows you mean business.", 14.99m, "Avatar", true, "PLN" },
                    { "Ghost", "A friendly ghost to haunt your profile. Boo!", 9.99m, "Avatar", true, "PLN" },
                    { "Grill", "Show off your skills as the master of the grill. Sizzling hot!", 4.99m, "Avatar", true, "PLN" },
                    { "Half Moon", "A mysterious half-moon avatar for the night owl player.", 4.99m, "Avatar", true, "PLN" },
                    { "Horseshoe", "A classic symbol of good fortune. May the cards be in your favor!", 14.99m, "Avatar", true, "PLN" },
                    { "Lollipop", "A colorful and sweet lollipop avatar for a playful personality.", 4.99m, "Avatar", true, "PLN" },
                    { "Lucky Boot", "An old, worn boot that is surprisingly lucky. Kick the competition!", 9.99m, "Avatar", true, "PLN" },
                    { "Lucky Hat", "A dapper green hat brimming with Irish luck.", 14.99m, "Avatar", true, "PLN" },
                    { "Magic Pot", "A bubbling cauldron of magic. What secrets does it hold?", 19.99m, "Avatar", true, "PLN" },
                    { "Moon", "The full moon avatar, for players who come alive at night.", 4.99m, "Avatar", true, "PLN" },
                    { "Pipe", "A sophisticated pipe for the distinguished and thoughtful player.", 9.99m, "Avatar", true, "PLN" },
                    { "Pride Hat", "A vibrant and colorful hat to show your pride all year long!", 14.99m, "Avatar", true, "PLN" },
                    { "Pumpkin", "A classic Jack-o'-lantern for the Halloween enthusiast.", 9.99m, "Avatar", true, "PLN" },
                    { "Skull", "A fearsome skull avatar. A timeless symbol of danger.", 14.99m, "Avatar", true, "PLN" },
                    { "Spider", "Weave a web of complex strategies with this creepy spider avatar.", 9.99m, "Avatar", true, "PLN" },
                    { "Spring Egg", "A freshly hatched egg, symbolizing a fresh start in the new season.", 4.99m, "Avatar", true, "PLN" },
                    { "Star", "Shine bright like a star and be the envy of the table.", 9.99m, "Avatar", true, "PLN" },
                    { "Turkey", "A festive turkey avatar, perfect for the Thanksgiving season.", 4.99m, "Avatar", true, "PLN" },
                    { "White Bunny", "An adorable and fluffy white bunny to hop its way into everyone's heart.", 1000, "Avatar", true, "CHIPS" },
                    { "Wizard Hat", "A magical wizard hat imbued with powerful enchantments. Pure magic!", 19.99m, "Avatar", true, "PLN" },
                    
                    // Card Decks
                    { "Aqua Deck", "Dive into the game with this refreshing and fluid aqua-themed card deck.", 9.99m, "CardDeck", true, "PLN" },
                    { "Dusky Deck", "A mysterious and elegant dusky theme for your cards, perfect for late-night games.", 14.99m, "CardDeck", true, "PLN" },
                    { "Forest Deck", "Bring the tranquility of the forest to your table with this lush green card deck.", 9.99m, "CardDeck", true, "PLN" },
                    { "Green Magenta Swap Deck", "A vibrant, high-contrast deck that swaps traditional colors for a bold new look.", 14.99m, "CardDeck", true, "PLN" },
                    { "Inverse Deck", "Challenge perception with this striking inverse color deck. A true mind-bender!", 19.99m, "CardDeck", true, "PLN" },
                    { "Magenta Deck", "A bold and beautiful magenta deck that makes every card pop.", 9.99m, "CardDeck", true, "PLN" },
                    { "Night Deck", "A sleek, dark theme with neon highlights, designed for the ultimate night owl.", 19.99m, "CardDeck", true, "PLN" },
                    { "Origin Deck", "Go back to basics with this clean, classic, and easy-to-read original deck design.", 5000, "CardDeck", true, "CHIPS" },
                    { "Pastel Deck", "A soft and dreamy pastel color palette for a more relaxed and stylish game.", 9.99m, "CardDeck", true, "PLN" },
                    { "Psychedelic Deck", "A wild, mind-bending design with swirling colors for the boldest players.", 24.99m, "CardDeck", true, "PLN" },
                    { "Rose Deck", "An elegant and romantic rose-tinted deck, adding a touch of class to your hand.", 14.99m, "CardDeck", true, "PLN" },
                    { "Sepia Deck", "A cool, classic sepia tone for a vintage, old-western saloon feel.", 8500, "CardDeck", true, "CHIPS" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "ShopItems",
                keyColumn: "Name",
                keyValues: new object[]
                {
                    "Bat", "Beer", "Bones", "Brown Bunny", "Cake", "Candle", "Candy", "Cat", "Clover", "Coffin", "Cross Grave", "Duck", "Easter Egg", "Blue Egg", "Eyeball", "Flame Pot", "Ghost", "Grill", "Half Moon", "Horseshoe", "Lollipop", "Lucky Boot", "Lucky Hat", "Magic Pot", "Moon", "Pipe", "Pride Hat", "Pumpkin", "Skull", "Spider", "Spring Egg", "Star", "Turkey", "White Bunny", "Wizard Hat",
                    "Aqua Deck", "Dusky Deck", "Forest Deck", "Green Magenta Swap Deck", "Inverse Deck", "Magenta Deck", "Night Deck", "Origin Deck", "Pastel Deck", "Psychedelic Deck", "Rose Deck", "Sepia Deck"
                });

            migrationBuilder.Sql(@"
                UPDATE ShopItems
                SET IsActive = 1
                WHERE Name IN (
                    'Basic Chips Pack',
                    'Premium Chips Pack',
                    'Golden Avatar',
                    'Luxury Card Deck',
                    'Premium',
                    'Pro',
                    'Ultra'
                );
            ");
        }
    }
}
