using TexasHoldemPoker.API.DTOs;

namespace TexasHoldemPoker.API.Helpers
{
    public static class GameAgentTranslator
    {
        public static float[] ExtractGameFeaturesOld(GameStateDto gameState)
        {
            var features = new List<float>();

            features.AddRange(BadEncodePlayerCards(gameState.PlayerCards));
            features.AddRange(BadEncodeCommunityCards(gameState.CommunityCards));

            return features.ToArray();
        }

        public static float[] ExtractGameFeatures(GameStateDto gameState)
        {
            var features = new List<float>();

            features.AddRange(EncodePlayerCards(gameState.PlayerCards));
            features.AddRange(EncodeCommunityCards(gameState.CommunityCards));

            var pot = gameState.PotSize;
            var players = gameState.Players;
            var currentTurnUserId = gameState.CurrentTurnUserId;
            var currentPlayer = players.FirstOrDefault(p => p.UserId == currentTurnUserId);
            var otherPlayers = players.Where(p => p.UserId != currentTurnUserId).ToList();

            features.AddRange(EncodePlayersChips(pot, currentPlayer, otherPlayers));

            return features.ToArray();
        }

        private static float[] EncodePlayersChips(int tablePot, PlayerStateDto currentPlayer, List<PlayerStateDto> otherPlayers)
        {
            var features = new float[20 + 17 + 3 * (17 + 1)]; // 20 for pot, 17 for own chips, 3 * (17 for each player chips + 1 for isActive)
            Array.Fill(features, 0);

            string potString = Convert.ToString(tablePot, 2).PadLeft(20, '0');
            for (int i = 0; i < 20; i++)
            {
                features[i] = potString[i] == '1' ? 1f : 0f;
            }

            string currentPlayerChipsString = Convert.ToString(currentPlayer.CurrentChips, 2).PadLeft(17, '0');
            for (int i = 0; i < 17; i++)
            {
                features[20 + i] = currentPlayerChipsString[i] == '1' ? 1f : 0f;
            }

            for (int i = 0; i < otherPlayers.Count; i++)
            {
                var player = otherPlayers[i];
                string playerChipsString = Convert.ToString(player.CurrentChips, 2).PadLeft(17, '0');
                for (int j = 0; j < 17; j++)
                {
                    features[20 + 17 + i * 18 + j] = playerChipsString[j] == '1' ? 1f : 0f;
                }
                features[20 + 17 + i * 18 + 17] = player.IsActive ? 1f : 0f;
            }

            return features;
        }

        public static MoveDto ConvertActionIndexToPokerAction(int actionIndex, GameStateDto gameState)
        {
            MoveDto move = new MoveDto
            {
                ActionType = actionIndex switch
                {
                    0 => "Fold",
                    1 => "Call",
                    2 => "Raise",
                    _ => throw new ArgumentException("Invalid action type")
                },
                Amount = actionIndex switch
                {
                    0 => 0,
                    1 => gameState.CallAmount,
                    2 => gameState.MinRaiseAmount,
                    _ => throw new ArgumentException("Invalid action type")
                }
            };
            return move;
        }

        public static int GetBestActionIndex(float[] predictions)
        {
            int bestAction = 0;
            float maxValue = predictions[0];

            for (int i = 1; i < predictions.Length; i++)
            {
                if (predictions[i] > maxValue)
                {
                    maxValue = predictions[i];
                    bestAction = i;
                }
            }

            return bestAction;
        }

        private static float[] BadEncodePlayerCards(List<CardDto> cards)
        {
            // daniels super version of encoding
            var features = new float[2 * 17]; // 2 cards * 17 for one hot encoding(value + suit

            Array.Fill(features, 0);

            for (int i = 0; i < Math.Min(cards.Count, 2); i++)
            {
                var cardIndex = EncodeCard(cards[i]);
                features[i * 17 + cardIndex / 4] = 1;
                features[i * 17 + 13 + cardIndex % 4] = 1;
            }

            return features;
        }

        private static float[] BadEncodeCommunityCards(List<CardDto> cards)
        {
            // daniels super version of encoding
            var features = new float[5 * 17];

            Array.Fill(features, 0);

            for (int i = 0; i < Math.Min(cards.Count, 5); i++)
            {
                var cardIndex = EncodeCard(cards[i]);
                features[i * 17 + cardIndex / 4] = 1;
                features[i * 17 + 13 + cardIndex % 4] = 1;
            }

            return features;
        }

        private static float[] EncodePlayerCards(List<CardDto> cards)
        {
            var features = new float[2 * 17];

            Array.Fill(features, 0);

            for (int i = 0; i < Math.Min(cards.Count, 2); i++)
            {
                var cardIndex = EncodeCard(cards[i]);
                features[i * 17 + cardIndex % 13] = 1;
                features[i * 17 + 13 + cardIndex / 13] = 1;
            }

            return features;
        }

        private static float[] EncodeCommunityCards(List<CardDto> cards)
        {
            var features = new float[5 * 17];

            Array.Fill(features, 0);

            for (int i = 0; i < Math.Min(cards.Count, 5); i++)
            {
                var cardIndex = EncodeCard(cards[i]);
                features[i * 17 + cardIndex % 13] = 1;
                features[i * 17 + 13 + cardIndex / 13] = 1;
            }

            return features;
        }

        private static int EncodeCard(CardDto card)
        {
            if (card == null) return -1;
            int valueIndex = EncodeCardValue(card.Value);
            int suitIndex = EncodeCardSuit(card.Suit);
            return valueIndex + suitIndex * 13;
        }

        private static int EncodeCardSuit(string suit) => suit switch
        {
            "Hearts" => 0,
            "Diamonds" => 1,
            "Clubs" => 2,
            "Spades" => 3,
            _ => throw new ArgumentException("Invalid card suit")
        };

        private static int EncodeCardValue(string value) => value switch
        {
            "2" => 0,
            "3" => 1,
            "4" => 2,
            "5" => 3,
            "6" => 4,
            "7" => 5,
            "8" => 6,
            "9" => 7,
            "10" => 8,
            "J" => 9,
            "Q" => 10,
            "K" => 11,
            "A" => 12,
            _ => throw new ArgumentException("Invalid card value")
        };
    }
}