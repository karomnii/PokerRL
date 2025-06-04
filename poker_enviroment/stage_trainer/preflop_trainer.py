import random
import matplotlib.pyplot as plt

from torch.utils.tensorboard import SummaryWriter
from game.poker_game import Action
from impoved_dqn_agent import DQNAgent
from training_stage_helper.preflop_chart_evaluator import PreflopChartEvaluator

class PreflopTrainer:
    def __init__(self):
        self.num_episodes = 10_000
        self.update_target_every = 50
        self.save_every = 5000
        self.print_stats_every = 50
        self.window_size = 100

        self.accuracy_history = []
        self.correct_actions = 0
        self.valid_actions = 0

        self.chart_evaluator = PreflopChartEvaluator()
        self.chart_evaluator.load_chart_from_file("../training_stage_helper/preflop_chart.json")
        self.writer = SummaryWriter()
        self.dqn_agent = DQNAgent()
        self.dqn_agent.epsilon = 0
        self.dqn_agent.epsilon_end=0
        self.all_card_values = list(range(52))

    def train(self):
        for episode in range(self.num_episodes):
            cards = self.all_card_values.copy()
            random.shuffle(cards)
            card1, card2 = cards.pop(), cards.pop()

            # Get chart-based correct action (label)
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

            obs = {"hand": [card1, card2], "community_cards": [], "call_amount": 0, "chips": 1000}
            action, amount = self.dqn_agent.act(obs)

            if action == label_action:
                self.correct_actions += 1
                reward = 1.0
            else:
                reward = -1.0

            state = self.dqn_agent._preprocess_observation(obs)
            next_state = None
            done = True

            self.dqn_agent.replay_buffer.append((state, action, reward, next_state, done))

            loss = self.dqn_agent.update_model()
            if loss is not None:
                self.writer.add_scalar("Loss", loss, episode)

            if episode % self.update_target_every == 0 and episode > 0:
                self.dqn_agent.update_target_network()

            if episode % self.save_every == 0 and episode > 0:
                self.dqn_agent.save_model()

            if self.valid_actions > 0 and self.valid_actions % self.print_stats_every == 0:
                accuracy = self.correct_actions / self.valid_actions
                self.correct_actions=0
                self.valid_actions=0
                self.accuracy_history.append(accuracy)
                print(f"Episode[{episode}/{self.num_episodes}] Accuracy: {accuracy:.2%} | Reward: {reward:.2f} | Epsilon: {self.dqn_agent.epsilon:.3f}")
                self.writer.add_scalar("Accuracy", accuracy, episode)

        self.writer.close()

        # Plot accuracy
        plt.plot(self.accuracy_history)
        plt.xlabel("Evaluation Step (every 50 valid actions)")
        plt.ylabel("Accuracy")
        plt.title("DQN Preflop Action Accuracy")
        plt.grid(True)
        plt.tight_layout()
        plt.savefig("accuracy_plot.png")
        plt.show()


if __name__ == "__main__":
    trainer = PreflopTrainer()
    trainer.train()
