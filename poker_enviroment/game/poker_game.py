import math
import random
from typing import List, Dict, Tuple, Optional
from enum import Enum, auto
from itertools import combinations
from collections import Counter

from .deck import Deck
from .player import Player
from .card import Card, Suit, Rank


class Action(Enum):
    FOLD = auto()
    CALL = auto()
    RAISE = auto()

class PokerGame:
    def __init__(self, num_players: int = 2, small_blind: int = 10, big_blind: int = 20) -> None:
        self.num_players = num_players
        self.small_blind = small_blind
        self.big_blind = big_blind
        self.dealer_index = random.randint(0, self.num_players - 1)
        self.big_blind_index:int =-1
        self.deck = Deck()
        self.players: List[Player] = [Player(i) for i in range(num_players)]
        self.community_cards: List[Card] = []
        self.pot: int = 0
        self.round_stage: str = "pre-flop"
        self.current_player_index: int = 0
        self.hand_over: bool = False
        self.table_over: bool = False
        self.games_played: int = 0
        self.winners: Optional[List[int]] = None
        # A set of player indices that still need to act in the current betting round.
        self.pending_players: set = set()

    def reset(self) -> None:
        self.winners = None
        self.deck = Deck()
        for p in self.players:
            p.reset()
        active_players = [p for p in self.players if not p.busted]
        if len(active_players) == 1:
            self.games_played+=1
            print("\n#####Starting New Game#####\n")
            for p in self.players:
                p.prepare_for_new_game()
        self.community_cards = []
        self.pot = 0
        self.round_stage = "pre-flop"
        self.hand_over = False
        self.rotate_dealer()
        self.deal_hole_cards()
        self.post_blinds()
        self.set_initial_turn()
        self.pending_players = {i for i, p in enumerate(self.players) if not p.folded and not p.all_in and not p.busted}


    def set_initial_turn(self) -> None:
        """Determine which player acts first in pre-flop.
           Heads-up: dealer (small blind) acts first.
           Multi-player: first to act is the player to the left of the big blind.
        """
        index=self.dealer_index
        for _ in range(3):
            index=self.get_next_playing_player_index(index)
        self.current_player_index = index


    def post_blinds(self) -> None:
        """Posts the blinds for the appropriate players."""
        small_blind_player_index=self.get_next_playing_player_index(self.dealer_index)
        small_blind_player = self.players[small_blind_player_index]
        self.big_blind_index=self.get_next_playing_player_index(small_blind_player_index)
        big_blind_player = self.players[self.big_blind_index]
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
            if not p.busted:
                p.hand = self.deck.draw(2)

    def deal_community_cards(self, n: int) -> None:
        """Deal n community cards."""
        self.community_cards.extend(self.deck.draw(n))

    def next_round(self) -> None:
        for p in self.players:
            p.current_bet = 0
        if self.hand_over:
            self.pending_players = set()
            self.reset()
            return
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
            self.round_stage = "showdown"
            
            winnings = self.showdown()
            if winnings:
                for pid, amount_won in winnings.items():
                    print(f"Player {pid}, Won {amount_won}")
                    self.players[pid].chips += amount_won
                max_win = max(winnings.values())
                self.winners = [pid for pid, win in winnings.items() if win == max_win]
                print(f"Round ended winner: {self.winners}, Pot: {self.pot}")
                self.hand_over=True
                self.next_round()
            return

        # For post-flop rounds, choose the first actor based on button position.
        active = [i for i, p in enumerate(self.players) if not p.folded and not p.all_in and not p.busted]
        if active:
            self.current_player_index = self.get_next_playing_player_index(self.big_blind_index)
            self.pending_players = set(active)
        else:
            self.pending_players = set()

    def get_first_active_player_index(self) -> int:
        """Returns the index of the first pending player starting from the small blind."""
        start = (self.dealer_index + 1) % self.num_players
        for i in range(self.num_players):
            idx = (start + i) % self.num_players
            if idx in self.pending_players:
                return idx
        return start

    def get_next_pending_player(self, current_index: int) -> int:
        """Returns the next pending player after current_index in cyclic order."""
        for i in range(1, self.num_players + 1):
            idx = (current_index + i) % self.num_players
            if idx in self.pending_players:
                return idx
        return current_index

    def get_call_amount(self, pid: int) -> int:
        max_bet: int = max(p.current_bet for p in self.players if not p.folded)
        return max_bet - self.players[pid].current_bet

    def step(self, action: Action, amount: Optional[int] = None) -> None:
        if self.hand_over:
            self.next_round()
            return

        if self.players[self.current_player_index].busted:
            self.current_player_index = self.get_next_pending_player(self.current_player_index)
            return

        # Early check: if all players are either folded or all-in, finish the hand automatically.
        if all(p.folded or p.all_in or p.busted for p in self.players):
            while self.round_stage != "showdown":
                self.next_round()
                for p in self.players:
                    print(f"PID {p.player_id}, Busted {p.busted}, All-in {p.all_in}, Folded {p.folded}")
            self.hand_over = True
            return

        # Check if only one active (non-folded) player remains.
        active_players = [p for p in self.players if not p.folded and not p.busted and not p.all_in]
        if len(active_players) == 1:
            self.players[active_players[0].player_id].chips += self.pot
            self.hand_over = True
            return

        player = self.players[self.current_player_index]
        print(f"PID: {player.player_id}, Action {action}, Amount: {amount}, Chips: {player.chips},Pot: {self.pot}")
        if player.folded or player.all_in:
            self.pending_players.discard(self.current_player_index)
            self.current_player_index = self.get_next_pending_player(self.current_player_index)
            return

        if action == Action.FOLD:
            player.folded = True
        elif action == Action.CALL:
            call_amt = self.get_call_amount(self.current_player_index)
            if player.chips <= call_amt:
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
            if amount < call_amt:
                raise ValueError("Raise amount must be greater than the call amount.")
            
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
            # On a raise, reset pending players.
            self.pending_players = {i for i, p in enumerate(self.players) if not p.folded and not p.all_in and not p.busted}
            self.pending_players.discard(self.current_player_index)

        # Remove the current player from pending.
        self.pending_players.discard(self.current_player_index)

        if not self.pending_players:
            if self.round_stage != "showdown":
                self.next_round()
            else:
                self.hand_over = True
                return
        else:
            if self.current_player_index not in self.pending_players:
                self.current_player_index = self.get_next_pending_player(self.current_player_index)

    def rotate_dealer(self) -> None:
        """Rotates the dealer for the next hand."""
        index = (self.dealer_index + 1) % len(self.players)
        for _ in range(len(self.players)):
            if self.players[index%len(self.players)].chips>0:
                self.dealer_index=index%len(self.players)
                return
            index+=1

    def determine_winners(self) -> Optional[List[int]]:
        """Determine winners after showdown, handling ties by comparing winnings."""
        self.winners = self._determine_showdown_winners()
        return self.winners

    def _determine_showdown_winners(self) -> Optional[List[int]]:
        """Helper to compute showdown winners without side effects."""
        active = [p for p in self.players if not p.folded]
        if len(active) == 1:
            return [active[0].player_id]
        if not active:
            return None
        winnings = self.showdown()
        if not winnings:
            return None
        max_win = max(winnings.values())
        return [pid for pid, win in winnings.items() if win == max_win]

    def evaluate_best_hand(self, player: Player) -> None:
        """Returns the best 5-card hand value from player's cards and community cards."""
        all_cards = player.hand + self.community_cards
        player.best_hand["rank"],player.best_hand["hand"] = self.best_hand(all_cards)

    def best_hand(self, cards: List[Card]) -> Tuple:
        if len(cards) < 5:
            return (-1, [])
        best = None
        best_combo=None
        for combo in combinations(cards, 5):
            value,value_cards = self.evaluate_five(list(combo))
            if best is None or value > best:
                best = value
                best_combo = value_cards
            elif best==value:
                temp = self.compare_hands(best_combo,value_cards,value)
                if temp is not None:
                    best_combo = temp
        return best,best_combo

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
        if len(unique_ranks) >= 5:
            for i in range(len(unique_ranks) - 4):
                if unique_ranks[i] - unique_ranks[i+4] == 4:
                    is_straight = True
                    break
            if set([14, 2, 3, 4, 5]).issubset(set(card_ranks)):
                is_straight = True

        counts = Counter(card_ranks)
        count_values = sorted(counts.values(), reverse=True)
        hand = sorted(card_ranks, key=lambda x: (counts[x], x), reverse=True)
        if is_flush and is_straight:
            hand_rank = 8
        elif 4 in count_values:
            hand_rank = 7
        elif 3 in count_values and 2 in count_values:
            hand_rank = 6
        elif is_flush:
            hand_rank = 5
        elif is_straight:
            hand_rank = 4
        elif 3 in count_values:
            hand_rank = 3
        elif count_values.count(2) >= 2:
            hand_rank = 2
        elif 2 in count_values:
            hand_rank = 1
        else:
            hand_rank = 0
        return hand_rank, hand

    def compare_hands(self, hand1,hand2,hand_rank:int):
        match hand_rank:
            # Regular determination
            case 0 | 1 | 2 | 3 | 5 | 6 | 7:
                for c1,c2 in zip(hand1,hand2):
                    if c1 > c2:
                        return hand1
                    if c1 < c2:
                        return hand2
                return None
            # Straights
            case 4 | 8:
                # Straight values
                # 1-lowest possible
                # 2-regular
                # 3-highest
                h1_value=2
                h2_value=2
                if hand1[0]==14:
                    if hand1[1]==5:
                        h1_value=1
                    if hand1[1]==13:
                        h1_value=3
                if hand2[0]==14:
                    if hand2[1]==5:
                        h2_value=1
                    if hand2[1]==13:
                        h2_value=3
                if h1_value > h2_value:
                    return hand1
                elif h1_value < h2_value:
                    return hand2
                else:
                    for c1, c2 in zip(hand1, hand2):
                        if c1 > c2:
                            return hand1
                        if c1 < c2:
                            return hand2
                    return None
            case _:
                return None

    def test(self):
        """ For testin purposes """
        h1=[Card(Suit.HEARTS,Rank.ACE),Card(Suit.HEARTS,Rank.FOUR),Card(Suit.HEARTS,Rank.FIVE),Card(Suit.HEARTS,Rank.TWO),Card(Suit.HEARTS,Rank.THREE)]
        h2=[Card(Suit.HEARTS,Rank.THREE),Card(Suit.HEARTS,Rank.THREE),Card(Suit.HEARTS,Rank.THREE),Card(Suit.HEARTS,Rank.SIX),Card(Suit.HEARTS,Rank.SIX)]
        print(self.compare_hands([6,5,4,3,2],[13,12,11,10,9],4))


    def showdown(self) -> Dict[int, int]:
        """
        Implements side–pot calculations:
         1. Each active player's total bet is considered their contribution.
         2. Side pots are created by peeling off the smallest contributions.
         3. For each pot, the best hand among eligible players wins that portion.
         4. The pot is split equally among winners.
        Returns a mapping of player_id to chips won.
        """
        active_players = [p for p in self.players if not p.folded and not p.busted]
        if len(active_players) == 1:
            return {active_players[0].player_id: self.pot}

        winnings = {p.player_id: 0 for p in active_players}
        winning_players=active_players
        for p in active_players:
            self.evaluate_best_hand(p)
        best_rank=max(p.best_hand["rank"] for p in active_players)

        # Eliminate inferior hands by value
        for p in active_players:
            if p.best_hand["rank"] < best_rank:
                winning_players.remove(p)

        # If more than 1 player remains find best hands
        if len(winning_players) >1 :
            final_winners=[]
            best_player= None

            for p in winning_players:
                if best_player is None:
                    best_player = p
                    final_winners.append(p)
                else:
                    if p.best_hand["hand"] == best_player.best_hand["hand"]:
                        final_winners.append(p)
                    else:
                        temp = self.compare_hands(best_player.best_hand["hand"],p.best_hand["hand"],best_rank)
                        if temp is not None:
                            if p.best_hand["hand"] == temp:
                                best_player = p
                                final_winners= [p]
            winning_players=final_winners

        # Only 1 winner
        if len(winning_players) == 1:
            winnings[winning_players[0].player_id]=self.pot
            return winnings

        # More winners
        contributions = sorted(
            [[p.player_id, p.total_bet] for p in winning_players],
            key=lambda item: item[1]
        )
        all_contributions=sum(contribution[1] for contribution in contributions)

        pot_copy=self.pot
        for contribution in contributions:
            pot_winning = math.ceil(self.pot * (contribution[1] / all_contributions))
            if pot_winning >= pot_copy:
                winnings[contribution[0]]=pot_copy
            else:
                winnings[contribution[0]]=pot_winning
                pot_copy-=pot_winning
        return winnings


    def get_next_playing_player_index(self, player_index):
        index = (player_index + 1) % len(self.players)
        for _ in range(len(self.players)):
            if not self.players[index % len(self.players)].busted:
                return index % len(self.players)
            index += 1
    pass


