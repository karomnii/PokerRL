from abc import ABC, abstractmethod
from typing import Tuple, Optional
from game.poker_game import Action

class IAgent(ABC):
    @abstractmethod
    def act(self, observation: dict) -> Tuple[Action, Optional[int]]:
        """
        Decide on an action based on the current observation.

        Args:
            observation (dict): The current game state.

        Returns:
            Tuple[Action, Optional[int]]: A tuple containing the chosen action and, if applicable, the raise amount.
        """
        pass
