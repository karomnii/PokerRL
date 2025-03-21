from typing import Tuple, Optional
from game.poker_game import Action
from .iagent import IAgent


class ConsolePlayer(IAgent):
    def act(self, observation: dict) -> Tuple[Action, Optional[int]]:
        """
        Interact with the user to get their action.
        
        Args:
            observation (dict): The current game state.
        
        Returns:
            Tuple[Action, Optional[int]]:
                - Action: The chosen action (FOLD, CALL, or RAISE).
                - Optional[int]: The raise amount if the action is RAISE; otherwise, None.
        """
        while True:
            try:
                action_str = input(f"Console player, you have {observation.get('chips')} chips. \nCurrent call amount is {observation.get('call_amount')}, enter your action (FOLD, CHECK/CALL, RAISE [amount]): ").strip().upper()
                if action_str == "FOLD":
                    return Action.FOLD, None
                elif action_str == "CHECK" and observation.get("call_amount") == 0:
                    return Action.CALL, None
                elif action_str == "CHECK":
                    print("You cannot check, you must call the current bet.")
                    continue
                elif action_str == "CALL":
                    return Action.CALL, None
                elif action_str.startswith("RAISE"):
                    _, amount_str = action_str.split()
                    amount = int(amount_str)
                    if amount < observation.get("call_amount") or amount < 20:
                        minimum_raise = 20 if observation.get("call_amount") == 0 else observation.get("call_amount")
                        print(f"Raise amount must be at least {minimum_raise}.")
                        continue
                    return Action.RAISE, amount
                else:
                    print("Invalid action. Please enter FOLD, CHECK, CALL, or RAISE [amount].")
            except ValueError:
                print("Invalid input. Please enter a valid number for the raise amount.")