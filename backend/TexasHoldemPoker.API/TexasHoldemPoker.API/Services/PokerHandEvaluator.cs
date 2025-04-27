using System;
using System.Collections.Generic;
using System.Linq;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Services
{
    public static class PokerHandEvaluator
    {
        private const int HIGH_CARD = 1;
        private const int PAIR = 2;
        private const int TWO_PAIR = 3;
        private const int THREE_OF_A_KIND = 4;
        private const int STRAIGHT = 5;
        private const int FLUSH = 6;
        private const int FULL_HOUSE = 7;
        private const int FOUR_OF_A_KIND = 8;
        private const int STRAIGHT_FLUSH = 9;
        private const int ROYAL_FLUSH = 10;

        public static int EvaluateHand(List<Card> cards)
        {
            if (cards.Count < 5)
                throw new ArgumentException("Need at least 5 cards to evaluate a hand");

            if (cards.Count > 5)
            {
                return FindBestFiveCardHand(cards);
            }

            return EvaluateFiveCardHand(cards);
        }

        private static int FindBestFiveCardHand(List<Card> cards)
        {
            var combinations = GetCombinations(cards, 5);

            int bestHandValue = 0;

            foreach (var combo in combinations)
            {
                var handValue = EvaluateFiveCardHand(combo.ToList());
                if (handValue > bestHandValue)
                {
                    bestHandValue = handValue;
                }
            }

            return bestHandValue;
        }

        private static int EvaluateFiveCardHand(List<Card> cards)
        {
            bool isFlush = cards.Select(c => c.Suit).Distinct().Count() == 1;

            bool isStraight = IsStraight(cards);

            var values = cards.Select(c => GetCardValue(c)).OrderByDescending(v => v).ToList();

            var valueGroups = cards.GroupBy(c => GetCardValue(c))
                .OrderByDescending(g => g.Count())
                .ThenByDescending(g => g.Key)
                .ToList();

            if (isFlush && isStraight && values.Contains(14) && values.Contains(13))
            {
                return ROYAL_FLUSH * 100000000;
            }

            if (isFlush && isStraight)
            {
                return STRAIGHT_FLUSH * 100000000 + values[0];
            }

            if (valueGroups[0].Count() == 4)
            {
                return FOUR_OF_A_KIND * 100000000 + valueGroups[0].Key;
            }

            if (valueGroups[0].Count() == 3 && valueGroups[1].Count() == 2)
            {
                return FULL_HOUSE * 100000000 + valueGroups[0].Key * 10000 + valueGroups[1].Key;
            }

            if (isFlush)
            {
                return FLUSH * 100000000;
            }

            if (isStraight)
            {
                return STRAIGHT * 100000000 + values[0];
            }

            if (valueGroups[0].Count() == 3)
            {
                return THREE_OF_A_KIND * 100000000 + valueGroups[0].Key;
            }

            if (valueGroups[0].Count() == 2 && valueGroups[1].Count() == 2)
            {
                return TWO_PAIR * 100000000 + valueGroups[0].Key * 10000 + valueGroups[1].Key;
            }

            if (valueGroups[0].Count() == 2)
            {
                return PAIR * 100000000 + valueGroups[0].Key;
            }

            return HIGH_CARD * 100000000 + values[0];
        }

        private static bool IsStraight(List<Card> cards)
        {
            var values = cards.Select(c => GetCardValue(c)).OrderBy(v => v).ToList();

            if (values.SequenceEqual(new[] { 2, 3, 4, 5, 14 }))
                return true;

            for (int i = 1; i < values.Count; i++)
            {
                if (values[i] != values[i - 1] + 1)
                    return false;
            }

            return true;
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

        private static IEnumerable<IEnumerable<T>> GetCombinations<T>(IEnumerable<T> list, int length)
        {
            if (length == 1) return list.Select(t => new T[] { t });

            return GetCombinations(list, length - 1)
                .SelectMany(t => list.Where(o => !t.Contains(o)),
                    (t1, t2) => t1.Concat(new T[] { t2 }));
        }
    }
}