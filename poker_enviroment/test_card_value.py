import time
from collections import defaultdict
from agents.pseudo_inteligent_agent import PseudoIntelligent
from agents.random_agent import RandomAgent
from agents.console_player import ConsolePlayer
from game import Card, Suit, Rank
from impoved_dqn_agent import DQNAgent
import torch
from game.poker_game import Action
from enviroment import PokerEnv

print_stats_every = 50

import random
from collections import Counter

# Full deck (52 cards)
suits = ['♡', '♢', '♧', '♤']
ranks = ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']
deck = [rank + suit for suit in suits for rank in ranks]
random.shuffle(deck)

# Define hand names
card_values = {
    8: "Straight Flush",
    7: "Four of a Kind",
    6: "Full House",
    5: "Flush",
    4: "Straight",
    3: "Three of a Kind",
    2: "Two Pair",
    1: "One Pair",
    0: "High Card"
}


def _encode_card( card_str: str) -> int:
    """
    Encodes a card string (e.g. "A♡" for Ace of Hearts) into an integer (0-51).
    """
    ranks = "23456789TJQKA"
    suits = "♡♢♧♤"

    return suits.index(card_str[1]) * 13 + ranks.index(card_str[0])

# Utility functions
def draw_cards(n):
    hand = deck[:n]
    del deck[:n]
    return hand

def generate_straight_flush():
    suit = random.choice(suits)
    # Max start index for 5-card straight: 13 (ranks) - 5 = 8
    start_idx = random.randint(0, len(ranks) - 5)
    straight_ranks = ranks[start_idx:start_idx + 5]
    straight_flush = [rank + suit for rank in straight_ranks]
    return straight_flush


def generate_four_of_a_kind():
    four_rank = random.choice(ranks)
    # Four cards of the same rank, all suits
    four_cards = [four_rank + suit for suit in suits]

    # Pick kicker rank different from four_rank
    kicker_ranks = [r for r in ranks if r != four_rank]
    kicker_rank = random.choice(kicker_ranks)
    # Pick kicker suit randomly
    kicker_suit = random.choice(suits)
    kicker = kicker_rank + kicker_suit

    hand = four_cards + [kicker]
    random.shuffle(hand)  # Shuffle to mix kicker position
    return hand

def generate_full_house():
    trip_rank = random.choice(ranks)
    pair_ranks = [r for r in ranks if r != trip_rank]
    pair_rank = random.choice(pair_ranks)

    trip_suits = random.sample(suits, 3)
    pair_suits = random.sample(suits, 2)

    trips = [trip_rank + suit for suit in trip_suits]
    pair = [pair_rank + suit for suit in pair_suits]

    hand = trips + pair
    random.shuffle(hand)  # Mix cards order

    return hand


def generate_flush():
    suit = random.choice(suits)
    flush_cards = random.sample(ranks, 5)  # pick 5 distinct ranks

    # Make sure it's NOT a straight: check if ranks are consecutive
    # Convert ranks to their indices
    rank_indices = sorted([ranks.index(card) for card in flush_cards])

    # Check for straight (consecutive indices)
    is_straight = all(rank_indices[i] + 1 == rank_indices[i + 1] for i in range(len(rank_indices) - 1))

    # If straight, reshuffle until no straight
    while is_straight:
        flush_cards = random.sample(ranks, 5)
        rank_indices = sorted([ranks.index(card) for card in flush_cards])
        is_straight = all(rank_indices[i] + 1 == rank_indices[i + 1] for i in range(len(rank_indices) - 1))

    hand = [rank + suit for rank in flush_cards]
    random.shuffle(hand)
    return hand


def generate_straight():
    # Pick a start index so that we can get 5 consecutive ranks
    start = random.randint(0, len(ranks) - 5)  # e.g. from 0 to 8 inclusive

    straight_ranks = ranks[start:start + 5]  # consecutive ranks

    # Assign a random suit for each card, suits can vary
    hand = [rank + random.choice(suits) for rank in straight_ranks]

    random.shuffle(hand)
    return hand

def generate_three_of_a_kind():
    # Pick the rank for the three of a kind
    three_rank = random.choice(ranks)
    # Pick 3 suits for this rank
    three_suits = random.sample(suits, 3)
    three_cards = [three_rank + suit for suit in three_suits]

    # Remaining 4 cards: pick ranks different from three_rank
    remaining_ranks = [r for r in ranks if r != three_rank]
    remaining_cards = []

    while len(remaining_cards) < 4:
        rank = random.choice(remaining_ranks)
        suit = random.choice(suits)
        card = rank + suit
        # Ensure no duplicates
        if card not in remaining_cards:
            remaining_cards.append(card)

    hand = three_cards + remaining_cards
    random.shuffle(hand)
    return hand


