import random
from typing import List, Dict, Tuple, Optional
from enum import Enum, auto
from itertools import combinations
from collections import Counter
from .deck import Deck
from .player import Player
from .card import Card

class Action(Enum):
    FOLD = auto()
    CALL = auto()
    RAISE = auto()

class PokerGame:
    def __init__(self, num_players: int = 2, small_blind: int = 10, big_blind: int = 20) -> None:
        self.num_players = num_players
        self.small_blind = small_blind
        self.big_blind = big_blind
        self.dealer_index = 0
        self.deck = Deck()
        self.players: List[Player] = [Player(i) for i in range(num_players)]
        self.community_cards: List[Card] = []
        self.pot: int = 0
        self.round_stage: str = "pre-flop"
        # Track whose turn it is during a betting round.
        self.current_player_index: int = 0
        # Flag indicating if the current hand is over.
        self.hand_over: bool = False

    def reset(self) -> None:
        self.deck = Deck()
        for p in self.players:
            p.reset()
        self.community_cards = []
        self.pot = 0
        self.round_stage = "pre-flop"
        self.hand_over = False
        self.deal_hole_cards()
        self.post_blinds()
        self.set_initial_turn()

    def set_initial_turn(self) -> None:
        """Determine which player acts first in pre-flop."""
        if self.num_players == 2:
            # In heads-up, the dealer (small blind) acts first pre-flop.
            self.current_player_index = self.dealer_index
        else:
            # In multi-player, first to act is the player to the left of the big blind.
            self.current_player_index = (self.dealer_index + 3) % self.num_players

    def post_blinds(self) -> None:
        """Posts the blinds for the appropriate players."""
        if self.num_players == 2:
            # Heads-up: dealer posts small blind, other posts big blind.
            small_blind_player = self.players[self.dealer_index]
            big_blind_player = self.players[(self.dealer_index + 1) % self.num_players]
        else:
            small_blind_player = self.players[(self.dealer_index + 1) % self.num_players]
            big_blind_player = self.players[(self.dealer_index + 2) % self.num_players]
        small_amount = min(self.small_blind, small_blind_player.chips)
        big_amount = min(self.big_blind, big_blind_player.chips)
        small_blind_player.chips -= small_amount
        small_blind_player.current_bet += small_amount
        small_blind_player.total_bet += small_amount
        big_blind_player.chips -= big_amount
        big_blind_player.current_bet += big_amount
        big_blind_player.total_bet += big_amount
        self.pot += small_amount + big_amount

    def deal_hole_cards(self) -> None:
        """Deal two cards to each player."""
        for p in self.players:
            p.hand = self.deck.draw(2)

    def deal_community_cards(self, n: int) -> None:
        """Deal n community cards."""
        self.community_cards.extend(self.deck.draw(n))

    def next_round(self) -> None:
        # Reset bets at the start of a new round.
        for p in self.players:
            p.current_bet = 0
        if self.round_stage == "pre-flop":
            self.round_stage = "flop"
            self.deal_community_cards(3)
        elif self.round_stage == "flop":
            self.round_stage = "turn"
            self.deal_community_cards(1)
        elif self.round_stage == "turn":
            self.round_stage = "river"
            self.deal_community_cards(1)
        elif self.round_stage == "river":
            # Instead of just changing the round stage to showdown,
            # immediately process the showdown.
            self.round_stage = "showdown"
            winner = self.determine_winner()
            self.players[winner].chips += self.pot
            self.hand_over = True
            return  # Do not update current_player_index further.
        # Update turn for the new round only if the hand is not over.
        if not self.hand_over:
            self.current_player_index = self.get_first_active_player_index()


    def get_first_active_player_index(self) -> int:
        """Returns the index of the first player able to act (not folded/all-in)."""
        start = (self.dealer_index + 1) % self.num_players
        for i in range(self.num_players):
            idx = (start + i) % self.num_players
            if not self.players[idx].folded and not self.players[idx].all_in:
                return idx
        return start

    def get_next_active_player_index(self, current_index: int) -> int:
        """Returns the index of the next active player after current_index."""
        for i in range(1, self.num_players):
            idx = (current_index + i) % self.num_players
            if not self.players[idx].folded and not self.players[idx].all_in:
                return idx
        return current_index

    def get_call_amount(self, pid: int) -> int:
        max_bet: int = max(p.current_bet for p in self.players if not p.folded)
        return max_bet - self.players[pid].current_bet

    def step(self, action: Action, amount: Optional[int] = None) -> None:
        """
        Processes an action for the current player, updates game state,
        and advances turn or betting round as necessary.
        """
        if self.hand_over:
            return

        player = self.players[self.current_player_index]
        # Skip players who have folded or are all-in.
        if player.folded or player.all_in:
            self.current_player_index = self.get_next_active_player_index(self.current_player_index)
            return

        # Process the chosen action.
        if action == Action.FOLD:
            player.folded = True
        elif action == Action.CALL:
            call_amt = self.get_call_amount(self.current_player_index)
            if player.chips <= call_amt:
                # Go all-in if insufficient chips.
                actual_bet = player.chips
                player.current_bet += actual_bet
                player.total_bet += actual_bet
                self.pot += actual_bet
                player.chips = 0
                player.all_in = True
            else:
                player.chips -= call_amt
                player.current_bet += call_amt
                player.total_bet += call_amt
                self.pot += call_amt
        elif action == Action.RAISE:
            if amount is None:
                raise ValueError("RAISE action requires an amount.")
            call_amt = self.get_call_amount(self.current_player_index)
            total_required = call_amt + amount
            if player.chips <= total_required:
                total = player.chips
                player.current_bet += total
                player.total_bet += total
                self.pot += total
                player.chips = 0
                player.all_in = True
            else:
                player.chips -= total_required
                player.current_bet += total_required
                player.total_bet += total_required
                self.pot += total_required

        # Check if the betting round is over.
        if self.is_round_over():
            if self.round_stage != "showdown":
                self.next_round()
            else:
                # In showdown, determine the winner, award the pot, and mark hand as over.
                winner = self.determine_winner()
                self.players[winner].chips += self.pot
                self.hand_over = True
                return

        # Advance turn to the next active player.
        self.current_player_index = self.get_next_active_player_index(self.current_player_index)

    def is_round_over(self) -> bool:
        """
        A betting round is over if either only one player remains
        or every player able to act has matched the highest bet.
        """
        active = [p for p in self.players if not p.folded]
        if len(active) <= 1:
            return True
        max_bet = max(p.current_bet for p in active)
        for p in active:
            if not p.all_in and p.current_bet != max_bet:
                return False
        return True

    def rotate_dealer(self) -> None:
        """Rotates the dealer for the next hand."""
        self.dealer_index = (self.dealer_index + 1) % self.num_players

    def determine_winner(self) -> Optional[int]:
        """
        Determines the winner at showdown.
        If one player remains, that player wins automatically.
        Otherwise, side pot calculations are used based on best hand evaluation.
        """
        active = [p for p in self.players if not p.folded]
        if len(active) == 1:
            return active[0].player_id
        winnings = self.showdown()
        max_win = max(winnings.values())
        winners = [pid for pid, win in winnings.items() if win == max_win]
        return random.choice(winners)

    def evaluate_best_hand(self, player: Player) -> Tuple:
        """Returns the best 5-card hand value from player's cards and community cards."""
        all_cards = player.hand + self.community_cards
        return self.best_hand(all_cards)

    def best_hand(self, cards: List[Card]) -> Tuple:
        best = None
        for combo in combinations(cards, 5):
            value = self.evaluate_five(list(combo))
            if best is None or value > best:
                best = value
        return best

    def evaluate_five(self, cards: List[Card]) -> Tuple:
        """
        Evaluates a 5-card hand and returns a tuple (hand_rank, kicker_list),
        where higher tuples denote better hands.
        Rankings:
          8: Straight Flush
          7: Four of a Kind
          6: Full House
          5: Flush
          4: Straight
          3: Three of a Kind
          2: Two Pair
          1: One Pair
          0: High Card
        """
        ranks_str = "23456789TJQKA"
        rank_values = {r: i+2 for i, r in enumerate(ranks_str)}
        card_ranks = []
        card_suits = []
        for card in cards:
            s = str(card)
            card_ranks.append(rank_values[s[0]])
            card_suits.append(s[1])
        card_ranks.sort(reverse=True)
        is_flush = len(set(card_suits)) == 1

        unique_ranks = sorted(set(card_ranks), reverse=True)
        is_straight = False
        straight_high = None
        if len(unique_ranks) >= 5:
            for i in range(len(unique_ranks) - 4):
                if unique_ranks[i] - unique_ranks[i+4] == 4:
                    is_straight = True
                    straight_high = unique_ranks[i]
                    break
            if set([14, 2, 3, 4, 5]).issubset(set(card_ranks)):
                is_straight = True
                straight_high = 5

        counts = Counter(card_ranks)
        count_values = sorted(counts.values(), reverse=True)
        if is_flush and is_straight:
            hand_rank = 8
            kicker = [straight_high]
        elif 4 in count_values:
            hand_rank = 7
            four_rank = [rank for rank, cnt in counts.items() if cnt == 4][0]
            kicker = [r for r in card_ranks if r != four_rank]
        elif 3 in count_values and 2 in count_values:
            hand_rank = 6
            three_rank = max([rank for rank, cnt in counts.items() if cnt == 3])
            pair_rank = max([rank for rank, cnt in counts.items() if cnt == 2])
            kicker = [three_rank, pair_rank]
        elif is_flush:
            hand_rank = 5
            kicker = card_ranks
        elif is_straight:
            hand_rank = 4
            kicker = [straight_high]
        elif 3 in count_values:
            hand_rank = 3
            three_rank = [rank for rank, cnt in counts.items() if cnt == 3][0]
            remaining = sorted([r for r in card_ranks if r != three_rank], reverse=True)
            kicker = [three_rank] + remaining
        elif count_values.count(2) >= 2:
            hand_rank = 2
            pairs = sorted([rank for rank, cnt in counts.items() if cnt == 2], reverse=True)
            kicker = pairs + sorted([r for r in card_ranks if r not in pairs], reverse=True)
        elif 2 in count_values:
            hand_rank = 1
            pair_rank = [rank for rank, cnt in counts.items() if cnt == 2][0]
            kicker = [pair_rank] + sorted([r for r in card_ranks if r != pair_rank], reverse=True)
        else:
            hand_rank = 0
            kicker = card_ranks
        return (hand_rank, kicker)

    def showdown(self) -> Dict[int, int]:
        """
        Implements side-pot calculations:
         1. Each active player's total bet is considered their contribution.
         2. Side pots are created by “peeling off” the smallest contributions.
         3. For each pot, the best hand among eligible players wins that portion.
         4. The pot is split equally among winners.
        Returns a mapping of player_id to chips won.
        """
        active_players = [p for p in self.players if not p.folded]
        if len(active_players) == 1:
            return {active_players[0].player_id: self.pot}
        contributions = {p.player_id: p.total_bet for p in active_players}
        pots = []
        sorted_contrib = sorted(contributions.items(), key=lambda x: x[1])
        previous = 0
        for pid, bet in sorted_contrib:
            eligible = [pid2 for pid2, bet2 in contributions.items() if bet2 >= bet]
            pot_amount = (bet - previous) * len(eligible)
            pots.append((pot_amount, eligible))
            previous = bet
        winnings = {p.player_id: 0 for p in active_players}
        hand_values = {p.player_id: self.evaluate_best_hand(p) for p in active_players}
        for pot_amount, eligible in pots:
            best_value = None
            pot_winners = []
            for pid in eligible:
                val = hand_values[pid]
                if best_value is None or val > best_value:
                    best_value = val
                    pot_winners = [pid]
                elif val == best_value:
                    pot_winners.append(pid)
            split = pot_amount // len(pot_winners)
            for pid in pot_winners:
                winnings[pid] += split
        return winnings
