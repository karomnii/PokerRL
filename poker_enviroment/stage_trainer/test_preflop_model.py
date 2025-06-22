import random
from game.poker_game import Action
from impoved_dqn_agent import DQNAgent
from training_stage_helper.preflop_chart_evaluator import PreflopChartEvaluator
import torch

model_path = '../best_models/harmless/dqn_model.pth'

class PreflopTester:
    def __init__(self, num_tests=10_000):
        self.num_tests = num_tests
        self.correct_actions = 0
        self.valid_actions = 0

        self.dqn_agent = DQNAgent()
        self.dqn_agent.model.load_state_dict(torch.load(model_path, map_location='cpu'))
        self.dqn_agent.epsilon = 0

        self.chart_evaluator = PreflopChartEvaluator()
        self.chart_evaluator.load_chart_from_file("../training_stage_helper/DQN_preflop_chart.json")

        self.all_card_values = list(range(52))

    def test(self):
        for i in range(self.num_tests):
            cards = self.all_card_values.copy()
            random.shuffle(cards)
            card1, card2 = cards.pop(), cards.pop()

            correct_label = self.chart_evaluator.evaluate(card1, card2)
            if correct_label is None:
                continue

            label_action = {
                "raise": Action.RAISE,
                "call": Action.CALL,
                "fold": Action.FOLD
            }.get(correct_label.lower())

            if label_action is None:
                continue

            self.valid_actions += 1
            others_chips = [1000, 990, 980]
            others_folds = [0,0,0]
            obs = {"hand": [card1, card2], "community_cards": [], "call_amount": 0, "chips": 1000, "others_chips": others_chips,"others_folded": others_folds, "pot" : 30 }
            action, amount = self.dqn_agent.act(obs)

            if action == label_action:
                self.correct_actions += 1

        accuracy = self.correct_actions / self.valid_actions if self.valid_actions > 0 else 0
        print(f"Tested {self.valid_actions} valid preflop hands.")
        print(f"Accuracy: {accuracy:.2%}")

if __name__ == "__main__":
    tester = PreflopTester(num_tests=10_000)
    tester.test()
