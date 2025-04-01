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
        self.num_episodes = 10000
        self.update_target_every = 50
        self.save_every = 100
        self.print_stats_every = 20
        self.window_size = 100
        
        # Initialize tracking variables
        self.episode_losses = []
        self.episode_rewards = []
        self.win_history = []
        self.moving_avg_loss = []
        self.moving_avg_reward = []
        
        # TensorBoard writer
        self.writer = SummaryWriter()
        
        # Initialize agents
        self.dqn_agent = DQNAgent(player_id=0)
        self.agents = [self.dqn_agent] + [RandomAgent() for _ in range(3)]
    
    def run_episode(self):
        env = PokerEnv(self.agents)
        env.reset()
        episode_transitions = []
        episode_reward = 0
        
        while not env.game.hand_over:
            current_player_idx = env.game.current_player_index
            agent = self.agents[current_player_idx]
            observation = env._get_observation(current_player_idx)
            
            action, amount = agent.act(observation)
            
            if agent is self.dqn_agent:
                state = self.dqn_agent._preprocess_observation(observation)
                episode_transitions.append({
                    'state': state,
                    'action': action,
                    'amount': amount
                })
            
            env.game.step(action, amount)
        
        # Process episode results
        winners = env.game.determine_winners()
        won = self.dqn_agent.player_id in winners
        num_steps = len(episode_transitions)
        
        for i, transition in enumerate(episode_transitions):
            reward = (2.0 if won else -2.0) / (num_steps - i)
            episode_reward += reward
            
            next_state = episode_transitions[i+1]['state'] if i < num_steps-1 else None
            self.dqn_agent.replay_buffer.append((
                transition['state'],
                transition['action'],
                reward,
                next_state,
                next_state is None
            ))
        
        return won, episode_reward, len(episode_transitions)

    def train(self):
        for episode in range(self.num_episodes):
            won, episode_reward, num_actions = self.run_episode()
            
            # Train the model
            loss = self.dqn_agent.update_model()
            
            # Update tracking variables
            if loss is not None:
                self.episode_losses.append(loss)
                self.episode_rewards.append(episode_reward)
                self.win_history.append(won)
                
                # Update moving averages
                if len(self.episode_losses) >= self.window_size:
                    self.moving_avg_loss.append(
                        sum(self.episode_losses[-self.window_size:])/self.window_size
                    )
                    self.moving_avg_reward.append(
                        sum(self.episode_rewards[-self.window_size:])/self.window_size
                    )
            
            # Update target network
            if episode % self.update_target_every == 0:
                self.dqn_agent.update_target_network()
            
            # Save model
            if episode % self.save_every == 0:
                self.dqn_agent.save_model()
            
            # Log to TensorBoard
            if loss is not None:
                self.writer.add_scalar('Loss/train', loss, episode)
                self.writer.add_scalar('Reward/episode', episode_reward, episode)
                self.writer.add_scalar('Wins/outcome', int(won), episode)
                self.writer.add_scalar('Exploration/epsilon', self.dqn_agent.epsilon, episode)
            
            # Print statistics
            if episode % self.print_stats_every == 0 and episode > 0:
                recent_wins = sum(self.win_history[-self.print_stats_every:])
                avg_loss = sum(self.episode_losses[-self.print_stats_every:])/self.print_stats_every
                avg_reward = sum(self.episode_rewards[-self.print_stats_every:])/self.print_stats_every
                
                print(f"Episode {episode+1}/{self.num_episodes} | "
                      f"Loss: {avg_loss:.4f} | "
                      f"Reward: {avg_reward:.2f} | "
                      f"Wins: {recent_wins}/{self.print_stats_every} | "
                      f"Epsilon: {self.dqn_agent.epsilon:.3f} | "
                      f"Actions: {num_actions}")
        
        # Final statistics and plots
        self._final_report()
        self.writer.close()
    
    def _final_report(self):
        # Calculate final statistics
        total_wins = sum(self.win_history)
        win_rate = total_wins / len(self.win_history)
        avg_loss = sum(self.episode_losses) / len(self.episode_losses)
        avg_reward = sum(self.episode_rewards) / len(self.episode_rewards)
        
        print("\n=== Training Complete ===")
        print(f"Total Episodes: {self.num_episodes}")
        print(f"Total Wins: {total_wins} ({win_rate*100:.1f}%)")
        print(f"Average Loss: {avg_loss:.4f}")
        print(f"Average Reward: {avg_reward:.2f}")
        
        # Plot training curves
        plt.figure(figsize=(15, 5))
        
        plt.subplot(1, 3, 1)
        plt.plot(self.episode_losses)
        plt.plot(range(self.window_size - 1, len(self.episode_losses)), self.moving_avg_loss, 'r-')
        plt.title('Training Loss')
        plt.xlabel('Episode')
        plt.ylabel('Loss')
        
        plt.subplot(1, 3, 2)
        plt.plot(self.episode_rewards)
        plt.plot(range(self.window_size - 1, len(self.episode_rewards)), self.moving_avg_reward, 'r-')
        plt.title('Episode Rewards')
        plt.xlabel('Episode')
        plt.ylabel('Reward')
        
        plt.subplot(1, 3, 3)
        plt.plot([sum(self.win_history[i:i+100]) for i in range(len(self.win_history)-100)])
        plt.title('Win Rate (Last 100 Episodes)')
        plt.xlabel('Episode')
        plt.ylabel('Wins')
        
        plt.tight_layout()
        plt.savefig('training_results.png')
        plt.close()

if __name__ == "__main__":
    trainer = PokerTrainer()
    trainer.train()