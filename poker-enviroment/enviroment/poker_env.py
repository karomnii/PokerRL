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

    def reset(self) -> None:
        """Resets the game for a new hand."""
        self.game.reset()

    def _encode_card(self, card_str: str) -> int:
        """
        Encodes a card string (e.g. "AH" for Ace of Hearts) into an integer (0-51).
        """
        ranks = "23456789TJQKA"
        suits = "HDCS"
        
        return suits.index(card_str[1]) * 13 + ranks.index(card_str[0])

    def _get_observation(self, player_index: int) -> dict:
        """
        Creates an observation dict for the given player.
        Observation includes:
          - "hand": Encoded list of the player's two cards.
          - "community_cards": Encoded list of community cards (padded to 5 with -1).
          - "pot": Current pot size.
          - "chips": Number of chips the player has.
          - "round_stage": The current betting round (e.g., "pre-flop", "flop", etc.).
        """
        player = self.game.players[player_index]
        # Encode player's hand.
        hand_str = [str(card) for card in player.hand]
        hand_encoded = [self._encode_card(card) for card in hand_str]
        # Encode community cards.
        community_str = [str(card) for card in self.game.community_cards]
        community_encoded = [self._encode_card(card) for card in community_str]
        # Pad community cards to always have 5 entries.
        while len(community_encoded) < 5:
            community_encoded.append(-1)
        observation = {
            "hand": hand_encoded,
            "community_cards": community_encoded,
            "pot": self.game.pot,
            "chips": player.chips,
            "round_stage": self.game.round_stage
        }
        return observation

    def run_hand(self) -> Tuple[int, PokerGame]:
        """
        Runs a single hand of poker.
        Each agent acts in turn (based on game.current_player_index) until the hand is over.
        Returns:
          - The winning player's ID.
          - The final game state (the PokerGame instance).
        """
        self.reset()
        # Continue until the game signals that the hand is over.
        while not self.game.hand_over:
            current_index = self.game.current_player_index
            observation = self._get_observation(current_index)
            # Agent acts based on the observation.
            action, amount = self.agents[current_index].act(observation)
            self.game.step(action, amount)
        # At hand over, determine the winner (if not already awarded during showdown).
        winner = self.game.determine_winner()
        return winner, self.game

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
