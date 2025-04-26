using System;
using System.Collections.Generic;
using System.Linq;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Services
{
    public static class PokerHandEvaluator
    {
        // Hand rankings from lowest to highest
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

        // Evaluates a hand of 5-7 cards and returns a numeric value representing its strength
        public static int EvaluateHand(List<Card> cards)
        {
            if (cards.Count < 5)
                throw new ArgumentException("Need at least 5 cards to evaluate a hand");

            // For 7-card hands (2 hole cards + 5 community), we need to find the best 5-card combination
            if (cards.Count > 5)
            {
                return FindBestFiveCardHand(cards);
            }

            return EvaluateFiveCardHand(cards);
        }

        private static int FindBestFiveCardHand(List<Card> cards)
        {
            // Generate all possible 5-card combinations from the 7 cards
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
            // Check for flush (all cards of the same suit)
            bool isFlush = cards.Select(c => c.Suit).Distinct().Count() == 1;

            // Check for straight (consecutive card values)
            bool isStraight = IsStraight(cards);

            // Get card values for evaluation
            var values = cards.Select(c => GetCardValue(c)).OrderByDescending(v => v).ToList();

            // Group cards by value to find pairs, three of a kind, etc.
            var valueGroups = cards.GroupBy(c => GetCardValue(c))
                .OrderByDescending(g => g.Count())
                .ThenByDescending(g => g.Key)
                .ToList();

            // Royal Flush: A, K, Q, J, 10 of the same suit
            if (isFlush && isStraight && values.Contains(14) && values.Contains(13))
            {
                return ROYAL_FLUSH * 100000000;
            }

            // Straight Flush: Five consecutive cards of the same suit
            if (isFlush && isStraight)
            {
                return STRAIGHT_FLUSH * 100000000 + values[0];
            }

            // Four of a Kind: Four cards of the same value
            if (valueGroups[0].Count() == 4)
            {
                return FOUR_OF_A_KIND * 100000000 + valueGroups[0].Key;
            }

            // Full House: Three cards of one value and two of another
            if (valueGroups[0].Count() == 3 && valueGroups[1].Count() == 2)
            {
                return FULL_HOUSE * 100000000 + valueGroups[0].Key * 10000 + valueGroups[1].Key;
            }

            // Flush: Five cards of the same suit
            if (isFlush)
            {
                return FLUSH * 100000000;
            }

            // Straight: Five consecutive cards
            if (isStraight)
            {
                return STRAIGHT * 100000000 + values[0];
            }

            // Three of a Kind: Three cards of the same value
            if (valueGroups[0].Count() == 3)
            {
                return THREE_OF_A_KIND * 100000000 + valueGroups[0].Key;
            }

            // Two Pair: Two cards of one value and two cards of another value
            if (valueGroups[0].Count() == 2 && valueGroups[1].Count() == 2)
            {
                return TWO_PAIR * 100000000 + valueGroups[0].Key * 10000 + valueGroups[1].Key;
            }

            // Pair: Two cards of the same value
            if (valueGroups[0].Count() == 2)
            {
                return PAIR * 100000000 + valueGroups[0].Key;
            }

            // High Card: Highest value card
            return HIGH_CARD * 100000000 + values[0];
        }

        private static bool IsStraight(List<Card> cards)
        {
            var values = cards.Select(c => GetCardValue(c)).OrderBy(v => v).ToList();

            // Check for A-5 straight (Ace can be low)
            if (values.SequenceEqual(new[] { 2, 3, 4, 5, 14 }))
                return true;

            // Check for normal straight
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