from collections import Counter
from itertools import combinations
import random

GAME_BUY_IN = 300
GAME_BIG_BLIND = 8

BIG_BLIND_VALUES = [8, 12, 16, 20, 30, 50, 100, 150, 200, 400, 600, 800, 1000]

PLAY_STYLES = {
    # numbers for number generator fold, call, raise, bluff,raise chance when bluffing
    "RANDOM": [33, 80, 99, 25, 50],
    "CAUTIOUS": 1,
    "BLUFF": 2,
    "RAISER": 3,
    "MODEL": 4,
}

CARDS = [
    "2C", "2D", "2H", "2S",
    "3C", "3D", "3H", "3S",
    "4C", "4D", "4H", "4S",
    "5C", "5D", "5H", "5S",
    "6C", "6D", "6H", "6S",
    "7C", "7D", "7H", "7S",
    "8C", "8D", "8H", "8S",
    "9C", "9D", "9H", "9S",
    "10C", "10D", "10H", "10S",
    "11C", "11D", "11H", "11S",
    "12C", "12D", "12H", "12S",
    "13C", "13D", "13H", "13S",
    "14C", "14D", "14H", "14S"
]

HAND_RANKS = {
    "High Card": 0,
    "One Pair": 1,
    "Two Pair": 2,
    "Three of a Kind": 3,
    "Straight": 4,
    "Flush": 5,
    "Full House": 6,
    "Four of a Kind": 7,
    "Straight Flush": 8,
}


