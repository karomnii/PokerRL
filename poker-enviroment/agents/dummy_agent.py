from typing import Tuple, Optional
from game.poker_game import Action
from .iagent import IAgent


class DummyAgent(IAgent):
    def __init__(self, action=Action.CALL, raise_amount=0):
        self.action = action
        self.raise_amount = raise_amount

    def act(self, observation: dict) -> Tuple[Action, Optional[int]]:
        return (self.action, self.raise_amount)