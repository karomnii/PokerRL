import random
from typing import Tuple, Optional

from agents import IAgent
from game.poker_game import Action
from training_stage_helper.encoded_card_evaluator import EncodedCardEvaluator
from training_stage_helper.preflop_chart_evaluator import PreflopChartEvaluator
raise_stop_amount=30

class PseudoIntelligent(IAgent):
    def __init__(self):
        self.chart_evaluator = PreflopChartEvaluator()
        self.chart_evaluator.load_chart_from_file("training_stage_helper/preflop_chart.json")

    def act(self, observation: dict) -> Tuple[Action, Optional[int]]:
        if observation["community_cards"][0] == -1:
            correct_label = self.chart_evaluator.evaluate(observation["hand"][0],observation["hand"][1])
            label_action = {
                "raise": Action.RAISE,
                "call": Action.CALL,
                "fold": Action.FOLD
            }.get(correct_label.lower())
            if label_action is None:
                return Action.CALL,None
            if label_action == Action.RAISE:
                if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                    return Action.CALL,None
                rand_value = random.random()
                # Some randomness to fold a good hand
                if rand_value < 0.05:
                    label_action = Action.FOLD
                elif rand_value <0.6 and rand_value * observation["chips"] < 100:
                    label_action = Action.CALL
            else:
                # Some randomness to play bad cards
                if random.random() < 0.5:
                    return Action.CALL, None
            if label_action == Action.RAISE:
                if observation["chips"] < 300:
                    return label_action,random.randrange(10, 25)
                else:
                    return label_action,random.randrange(30, 60)
            return label_action,None

        else:
            evaluator = EncodedCardEvaluator()
            rank, best_hand = evaluator.evaluate_best_hand(observation["hand"],observation["community_cards"])

            if observation["community_cards"][0]!=-1 and observation["community_cards"][3]==-1:
                if rank<1:
                    return Action.CALL,None
                elif rank<4:
                    if random.random()<0.5:
                        if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                            return Action.CALL, None
                        return Action.RAISE,random.randrange(10, 20)
                    else:
                        return Action.CALL, None
                else:
                    if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                        return Action.CALL, None
                    return Action.RAISE, random.randrange(15, 30)
            elif observation["community_cards"][3]!=-1 and observation["community_cards"][4]==-1:
                if rank < 1:
                    if random.random()<0.2:
                        return Action.FOLD,None
                    else:
                        return Action.CALL, None
                elif rank < 4:
                    if random.random() < 0.6:
                        if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                            return Action.CALL, None
                        return Action.RAISE, random.randrange(15, 30)
                    else:
                        return Action.CALL, None
                else:
                    if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                        return Action.CALL, None
                    return Action.RAISE, random.randrange(25, 40)
            else:
                if rank < 1:
                    if observation["current_bet"] + 50 < observation["call_amount"]:
                        if random.random()<0.7:
                            return Action.FOLD,None
                        else:
                            return Action.CALL, None
                    else:
                        if random.random()<0.2:
                            return Action.FOLD,None
                        else:
                            return Action.CALL, None
                elif rank < 4:
                    if random.random() < 0.4:
                        if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                            return Action.CALL, None
                        return Action.RAISE, random.randrange(20, 35)
                    else:
                        return Action.CALL, None
                else:
                    if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                        return Action.CALL, None
                    return Action.RAISE, random.randrange(30, 50)