def generate_two_pair():
    # Pick two distinct ranks for the pairs
    pair_ranks = random.sample(ranks, 2)

    # For each pair rank, pick 2 suits
    first_pair_suits = random.sample(suits, 2)
    second_pair_suits = random.sample(suits, 2)

    first_pair = [pair_ranks[0] + s for s in first_pair_suits]
    second_pair = [pair_ranks[1] + s for s in second_pair_suits]

    # Remaining cards: pick 3 cards not using pair ranks
    remaining_ranks = [r for r in ranks if r not in pair_ranks]
    remaining_cards = []

    while len(remaining_cards) < 3:
        rank = random.choice(remaining_ranks)
        suit = random.choice(suits)
        card = rank + suit
        if card not in remaining_cards:
            remaining_cards.append(card)

    hand = first_pair + second_pair + remaining_cards
    random.shuffle(hand)
    return hand


def generate_one_pair():
    # Pick one rank for the pair
    pair_rank = random.choice(ranks)

    # Pick 2 suits for the pair
    pair_suits = random.sample(suits, 2)
    pair = [pair_rank + s for s in pair_suits]

    # Remaining ranks (excluding the pair rank)
    remaining_ranks = [r for r in ranks if r != pair_rank]

    # Pick 5 distinct ranks from remaining ranks
    other_ranks = random.sample(remaining_ranks, 5)

    remaining_cards = []
    for rank in other_ranks:
        suit = random.choice(suits)
        card = rank + suit
        remaining_cards.append(card)

    hand = pair + remaining_cards
    random.shuffle(hand)
    return hand


def generate_high_card():
    # Pick 7 different ranks (no pairs)
    selected_ranks = random.sample(ranks, 7)

    # For each rank, pick a random suit
    hand = [rank + random.choice(suits) for rank in selected_ranks]

    # Ensure no flush: check suits, if all same suit, reshuffle suits for at least one card
    suits_in_hand = [card[1] for card in hand]
    if len(set(suits_in_hand)) == 1:
        # Change suit of one random card
        idx = random.randint(0, 6)
        available_suits = [s for s in suits if s != suits_in_hand[0]]
        hand[idx] = hand[idx][0] + random.choice(available_suits)
    return hand


# Build examples
examples = {
    8: generate_straight_flush(),
    7: generate_four_of_a_kind(),
    6: generate_full_house(),
    5: generate_flush(),
    4: generate_straight(),
    3: generate_three_of_a_kind(),
    2: generate_two_pair(),
    1: generate_one_pair(),
    0: generate_high_card()
}

def test_card_value(model_path='dqn_model.pth', num_hands=5, render_speed=0.7):
    dqn_agent = DQNAgent(player_id=0)
    dqn_agent.model.load_state_dict(torch.load(model_path, map_location=torch.device('cpu')))
    dqn_agent.model.eval()
    dqn_agent.epsilon=0

    agents = [dqn_agent] + [PseudoIntelligent() for _ in range(3)]
    # agents = [dqn_agent] + [DQNAgent(player_id=i + 1) for i in range(2)] + [RandomAgent()]
    #
    # # Load models
    # agents[1].model.load_state_dict(torch.load('./models/2025-04-22_23-51-42-711/dqn_model.pth'))
    # agents[1].epsilon = 0
    # agents[2].model.load_state_dict(torch.load('./models/2025-04-19_13-11-31-302/dqn_model.pth'))
    # agents[2].epsilon = 0
    hands_played = 0
    actions_by_stage = defaultdict(lambda: {a: 0 for a in (Action.CALL, Action.RAISE, Action.FOLD)})
    print("Starting a new sim...\n")
    #env.render()
    while hands_played < num_hands:

        if hands_played % print_stats_every == 0:
            print(hands_played)

        for i in range(9):
            cards= examples[i]
            pocket_cards = [_encode_card(card) for card in cards[0:2]]
            community_cards=[_encode_card(card) for card in cards[2:7]]
            while len(community_cards) < 5:
                community_cards.append(-1)

            chips = []
            for j in range(4):
                temp = random.randint(0, 800)
                chips.append(temp)

            pot = 4000-sum(chips)

            others_folds = [0, 0, 0]
            folds = random.randint(0, 2)

            # Randomly choose `folds` unique indices and set them to 1
            fold_indices = random.sample(range(3), folds)
            for idx in fold_indices:
                others_folds[idx] = 1

            obs = {"hand": pocket_cards, "community_cards": community_cards, "call_amount": 0, "chips": chips[0],
                   "others_chips": chips[1:4], "others_folded": others_folds, "pot": pot}
            action, amount = dqn_agent.act(obs)

            actions_by_stage[i][action] += 1
        hands_played+=1

    # print(f"Actions made: {actions_made}")
    print("\nAkcje modelu rozbite na ręce (best_hand rank):")
    for hand_rank in sorted(actions_by_stage.keys()):
        print(f"\n{card_values[hand_rank]}:")
        for action in actions_by_stage[hand_rank]:
            print(f"  {action.name}: {actions_by_stage[hand_rank][action]}")

if __name__ == "__main__":
    test_card_value(
        model_path='best_models/harmfull/dqn_model.pth',
        num_hands=2000,
        render_speed=0  # Set to 0 for fast execution
    )
