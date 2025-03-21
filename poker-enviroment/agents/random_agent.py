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
        # Probability distribution: 5% FOLD, 85% CALL, 10% RAISE(1% ALL-IN, 79% 1-5 times call amount, 20% call amount).
        
        rand_value: float = random.random()
        if rand_value < 0.05:
            return (Action.FOLD, None)
        elif rand_value < 0.9:
            # This is a simple strategy to avoid going all-in when the call amount is higher than 1/3 of player's chips.
            if observation.get("call_amount") > observation.get("chips")//3 and random.random() < 0.5:
                return (Action.FOLD, None)

            return (Action.CALL, None)
        else:
            chips: int = observation.get("chips")

            # minimum raise is big blind amount, or call amount if it's larger
            # it may be needed to add big blind amount to observation
            min_raise = observation.get("call_amount") if observation.get("call_amount") > 0 else 20
            
            random_raise: float = random.random()
            raise_amount = min_raise

            if random.random() < 0.1:
                return (Action.RAISE, chips)    
            elif random_raise < 0.8:
                raise_amount = min_raise * random.randint(1, 5)
            
            return (Action.RAISE, raise_amount)
