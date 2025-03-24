using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Services
{
    public class PokerHandEvaluator
    {
        // Constants for hand rankings
        private const int HighCard = 1;
        private const int Pair = 2;
        private const int TwoPair = 3;
        private const int ThreeOfAKind = 4;
        private const int Straight = 5;
        private const int Flush = 6;
        private const int FullHouse = 7;
        private const int FourOfAKind = 8;
        private const int StraightFlush = 9;
        private const int RoyalFlush = 10;

        public static int EvaluateHand(List<Card> cards)
        {
            if (cards.Count < 5)
                throw new ArgumentException("Need at least 5 cards to evaluate a poker hand");

            // Get all possible 5-card combinations if more than 5 cards are provided
            var combinations = GetCombinations(cards, 5);

            // Evaluate each combination and return the highest rank
            int bestRank = 0;
            foreach (var combo in combinations)
            {
                int rank = EvaluateFiveCardHand(combo.ToList());
                if (rank > bestRank)
                    bestRank = rank;
            }

            return bestRank;
        }

        private static int EvaluateFiveCardHand(List<Card> cards)
        {
            if (cards.Count != 5)
                throw new ArgumentException("Must have exactly 5 cards");

            bool isFlush = IsFlush(cards);
            bool isStraight = IsStraight(cards);

            // Check for royal flush
            if (isFlush && isStraight && HasAce(cards) && HasKing(cards))
                return RoyalFlush * 1000000;

            // Check for straight flush
            if (isFlush && isStraight)
                return StraightFlush * 1000000 + GetHighCardValue(cards);

            // Check for four of a kind
            var groups = cards.GroupBy(c => c.Value).OrderByDescending(g => g.Count());
            if (groups.First().Count() == 4)
                return FourOfAKind * 1000000 + GetCardValue(groups.First().First()) * 10000 + GetCardValue(groups.Skip(1).First().First()) * 100;

            // Check for full house
            if (groups.First().Count() == 3 && groups.Skip(1).First().Count() == 2)
                return FullHouse * 1000000 + GetCardValue(groups.First().First()) * 10000 + GetCardValue(groups.Skip(1).First().First()) * 100;

            // Check for flush
            if (isFlush)
                return Flush * 1000000 + GetCardValue(groups.First().First()) * 10000 + GetCardValue(groups.Skip(1).First().First()) * 100 
                    + GetCardValue(groups.Skip(2).First().First()) * 50 + GetCardValue(groups.Skip(3).First().First()) * 25 + GetCardValue(groups.Skip(4).First().First());

            // Check for straight
            if (isStraight)
                return Straight * 1000000 + GetHighCardValue(cards) * 10000;

            // Check for three of a kind
            if (groups.First().Count() == 3)
                return ThreeOfAKind * 1000000 + GetCardValue(groups.First().First()) * 10000 + GetCardValue(groups.Skip(1).First().First()) * 100 
                    + GetCardValue(groups.Skip(2).First().First());

            // Check for two pair
            if (groups.First().Count() == 2 && groups.Skip(1).First().Count() == 2)
                return TwoPair * 1000000 + Math.Max(GetCardValue(groups.First().First()), GetCardValue(groups.Skip(1).First().First())) * 10000
                    + Math.Min(GetCardValue(groups.First().First()), GetCardValue(groups.Skip(1).First().First())) * 100 + GetCardValue(groups.Skip(2).First().First());

            // Check for pair
            if (groups.First().Count() == 2)
                return Pair * 1000000 + GetCardValue(groups.First().First()) * 10000 + GetCardValue(groups.Skip(1).First().First()) * 100
                    + GetCardValue(groups.Skip(2).First().First()) * 50 + GetCardValue(groups.Skip(3).First().First());

            // High card
            return HighCard * 1000000 + GetHighCardValue(cards);
        }

        private static bool IsFlush(List<Card> cards)
        {
            return cards.Select(c => c.Suit).Distinct().Count() == 1;
        }

        private static bool IsStraight(List<Card> cards)
        {
            var values = cards.Select(c => GetCardValue(c)).OrderBy(v => v).ToList();

            // Check for A-5 straight
            if (values.SequenceEqual(new[] { 2, 3, 4, 5, 14 }))
                return true;

            // Check for regular straight
            for (int i = 1; i < values.Count; i++)
            {
                if (values[i] != values[i - 1] + 1)
                    return false;
            }

            return true;
        }

        private static bool HasAce(List<Card> cards)
        {
            return cards.Any(c => c.Value == "A");
        }

        private static bool HasKing(List<Card> cards)
        {
            return cards.Any(c => c.Value == "K");
        }

        private static int GetCardValue(Card card)
        {
            switch (card.Value)
            {
                case "2": return 2;
                case "3": return 3;
                case "4": return 4;
                case "5": return 5;
                case "6": return 6;
                case "7": return 7;
                case "8": return 8;
                case "9": return 9;
                case "10": return 10;
                case "J": return 11;
                case "Q": return 12;
                case "K": return 13;
                case "A": return 14;
                default: throw new ArgumentException($"Invalid card value: {card.Value}");
            }
        }

        private static int GetHighCardValue(List<Card> cards)
        {
            return cards.Max(c => GetCardValue(c));
        }

        private static IEnumerable<IEnumerable<T>> GetCombinations<T>(IEnumerable<T> list, int length)
        {
            if (length == 1) return list.Select(t => new T[] { t });

            return GetCombinations(list, length - 1)
                .SelectMany(t => list.Where(o => !t.Contains(o)),
                    (t1, t2) => t1.Concat(new T[] { t2 }));
        }
    }
}
