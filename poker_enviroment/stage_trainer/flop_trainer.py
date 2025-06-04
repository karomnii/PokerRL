import random
import matplotlib.pyplot as plt
import torch

from torch.utils.tensorboard import SummaryWriter

from agents.random_agent import RandomAgent
from enviroment import PokerEnv
from game.poker_game import Action
from impoved_dqn_agent import DQNAgent
from training_stage_helper.preflop_chart_evaluator import PreflopChartEvaluator

model_path = 'pretrained_models/pretrained_flop/dqn_model.pth'

class FlopTrainer:
    def __init__(self):
        self.num_episodes = 100_000
        self.update_target_every = 50
        self.save_every = 5000
        self.print_stats_every = 50
        self.window_size = 100

        self.reward_history = []
        self.loss_history = []

        self.chart_evaluator = PreflopChartEvaluator()
        self.chart_evaluator.load_chart_from_file("../training_stage_helper/preflop_chart.json")
        self.writer = SummaryWriter()
        self.dqn_agent = DQNAgent(player_id=0)
        self.dqn_agent.model.load_state_dict(torch.load(model_path))
        self.dqn_agent.epsilon = 0.8
        self.dqn_agent.epsilon_end = 0.05
        self.all_card_values = list(range(52))

    def train(self):
        for episode in range(self.num_episodes):
            env = PokerEnv([self.dqn_agent])
            env.game.deal_hole_cards()
            env.game.deal_community_cards(3)

            observation = env._get_observation(self.dqn_agent.player_id)
            action, amount = self.dqn_agent.act(observation)
            env.game.evaluate_best_hand(env.game.players[self.dqn_agent.player_id])

            rank = env.game.players[self.dqn_agent.player_id].best_hand["rank"]
            #print(f"Hand rank: {rank}, Action: {action.name}")

            # Reward logic
            reward = 0.0
            if action == Action.RAISE:
                if rank < 1:
                    reward = -1.0
                elif rank > 2:
                    reward = 1.0
            elif action == Action.FOLD:
                if 4 > rank > 2:
                    reward = -0.5
                elif rank >= 4:
                    reward = -1.0
                elif rank < 1:
                    reward = 0.1
                else:
                    reward = -0.2
            elif action == Action.CALL:
                if 1 <= rank <= 4:
                    reward = 0.5
                elif rank > 4:
                    reward = -0.1
                elif rank < 1:
                    reward = -0.2

            self.reward_history.append(reward)

            state = self.dqn_agent._preprocess_observation(observation)
            next_state = None
            done = True
            self.dqn_agent.replay_buffer.append((state, action, reward, next_state, done))

            loss = self.dqn_agent.update_model()
            if loss is not None:
                self.loss_history.append(loss)
                self.writer.add_scalar("Loss", loss, episode)

            if episode % self.update_target_every == 0 and episode > 0:
                self.dqn_agent.update_target_network()

            if episode % self.save_every == 0 and episode > 0:
                self.dqn_agent.save_model()

            if episode > 0 and episode % self.print_stats_every == 0:
                avg_reward = sum(self.reward_history[-50:]) / min(50, len(self.reward_history))
                avg_loss = sum(self.loss_history[-50:]) / min(50, len(self.loss_history)) if self.loss_history else 0.0

                print(f"Episode[{episode}/{self.num_episodes}] "
                      f"Avg Reward (last 50): {avg_reward:.3f} | "
                      f"Avg Loss (last 50): {avg_loss:.5f} | "
                      f"Epsilon: {self.dqn_agent.epsilon:.3f}")

                self.writer.add_scalar("Avg_Reward_50", avg_reward, episode)
                self.writer.add_scalar("Avg_Loss_50", avg_loss, episode)

        self.writer.close()

        # Plotting
        episodes = list(range(1, len(self.reward_history) + 1))

        # Reward Plot
        plt.figure(figsize=(10, 4))
        plt.plot(episodes, self.reward_history, label='Reward per Episode', color='green', alpha=0.7)
        plt.title("Episode Reward")
        plt.xlabel("Episode")
        plt.ylabel("Reward")
        plt.grid(True)
        plt.tight_layout()
        plt.savefig("reward_plot.png")
        plt.show()

        # Loss Plot
        plt.figure(figsize=(10, 4))
        plt.plot(range(1, len(self.loss_history) + 1), self.loss_history, label='Loss', color='red', alpha=0.7)
        plt.title("Training Loss")
        plt.xlabel("Episode")
        plt.ylabel("Loss")
        plt.grid(True)
        plt.tight_layout()
        plt.savefig("loss_plot.png")
        plt.show()

        epsilon_values = [self.dqn_agent.epsilon] * self.num_episodes
        plt.figure(figsize=(10, 4))
        plt.plot(range(1, self.num_episodes + 1), epsilon_values, label='Epsilon', color='blue', alpha=0.6)
        plt.title("Epsilon Over Episodes")
        plt.xlabel("Episode")
        plt.ylabel("Epsilon")
        plt.grid(True)
        plt.tight_layout()
        plt.savefig("epsilon_plot.png")
        plt.show()


if __name__ == "__main__":
    trainer = FlopTrainer()
    trainer.train()