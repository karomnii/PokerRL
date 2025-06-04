import random
from typing import Tuple, Optional

from agents import IAgent
from game.poker_game import Action
from training_stage_helper.encoded_card_evaluator import EncodedCardEvaluator
from training_stage_helper.preflop_chart_evaluator import PreflopChartEvaluator
raise_stop_amount=20


class CautiousAgent(IAgent):
    def __init__(self):
        self.chart_evaluator = PreflopChartEvaluator()
        self.chart_evaluator.load_chart_from_file("training_stage_helper/cautious_preflop_chart.json")

    def act(self, observation: dict) -> Tuple[Action, Optional[int]]:
        if observation["community_cards"][0] == -1:
            correct_label = self.chart_evaluator.evaluate(observation["hand"][0], observation["hand"][1])
            label_action = {
                "raise": Action.RAISE,
                "call": Action.CALL,
                "fold": Action.FOLD
            }.get(correct_label.lower(), Action.CALL)

            if label_action == Action.RAISE:
                if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                    return Action.CALL,None
                rand_value = random.random()
                # Be more conservative with raises
                if rand_value < 0.15:
                    label_action = Action.FOLD
                elif rand_value < 0.7:
                    label_action = Action.CALL
            else:
                # Some randomness to play bad cards
                if random.random()<0.2:
                    return Action.CALL, None

            if label_action == Action.RAISE:
                if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                    return Action.CALL,None
                # Smaller raise sizes and only if chips allow
                if observation["chips"] < 200:
                    return label_action, random.randrange(5, 15)
                else:
                    return label_action, random.randrange(15, 35)

            return label_action, None

        else:
            evaluator = EncodedCardEvaluator()
            rank, best_hand = evaluator.evaluate_best_hand(observation["hand"], observation["community_cards"])

            if observation["community_cards"][0]!=-1 and observation["community_cards"][3]==-1:  # Flop
                if rank < 1:
                    return (Action.FOLD if random.random() < 0.4 else Action.CALL), None
                elif rank < 4:
                    if random.random() < 0.3:
                        if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                            return Action.CALL, None
                        return Action.RAISE, random.randrange(10, 20)
                    else:
                        return Action.CALL, None
                else:
                    if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                        return Action.CALL, None
                    return Action.RAISE, random.randrange(15, 25)

            elif observation["community_cards"][3]!=-1 and observation["community_cards"][4]==-1:  # Turn
                if rank < 1:
                    return (Action.FOLD if random.random() < 0.5 else Action.CALL), None
                elif rank < 4:
                    if random.random() < 0.4:
                        if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                            return Action.CALL, None
                        return Action.RAISE, random.randrange(10, 20)
                    else:
                        return Action.CALL, None
                else:
                    if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                        return Action.CALL, None
                    return Action.RAISE, random.randrange(20, 30)

            else:  # River
                if rank < 1:
                    if observation["call_amount"] > observation["current_bet"] + 30:
                        return Action.FOLD, None
                    return (Action.CALL if random.random() > 0.3 else Action.FOLD), None
                elif rank < 4:
                    if random.random() < 0.3:
                        if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                            return Action.CALL, None
                        return Action.RAISE, random.randrange(10, 20)
                    else:
                        return Action.CALL, None
                else:
                    if observation["current_bet"] + raise_stop_amount < observation["call_amount"]:
                        return Action.CALL, None
                    return Action.RAISE, random.randrange(20, 30)
