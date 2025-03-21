import random
from typing import Tuple, Optional
from game.poker_game import Action
from .iagent import IAgent

class RandomAgent(IAgent):
    def act(self, observation: dict) -> Tuple[Action, Optional[int]]:
        """
        Decide on an action randomly, favoring playing actions (CALL and RAISE) over FOLD.
        
        Args:
            observation (dict): The current game state containing keys such as "chips".
        
        Returns:
            Tuple[Action, Optional[int]]:
                - Action: The chosen action (FOLD, CALL, or RAISE).
                - Optional[int]: The raise amount if the action is RAISE; otherwise, None.
        """
        # Probability distribution: 10% FOLD, 60% CALL, 30% RAISE.
        
        rand_value: float = random.random()
        if rand_value < 0.1:
            return (Action.FOLD, None)
        elif rand_value < 0.7:
            return (Action.CALL, None)
        else:
            chips: int = observation.get("chips", 1000)
            
            if random.random() < 0.1:
                return (Action.RAISE, chips)    
            
            max_raise = min(50, chips) if chips > 0 else 1
            raise_amount = random.randint(1, max_raise)
            return (Action.RAISE, raise_amount)
