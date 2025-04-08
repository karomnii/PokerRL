from typing import List, Tuple, Optional
from game.poker_game import PokerGame, Action
from agents.iagent import IAgent

class PokerEnv:
    def __init__(self, agents: List[IAgent], small_blind: int = 10, big_blind: int = 20) -> None:
        """
        Initialize the Poker environment with a list of agents.
        The number of agents determines the number of players.
        """
        self.agents = agents
        self.num_players = len(agents)
        self.game = PokerGame(num_players=self.num_players, small_blind=small_blind, big_blind=big_blind)
        self.games_won_by_agents = [0] * self.num_players
        self.games_played = 0

    def reset(self) -> None:
        """Resets the game for a new hand."""
        for i in range(self.num_players):
            if self.game.winners is not None and i in self.game.winners:
                self.games_won_by_agents[i] += 1
        self.games_played += 1
        # print(f"Games played: {self.games_played}, Wins: {self.game.winners}")

        self.game.reset()

    def _encode_card(self, card_str: str) -> int:
        """
        Encodes a card string (e.g. "A♡" for Ace of Hearts) into an integer (0-51).
        """
        ranks = "23456789TJQKA"
        suits = "♡♢♧♤"
        
        return suits.index(card_str[1]) * 13 + ranks.index(card_str[0])

    def _get_observation(self, player_index: int) -> dict:
        """
        Creates an observation dict for the given player.
        Observation includes:
          - "hand": Encoded list of the player's two cards.
          - "community_cards": Encoded list of community cards (padded to 5 with -1).
          - "current_bet": The player's current bet.
          - "call_amount": The amount needed to call the current bet.
          - "pot": Current pot size.
          - "chips": Number of chips the player has.
          - "round_stage": The current betting round (e.g., "pre-flop", "flop", etc.).
        """
        player = self.game.players[player_index]

        hand_str = [str(card) for card in player.hand]
        hand_encoded = [self._encode_card(card) for card in hand_str]

        community_str = [str(card) for card in self.game.community_cards]
        community_encoded = [self._encode_card(card) for card in community_str]

        current_bet = player.current_bet
        call_amount = max(p.current_bet for p in self.game.players if not p.folded) - current_bet

        while len(community_encoded) < 5:
            community_encoded.append(-1)
        observation = {
            "hand": hand_encoded,
            "community_cards": community_encoded,
            "pot": self.game.pot,
            "chips": player.chips,
            "round_stage": self.game.round_stage,
            "current_bet": current_bet,
            "call_amount": call_amount,
        }
        return observation

    def render(self) -> None:
        """Simple textual render of the current game state."""
        print("==== Poker Game State ====")
        print(f"Round Stage: {self.game.round_stage}")
        print(f"Pot: {self.game.pot}")
        print("Community Cards:", [str(card) for card in self.game.community_cards])
        for p in self.game.players:
            print(
                f"Player {p.player_id}: Chips={p.chips}, "
                f"Current Bet={p.current_bet}, Total Bet={p.total_bet}, "
                f"Hand={[str(card) for card in p.hand]}, Folded={p.folded}, All-in={p.all_in}"
            )
        print("==========================")

    def calculate_reward(self, player_index):
        """Calculate reward for RL agent"""
        player = self.game.players[player_index]
        reward = 0.0
        
        if self.game.hand_over:
            if self.game.winners is not None and player_index in self.game.winners:
                reward += 10.0  # Bonus for winning the hand
            elif player.folded:
                # Use the game's hand evaluation for folding penalty
                if len(self.game.community_cards) > 0:
                    # Get hand strength using the game's evaluation
                    hand_value = self.game.evaluate_best_hand(player)
                    # Normalize to 0-1 range (8 is straight flush, 0 is high card)
                    normalized_strength = hand_value[0] / 8.0
                    fold_penalty = 5.0 * (normalized_strength)
                    reward -= fold_penalty
                else:
                    # Pre-flop folding penalty
                    reward -= 2.0
        
        return reward


    def step_rl(self, player_index, action, amount=None):
        self.game.step(action, amount)
        
        reward = self.calculate_reward(player_index)
        
        return reward, {}
