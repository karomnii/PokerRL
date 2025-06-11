from itertools import combinations
from collections import Counter
from typing import List, Tuple, Optional

import torch


class EncodedCardEvaluator:
    RANKS = "23456789TJQKA"
    SUITS = "♡♢♧♤"

    def _encode_card(self, card_str: str) -> int:
        return self.SUITS.index(card_str[1]) * 13 + self.RANKS.index(card_str[0])

    def _decode_card(self, card_int: int) -> str:
        return self.RANKS[card_int % 13] + self.SUITS[card_int // 13]

    def _decode_onehotencoded_card(self, vector: torch.Tensor) -> int:
        """
        Decodes a 17-dim one-hot vector back into a card index (0..51):
          - First 13 positions are rank
          - Next 4 positions are suit
        """
        if vector.shape[0] != 17:
            raise ValueError("Input vector must be of length 17.")

        rank = torch.argmax(vector[:13]).item()
        suit = torch.argmax(vector[13:17]).item()

        return suit * 13 + rank

    def _encode_onehotencoded_card(self, card: int) -> torch.Tensor:
        """
        Encodes a single card (0..51) into a 17-dim one-hot vector:
          - 13 for rank (0..12)
          - 4  for suit (0..3)
        """
        suit = card // 13
        rank = card % 13

        vector = torch.zeros(17)
        vector[rank] = 1.0
        vector[13 + suit] = 1.0
        return vector

    def _get_rank(self, card: int) -> int:
        return card % 13 + 2  # 2-14 (2 to Ace)

    def _get_suit(self, card: int) -> int:
        return card // 13  # 0 to 3

    def evaluate_best_hand(self, player_hand: List[int], community_cards: List[int]) -> Tuple[int, List[int]]:
        """Evaluates the best 5-card hand from encoded player's hand and community cards."""
        all_cards = player_hand + community_cards
        if len(all_cards) < 5:
            return -1, []
        best_rank = -1
        best_hand = None
        for combo in combinations(all_cards, 5):
            rank, value_hand = self.evaluate_five(list(combo))
            if best_hand is None or rank > best_rank:
                best_rank = rank
                best_hand = value_hand
            elif rank == best_rank:
                cmp = self.compare_hands(best_hand, value_hand, rank)
                if cmp is not None:
                    best_hand = cmp
        return best_rank, best_hand

    def evaluate_five(self, cards: List[int]) -> Tuple[int, List[int]]:
        """Evaluates a 5-card encoded hand."""
        ranks = [self._get_rank(c) for c in cards]
        suits = [self._get_suit(c) for c in cards]

        rank_counts = Counter(ranks)
        rank_count_values = sorted(rank_counts.values(), reverse=True)
        sorted_cards = sorted(cards, key=lambda x: (rank_counts[self._get_rank(x)], self._get_rank(x)), reverse=True)

        is_flush = len(set(suits)) == 1

        unique_ranks = sorted(set(ranks), reverse=True)
        is_straight = False

        # Normal straight
        if len(unique_ranks) >= 5:
            for i in range(len(unique_ranks) - 4):
                if unique_ranks[i] - unique_ranks[i + 4] == 4:
                    is_straight = True
                    break

        # Special case: wheel straight (A-2-3-4-5)
        if set([14, 2, 3, 4, 5]).issubset(set(ranks)):
            is_straight = True

        if is_flush and is_straight:
            hand_rank = 8  # Straight Flush
        elif 4 in rank_count_values:
            hand_rank = 7  # Four of a Kind
        elif 3 in rank_count_values and 2 in rank_count_values:
            hand_rank = 6  # Full House
        elif is_flush:
            hand_rank = 5  # Flush
        elif is_straight:
            hand_rank = 4  # Straight
        elif 3 in rank_count_values:
            hand_rank = 3  # Three of a Kind
        elif rank_count_values.count(2) >= 2:
            hand_rank = 2  # Two Pair
        elif 2 in rank_count_values:
            hand_rank = 1  # One Pair
        else:
            hand_rank = 0  # High Card

        return hand_rank, sorted_cards

    def compare_hands(self, hand1: List[int], hand2: List[int], rank: int) -> Optional[List[int]]:
        """
        Compares two 5-card encoded hands of the same rank.
        Returns the better hand or None if equal.
        """
        # Sort both hands according to rank frequency and rank value
        def sort_key(card, hand):
            r = self._get_rank(card)
            return (Counter([self._get_rank(c) for c in hand])[r], r)

        h1 = sorted(hand1, key=lambda c: sort_key(c, hand1), reverse=True)
        h2 = sorted(hand2, key=lambda c: sort_key(c, hand2), reverse=True)

        for c1, c2 in zip(h1, h2):
            r1 = self._get_rank(c1)
            r2 = self._get_rank(c2)
            if r1 > r2:
                return hand1
            elif r2 > r1:
                return hand2
        return None
