import random
from datetime import datetime
import matplotlib.pyplot as plt
from torch.utils.tensorboard import SummaryWriter
from agents.random_agent import RandomAgent
from game.poker_game import PokerGame
from enviroment.poker_env import PokerEnv
from dqn_agent import DQNAgent

class PokerTrainer:
    def __init__(self):
        # Feel free to adjust these as needed
        self.num_episodes = 10000
        self.update_target_every = 50
        # Save model less frequently
        self.save_every = 500  
        self.print_stats_every = 50
        self.window_size = 100
        
        # Tracking variables
        self.episode_losses = []
        self.episode_rewards = []
        self.win_history = []
        self.moving_avg_loss = []
        self.moving_avg_reward = []
        
        # TensorBoard
        self.writer = SummaryWriter()
        
        # Initialize agents (1x DQN + 3x Random for a 4-player game)
        self.dqn_agent = DQNAgent(player_id=0)
        self.agents = [self.dqn_agent] + [RandomAgent() for _ in range(3)]
    
    def run_episode(self):
        """
        Plays out one episode (one deal/hand of poker) until the hand is over.
        Returns (won, total_reward_for_episode, number_of_actions_taken).
        """
        env = PokerEnv(self.agents)
        env.reset()
        episode_transitions = []
        episode_reward = 0
        
        while not env.game.hand_over:
            current_player_idx = env.game.current_player_index
            agent = self.agents[current_player_idx]
            observation = env._get_observation(current_player_idx)
            
            action, amount = agent.act(observation)
            
            # Record transitions only for the DQN agent
            if agent is self.dqn_agent:
                state = self.dqn_agent._preprocess_observation(observation)
                episode_transitions.append({
                    'state': state,
                    'action': action,
                    'amount': amount
                })
            
            env.game.step(action, amount)
        
        # Once the hand ends, determine reward
        winners = env.game.determine_winners()
        won = (self.dqn_agent.player_id in winners)
        num_steps = len(episode_transitions)
        
        # Assign rewards for each step
        for i, transition in enumerate(episode_transitions):
            # Simple reward: +2 if you eventually won, else -2, discounted over steps
            reward = (2.0 if won else -2.0) * (num_steps - i)
            episode_reward += reward
            
            next_state = (episode_transitions[i+1]['state']
                          if i < num_steps-1 else None)
            
            self.dqn_agent.replay_buffer.append((
                transition['state'],
                transition['action'],
                reward,
                next_state,
                next_state is None
            ))
        
        return won, episode_reward, num_steps

    def train(self):
        """
        Main training loop over self.num_episodes episodes.
        """
        for episode in range(self.num_episodes):
            won, episode_reward, num_actions = self.run_episode()
            
            # Update (train) the DQN model
            loss = self.dqn_agent.update_model()
            
            # Track stats
            if loss is not None:
                self.episode_losses.append(loss)
                self.episode_rewards.append(episode_reward)
                self.win_history.append(won)
                
                # Moving averages
                if len(self.episode_losses) >= self.window_size:
                    window_losses = self.episode_losses[-self.window_size:]
                    window_rewards = self.episode_rewards[-self.window_size:]
                    
                    self.moving_avg_loss.append(sum(window_losses)/len(window_losses))
                    self.moving_avg_reward.append(sum(window_rewards)/len(window_rewards))
            
            # Periodically update the target network
            if episode % self.update_target_every == 0 and episode > 0:
                self.dqn_agent.update_target_network()
            
            # Save model less frequently
            if episode % self.save_every == 0 and episode > 0:
                self.dqn_agent.save_model()
            
            # Log to TensorBoard
            if loss is not None:
                self.writer.add_scalar('Loss/train', loss, episode)
                self.writer.add_scalar('Reward/episode', episode_reward, episode)
                self.writer.add_scalar('Wins/outcome', int(won), episode)
                self.writer.add_scalar('Exploration/epsilon', self.dqn_agent.epsilon, episode)
            
            # Print intermediate statistics
            if episode % self.print_stats_every == 0 and episode > 0:
                recent_wins = sum(self.win_history[-self.print_stats_every:])
                avg_loss = (sum(self.episode_losses[-self.print_stats_every:]) /
                            self.print_stats_every)
                avg_reward = (sum(self.episode_rewards[-self.print_stats_every:]) /
                              self.print_stats_every)
                
                print(f"Episode {episode}/{self.num_episodes} | "
                      f"Avg Loss: {avg_loss:.4f} | "
                      f"Avg Reward: {avg_reward:.2f} | "
                      f"Wins: {recent_wins}/{self.print_stats_every} | "
                      f"Epsilon: {self.dqn_agent.epsilon:.3f} | "
                      f"Actions: {num_actions}")
        
        # Final report and plots
        self._final_report()
        self.writer.close()
    
    def _final_report(self):
        # Basic stats
        total_episodes = len(self.win_history)
        total_wins = sum(self.win_history)
        win_rate = total_wins / (total_episodes if total_episodes > 0 else 1)
        avg_loss = (sum(self.episode_losses) / len(self.episode_losses)
                    if self.episode_losses else 0.0)
        avg_reward = (sum(self.episode_rewards) / len(self.episode_rewards)
                      if self.episode_rewards else 0.0)
        
        print("\n=== Training Complete ===")
        print(f"Total Episodes: {total_episodes}")
        print(f"Total Wins: {total_wins} ({win_rate*100:.1f}%)")
        print(f"Average Loss: {avg_loss:.4f}")
        print(f"Average Reward: {avg_reward:.2f}")
        
        # Generate some plots
        plt.figure(figsize=(15, 5))
        
        # 1) Loss
        plt.subplot(1, 3, 1)
        plt.title('Training Loss')
        plt.xlabel('Episode')
        plt.ylabel('Loss')
        plt.plot(self.episode_losses, label='Loss')
        if self.moving_avg_loss:
            plt.plot(range(self.window_size - 1,
                           self.window_size - 1 + len(self.moving_avg_loss)),
                     self.moving_avg_loss, label='Moving Avg Loss')
        
        # 2) Reward
        plt.subplot(1, 3, 2)
        plt.title('Episode Rewards')
        plt.xlabel('Episode')
        plt.ylabel('Reward')
        plt.plot(self.episode_rewards, label='Reward')
        if self.moving_avg_reward:
            plt.plot(range(self.window_size - 1,
                           self.window_size - 1 + len(self.moving_avg_reward)),
                     self.moving_avg_reward, label='Moving Avg Reward')
        
        # 3) Win Rate (rolling window of 100)
        plt.subplot(1, 3, 3)
        plt.title('Win Rate (Rolling 100)')
        plt.xlabel('Episode')
        plt.ylabel('Wins in Last 100')
        rolling_win_count = []
        for i in range(len(self.win_history)):
            rolling_win_count.append(sum(self.win_history[i:i+100]))
        plt.plot(rolling_win_count, label='Wins in last 100')
        
        plt.tight_layout()
        plt.savefig('training_results.png')
        plt.close()


if __name__ == "__main__":
    trainer = PokerTrainer()
    trainer.train()
