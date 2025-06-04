import random
from typing import Tuple, Optional
import os

from agents import IAgent
from game.poker_game import Action
from training_stage_helper.encoded_card_evaluator import EncodedCardEvaluator
from training_stage_helper.preflop_chart_evaluator import PreflopChartEvaluator
raise_stop_amount=40


class AggressiveAgent(IAgent):
    def __init__(self):
        self.chart_evaluator = PreflopChartEvaluator()

        print(os.path.abspath(__file__))
        self.chart_evaluator.load_chart_from_file("training_stage_helper/aggressive_preflop_chart.json")

    def act(self, observation: dict) -> Tuple[Action, Optional[int]]:
        hand = observation["hand"]
        community = observation["community_cards"]

        # === Preflop ===
        if observation["community_cards"][0] == -1:
            label = self.chart_evaluator.evaluate(hand[0], hand[1])
            action = {
                "raise": Action.RAISE,
                "call": Action.CALL,
                "fold": Action.FOLD
            }.get(label.lower(), Action.CALL)

            # Bias toward raising more frequently
            if action != Action.FOLD and random.random() < 0.7:
                action = Action.RAISE

            # Make raise size larger on average
            if action == Action.RAISE:
                if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                    return Action.CALL,None
                if observation["chips"] < 300:
                    return action, random.randint(15, 35)
                else:
                    return action, random.randint(40, 80)
            else:
                # Some randomness to play bad cards
                if random.random()<0.45:
                    return Action.CALL, None
            return action, None

        # === Postflop ===
        evaluator = EncodedCardEvaluator()
        rank, best_hand = evaluator.evaluate_best_hand(hand, community)

        # More aggressive strategy by street
        if observation["community_cards"][0]!=-1 and observation["community_cards"][3]==-1:  # Flop
            if rank < 1:
                if random.random() < 0.5:
                    if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                        return Action.CALL, None
                    return Action.RAISE, random.randint(15, 25)
                return Action.CALL, None
            elif rank < 4:
                if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                    return Action.CALL,None
                return Action.RAISE, random.randint(25, 40)
            else:
                if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                    return Action.CALL,None
                return Action.RAISE, random.randint(35, 60)

        elif observation["community_cards"][3]!=-1 and observation["community_cards"][4]==-1:  # Turn
            if rank < 1:
                if random.random() < 0.3:
                    return Action.FOLD, None
                else:
                    if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                        return Action.CALL, None
                    return Action.RAISE, random.randint(15, 30)  # Semi-bluff
            elif rank < 4:
                if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                    return Action.CALL,None
                return Action.RAISE, random.randint(30, 50)
            else:
                if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                    return Action.CALL,None
                return Action.RAISE, random.randint(40, 70)

        else:  # River
            if rank < 1:
                if observation["current_bet"] + 60 < observation["call_amount"]:
                    if random.random() < 0.5:
                        return Action.FOLD, None
                if random.random() < 0.3:
                    return Action.FOLD, None
                return Action.CALL, None
            elif rank < 4:
                if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                    return Action.CALL,None
                return Action.RAISE, random.randint(40, 60)
            else:
                if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                    return Action.CALL,None
                return Action.RAISE, random.randint(50, 100)