class Game:
    players = []
    round = 0
    big_blind = GAME_BIG_BLIND
    current_pot_value = 0
    current_call_bid_value = 0
    community_cards = []
    current_player_index = -1

    game_state = -1
    # game states:
    # -1 game ni=ot initialized
    # 0 cards dealt and blinds set no community cards
    # 1 flop we add 3 community cards
    # 2 turn we add 1 community card
    # 3 river we add 1 community card
    # 4 showdown we check for a round winner
    # 5 after showdown check if the table has a winner

    winner = None
    available_cards = set(CARDS)

    def add_player(self, player):
        self.players.append(player)

    def increase_blind_value(self):
        for num in BIG_BLIND_VALUES:
            if num > self.big_blind:
                self.big_blind = num

    def make_bid(self, player, bid):
        # player does not have enough chips so he is all in
        if bid >= player.chips:
            player.is_all_in = True
            player.last_action = "ALL IN"
            player.current_bid += player.chips
            self.current_pot_value += player.chips
            player.chips = 0
            if player.current_bid > self.current_call_bid_value:
                self.current_call_bid_value = player.current_bid
            return

        # regular bid
        player.current_bid += bid
        player.chips -= bid
        self.current_pot_value += bid
        if player.current_bid > self.current_call_bid_value:
            self.current_call_bid_value = player.current_bid

    def make_call(self, player):
        self.make_bid(player, self.current_call_bid_value - player.current_bid)
        player.last_action = "Call/Check"

    def raise_bid(self, player):
        amount_to_raise = self.current_call_bid_value - player.current_bid
        raise_factor = random.randrange(self.big_blind, self.big_blind * 2)
        self.make_bid(player, amount_to_raise + raise_factor)
        player.last_action = "Raise"

    def bluff(self, player):
        player.is_bluffing = True
        if random.randrange(0, 100) < player.play_style[4]:
            # Player will raise when bluffing
            self.raise_bid(player)
        else:
            self.make_call(player)

    def fold(self, player):
        player.best_hand = None
        player.hand_score = None
        player.last_action = "Folded"
        player.has_folded = True

    def all_in(self, player):
        self.make_bid(player, player.chips)
        player.last_action = "ALL IN"

    # Creates score for how good the hand is for action chances
    def evaluate_player_hands(self):
        for player in self.players:
            if self.community_cards:
                temp_hand_info = get_best_hand(player.pocket + self.community_cards)
                player.best_hand_rank = temp_hand_info.hand_rank
                player.best_hand = temp_hand_info.hand


            # Random player
            if player.play_style == PLAY_STYLES["RANDOM"]:
                player.hand_score = 50

            # Cautious player prefers to play with good hand rarely bluffs
            if player.play_style == PLAY_STYLES["CAUTIOUS"]:
                # No community cards
                if not self.community_cards:
                    # A pocket pair
                    if get_card_rank(player.pocket[0]) == get_card_rank(player.pocket[1]):
                        player.hand_score = 20 * get_card_rank(player.pocket[1])
                        continue
                    player.hand_score = 4 * (get_card_rank(player.pocket[0]) + get_card_rank(player.pocket[1]))
                    continue
                # Community cards
                player.hand_score = 30 * player.best_hand_rank

    def get_player_action(self, player):
        if player.is_all_in or player.is_busted or player.has_folded:
            return
        if player.play_style == PLAY_STYLES["RANDOM"]:
            random_integer = 0
            # Check if player is bluffing since he would not fold
            if player.is_bluffing:
                random_integer = random.randrange(player.play_style[0], 100)
            else:
                random_integer = random.randrange(0, 100)

            # Fold check
            if random_integer < player.play_style[0]:
                # Player considers folding so we check his hand score to make a decision
                if random.randrange(0, 100) < player.hand_score:
                    # Fold failed player will call
                    self.make_call(player)
                else:
                    # Player wants to fold
                    if random.randrange(0, 100) < player.play_style[3]:
                        # Player will bluff instead
                        self.bluff(player)
                    else:
                        self.fold(player)
            # Call/Check check
            elif random_integer < player.play_style[1]:

                self.make_call(player)
            # Raise check
            elif random_integer < player.play_style[2]:
                self.raise_bid(player)
            # All in check
            else:
                self.all_in(player)

    def set_blinds(self, is_game_start):

        if is_game_start:
            random_index = random.randrange(len(self.players))
            if random_index == len(self.players) - 1:
                self.players[0].blind_role = "BB"
                self.make_bid(self.players[0], self.big_blind)
                self.current_player_index = 1

                self.players[random_index].blind_role = "SB"
                self.make_bid(self.players[random_index], self.big_blind // 2)
                return

            self.players[random_index].blind_role = "SB"
            self.make_bid(self.players[random_index], self.big_blind // 2)
            self.players[random_index + 1].blind_role = "BB"
            self.make_bid(self.players[random_index + 1], self.big_blind)
            if random_index + 1 == len(self.players) - 1:
                self.current_player_index = 0
            else:
                self.current_player_index = random_index + 2
            return

        # resetting the blinds after a round
        old_big_blind_index = -1
        has_set_small_blind = False
        has_set_big_blind = False
        has_found_old_big_blind = False

        # remove the small blind role
        for player in self.players:
            if player.blind_role == "SB":
                player.blind_role = None

        i = 0
        while True:
            # go to the begining of the list
            if i >= len(self.players):
                i = 0

            # find big blind player
            if not has_found_old_big_blind and self.players[i].blind_role == "BB":
                has_found_old_big_blind = True
                self.players[i].blind_role = None

            # find new small blind player
            if not has_set_small_blind and has_found_old_big_blind:
                if not self.players[i].is_busted:
                    self.players[i].blind_role = "SB"
                    self.make_bid(self.players[i], self.big_blind // 2)
                    has_set_small_blind = True

            # find new big blind player
            if not has_set_big_blind and has_set_small_blind:
                if not self.players[i].is_busted and self.players[i].blind_role == None:
                    self.players[i].blind_role = "BB"
                    self.make_bid(self.players[i], self.big_blind)
                    has_set_big_blind = True

            if has_set_big_blind:
                if not self.players[i].is_busted and self.players[i].blind_role != "BB":
                    self.current_player_index = i
                    return

            i += 1

    def get_next_player_index(self):
        i = self.current_player_index + 1
        while True:
            if i >= len(self.players):
                i = 0
            if not self.players[i].is_busted and not self.players[i].has_folded and not self.players[i].is_all_in:
                self.current_player_index = i
                return
            i += 1

    def get_next_game_state_player_index(self):
        small_blind_index = -1
        # Find small blind player since he should start
        i = 0
        while True:
            # Find first playing player
            if self.players[i].blind_role == "SB":
                small_blind_index = i
            i += 1
            if i == len(self.players):
                i = 0
            if small_blind_index != -1:
                if not self.players[small_blind_index].has_folded:
                    self.current_player_index = small_blind_index
                    return
                small_blind_index = i

    def did_all_players_do_actions(self):
        for player in self.players:
            if player.is_all_in or player.has_folded or player.is_busted or (
                    player.current_bid == self.current_call_bid_value and player.last_action != "None"):
                continue
            else:
                return False
        return True

    def deal_community_cards(self, number_of_cards):
        for _ in range(number_of_cards):
            self.community_cards.append(self.available_cards.pop())

    def update_player_status_after_round(self):
        for player in self.players:
            player.current_bid = 0
            player.hand_score = 0
            player.pocket = []
            player.best_hand = None
            player.best_hand_rank = None
            player.last_action = "None"
            player.has_folded = False
            player.is_all_in = False
            player.is_bluffing = False

            if player.chips == 0:
                player.is_busted = True
        self.game_state = 5

    def find_round_winners(self):
        playing_players = []
        for player in self.players:
            if not player.is_busted and not player.has_folded:
                playing_players.append(player)

        best_players = []

        for player in playing_players:
            is_stronger = True

            for best in best_players:
                if player.best_hand_rank > best.best_hand_rank:
                    break
                if player.best_hand_rank < best.best_hand_rank:
                    is_stronger = False
                    break
                if compare_players_hands(player.best_hand, best.best_hand, player.best_hand_rank) == 1:
                    break
                if compare_players_hands(player.best_hand, best.best_hand, player.best_hand_rank) == -1:
                    is_stronger = False
                if compare_players_hands(player.best_hand, best.best_hand, player.best_hand_rank) == 0:
                    best_players.append(player)
                    is_stronger = False

            if is_stronger:
                best_players = [player]
        if len(best_players) == 1:
            best_players[0].chips += self.current_pot_value
            self.update_player_status_after_round()
        else:
            winners_bid = 0
            for player in best_players:
                winners_bid += player.current_bid

            for i in range(len(best_players)):
                # payout based on bid percentage
                payout = int(self.current_pot_value * (best_players[i].current_bid // winners_bid))
                best_players[i].chips += payout
                self.current_pot_value -= payout

                # Last winner
                if i == len(best_players) - 2:
                    best_players[i + 1].chips += self.current_pot_value
            self.update_player_status_after_round()

    def check_for_dead_players(self):
        active_players = 0
        for player in self.players:
            if not player.has_folded and not player.is_busted and not player.is_all_in:
                active_players += 1
        if active_players == 1:
            self.game_state = 4

    def deal_cards(self):
        for player in self.players:
            if not player.is_busted:
                player.pocket = [self.available_cards.pop(), self.available_cards.pop()]

    def advance_game_state(self):
        # start of a round
        if self.game_state == -1:
            self.deal_cards()
            if self.round == 0:
                self.set_blinds(True)
            else:
                self.set_blinds(False)
            self.game_state = 0
            self.evaluate_player_hands()
            return

        if self.game_state == 0:
            for player in self.players:
                if not player.is_busted and not player.has_folded and not player.is_all_in:
                    player.last_action = "None"
            self.deal_community_cards(3)
            self.evaluate_player_hands()
            self.game_state = 1
            return

        if self.game_state == 1 or self.game_state == 2:
            for player in self.players:
                if not player.is_busted and not player.has_folded and not player.is_all_in:
                    player.last_action = "None"
            self.deal_community_cards(1)
            self.evaluate_player_hands()
            self.game_state += 1
            return

        if self.game_state == 3:
            self.game_state = 4

    def start_new_round(self):
        self.game_state = -1
        self.winner = None
        self.available_cards = set(CARDS)
        self.current_pot_value = 0
        self.current_call_bid_value=self.big_blind
        self.community_cards = []

    def print_game_state(self):

        # waiting input
        a = input()

        base_string = "          |"
        string_holder = ""
        # Create border
        horizontal_border = ""
        for _ in range(len(self.players) + 1):
            horizontal_border += "___________"

        # Print first border
        print(horizontal_border)

        # Print Names
        string_holder += "names:    |"
        for player in self.players:
            string_holder += base_string[:0] + player.name + base_string[len(player.name):]
        print(string_holder)

        # Print turn display
        string_holder = "turn:     |"
        for i in range(len(self.players)):
            if i == self.current_player_index:
                string_holder += "**********|"
            else:
                string_holder += base_string
        print(string_holder)

        print(horizontal_border)
        string_holder = "last move:|"
        for player in self.players:
            string_holder += base_string[:0] + player.last_action + base_string[len(player.last_action):]
        print(string_holder)

        print(horizontal_border)
        # Print chips
        string_holder = "chips:    |"
        for player in self.players:
            string_holder += base_string[:0] + str(player.chips) + base_string[len(str(player.chips)):]
        print(string_holder)

        print(horizontal_border)
        # Print bids
        string_holder = "bids:     |"
        for player in self.players:
            string_holder += base_string[:0] + str(player.current_bid) + base_string[len(str(player.current_bid)):]
        print(string_holder)

        print(horizontal_border)
        # Print Buttons
        string_holder = "Role:     |"
        for player in self.players:
            if player.blind_role is None:
                string_holder += "          |"
            else:
                string_holder += base_string[:0] + player.blind_role + base_string[len(player.blind_role):]
        print(string_holder)

        print(horizontal_border)
        # Print if folded
        string_holder = "bluffing: |"
        for player in self.players:
            if player.is_bluffing:
                string_holder += "TRUE      |"
            else:
                string_holder += "False     |"
        print(string_holder)

        print(horizontal_border)
        # Print Pockets
        string_holder = "pockets:  |"
        for player in self.players:
            if len(player.pocket) < 1:
                string_holder += "          |"
            else:
                string_holder += base_string[:0] + player.pocket[0] + " " + player.pocket[1] + base_string[len(
                    player.pocket[0] + " " + player.pocket[1]):]
        print(string_holder)

        print(horizontal_border)
        # Print card rank
        string_holder = "rank:     |"
        for player in self.players:
            if player.best_hand_rank is not None:
                string_holder += base_string[:0] + str(player.best_hand_rank) + base_string[len(str(player.best_hand_rank)):]
            else:
                string_holder+="          |"
        print(string_holder)

        print(horizontal_border)
        print("call value: ", self.current_call_bid_value, " game state: ", self.game_state, " community cards: ",
              self.community_cards, " pot", self.current_pot_value)

    def start_game(self):

        if len(self.players) < 2:
            print("too few players, only: ", len(self.players), " players")
            return

        print("########## GAME STARTED ##########")

        # Check if only one player remains
        while True:

            if self.game_state == 5:
                playing_players = 0
                for player in self.players:
                    if not player.is_busted:
                        playing_players += 1
                        self.winner = player
                if playing_players == 1:
                    break
                # start new round since more than 1 player remains
                self.start_new_round()
                continue

            # Card dealing
            if self.game_state == -1:
                self.advance_game_state()

                # Showdown
            if self.game_state == 4:
                self.find_round_winners()
                self.round += 1
                if self.round % 5 == 0:
                    self.increase_blind_value()

            # Preflop, flop, turn, river
            if 0 <= self.game_state <= 3:
                self.get_player_action(self.players[self.current_player_index])
                self.print_game_state()
                # Check if there is more than 1 player still playing the round
                if self.players[self.current_player_index].last_action == "Folded":
                    self.check_for_dead_players()
                if self.did_all_players_do_actions():
                    self.advance_game_state()
                    self.get_next_game_state_player_index()
                    continue
                self.get_next_player_index()



        print("Table won by player named: ", self.winner.name)


class Hand_info:
    def __init__(self, hand, hand_rank):
        self.hand = hand
        self.hand_rank = hand_rank


class Player:
    name = None
    pocket = []
    best_hand = None
    best_hand_rank = None
    hand_score = None
    chips = GAME_BUY_IN
    blind_role = None
    current_bid = 0
    last_action = "None"

    is_bluffing = False
    is_all_in = False
    is_busted = False
    has_folded = False

    def __init__(self, play_style, name="none"):
        self.play_style = play_style
        self.name = name


def get_best_hand(cards):
    best_hand = Hand_info(None, -1)

    # Iterate through all 5-card combinations
    for hand in combinations(cards, 5):
        rank = evaluate_hand(hand)
        if rank > best_hand.hand_rank:
            best_hand = Hand_info(hand, rank)
        if rank == best_hand.hand_rank and compare_players_hands(hand, best_hand.hand, rank) == 1:
            best_hand = Hand_info(hand, rank)
    return best_hand


def evaluate_hand(hand):
    # Extract ranks and suits
    ranks = []
    suits = set()
    for card in hand:
        if len(card) == 3:
            ranks.append(int(card[:2]))
            suits.add(card[2])
        else:
            ranks.append(int(card[0]))
            suits.add(card[1])

    is_flush = len(suits) == 1
    is_straight = False
    if len(set(ranks)) == 5:
        if max(ranks) - min(ranks) == 4 or {2, 3, 4, 5, 14}.issubset(set(ranks)):
            is_straight = True

    if is_flush and is_straight:
        return HAND_RANKS["Straight Flush"]
    if is_straight:
        return HAND_RANKS["Straight"]
    if is_flush:
        return HAND_RANKS["Flush"]

    occurrences = sorted(Counter(ranks).values(), reverse=True)
    if occurrences[0] == 4:
        return HAND_RANKS["Four of a Kind"]
    if occurrences[0] == 3:
        if occurrences[1] == 2:
            return HAND_RANKS["Full House"]
        return HAND_RANKS["Three of a Kind"]
    if occurrences[0] == 2:
        if occurrences[1] == 2:
            return HAND_RANKS["Two Pair"]
        return HAND_RANKS["One Pair"]
    return HAND_RANKS["High Card"]


def get_card_rank(card):
    if len(card) == 3:
        return int(card[:2])
    return int(card[0])


def compare_players_hands(hand1, hand2, hand_rank):
    ranks1 = []
    ranks2 = []

    for card in hand1:
        if len(card) == 3:
            ranks1.append(int(card[:2]))
        else:
            ranks1.append(int(card[0]))
    for card in hand2:
        if len(card) == 3:
            ranks2.append(int(card[:2]))
        else:
            ranks2.append(int(card[0]))

    ranks1 = sorted(ranks1, reverse=True)
    ranks2 = sorted(ranks2, reverse=True)

    if hand_rank == HAND_RANKS["High Card"]:
        if (ranks1[0] > ranks2[0]):
            return 1
        if (ranks1[0] < ranks2[0]):
            return -1
        return 0

    count = Counter(ranks1)
    occurences1 = sorted(ranks1, key=lambda x: (-count[x], -x))
    count = Counter(ranks2)
    occurences2 = sorted(ranks2, key=lambda x: (-count[x], -x))

    if hand_rank == HAND_RANKS["One Pair"]:
        if occurences1[0] > occurences2[0]:
            return 1
        if occurences1[0] < occurences2[0]:
            return -1
        if occurences1[2] > occurences2[2]:
            return 1
        if occurences1[2] < occurences2[2]:
            return -1
        if occurences1[3] > occurences2[3]:
            return 1
        if occurences1[3] < occurences2[3]:
            return -1
        if occurences1[4] > occurences2[4]:
            return 1
        if occurences1[4] < occurences2[4]:
            return -1
        return 0

    if hand_rank == HAND_RANKS["Two Pair"]:
        if occurences1[0] > occurences2[0]:
            return 1
        if occurences1[0] < occurences2[0]:
            return -1
        if occurences1[2] > occurences2[2]:
            return 1
        if occurences1[2] < occurences2[2]:
            return -1
        if occurences1[4] > occurences2[4]:
            return 1
        if occurences1[4] < occurences2[4]:
            return -1
        return 0

    if hand_rank == HAND_RANKS["Three of a Kind"]:
        if occurences1[0] > occurences2[0]:
            return 1
        if occurences1[0] < occurences2[0]:
            return -1
        if occurences1[3] > occurences2[3]:
            return 1
        if occurences1[3] < occurences2[3]:
            return -1
        if occurences1[4] > occurences2[4]:
            return 1
        if occurences1[4] < occurences2[4]:
            return -1
        return 0

    if hand_rank == HAND_RANKS["Full House"]:
        if occurences1[0] > occurences2[0]:
            return 1
        if occurences1[0] < occurences2[0]:
            return -1
        if occurences1[3] > occurences2[3]:
            return 1
        if occurences1[3] < occurences2[3]:
            return -1
        return 0

    if hand_rank == HAND_RANKS["Four of a Kind"]:
        if occurences1[0] > occurences2[0]:
            return 1
        if occurences1[0] < occurences2[0]:
            return -1
        if occurences1[4] > occurences2[4]:
            return 1
        if occurences1[4] < occurences2[4]:
            return -1
        return 0

    if hand_rank == HAND_RANKS["Flush"]:
        if occurences1[0] > occurences2[0]:
            return 1
        if occurences1[0] < occurences2[0]:
            return -1
        if occurences1[1] > occurences2[1]:
            return 1
        if occurences1[1] < occurences2[1]:
            return -1
        if occurences1[2] > occurences2[2]:
            return 1
        if occurences1[2] < occurences2[2]:
            return -1
        if occurences1[3] > occurences2[3]:
            return 1
        if occurences1[3] < occurences2[3]:
            return -1
        if occurences1[4] > occurences2[4]:
            return 1
        if occurences1[4] < occurences2[4]:
            return -1
        return 0

    straight_rank1 = min(occurences1)
    straight_rank2 = min(occurences2)

    if hand_rank == HAND_RANKS["Straight"] or hand_rank == HAND_RANKS["Straight Flush"]:
        if straight_rank1 > straight_rank2:
            return 1
        if straight_rank1 < straight_rank2:
            return -1
        return 0

poker_game = Game()
poker_game.add_player(Player(PLAY_STYLES["RANDOM"], "bob"))
poker_game.add_player(Player(PLAY_STYLES["RANDOM"], "Jan Pawel"))
poker_game.add_player(Player(PLAY_STYLES["RANDOM"], "Konon"))
poker_game.add_player(Player(PLAY_STYLES["RANDOM"], "Major"))
poker_game.start_game()
