import random
from datetime import datetime
import matplotlib.pyplot as plt
from torch.utils.tensorboard import SummaryWriter
from agents.random_agent import RandomAgent
from game.poker_game import Action, PokerGame
from enviroment.poker_env import PokerEnv
from dqn_agent import DQNAgent

class PokerTrainer:
    def __init__(self):
        self.num_episodes = 1_000_000
        self.update_target_every = 10
        self.save_every = 50000  
        self.print_stats_every = 50
        self.window_size = 100
        
        self.episode_losses = []
        self.episode_rewards = []
        self.win_history = []
        self.moving_avg_loss = []
        self.moving_avg_reward = []
        
        self.writer = SummaryWriter()
        
        self.dqn_agent = DQNAgent(player_id=0)
        self.agents = [self.dqn_agent] + [RandomAgent() for _ in range(3)]
        self.num_episodes += 1
        
        
    def _would_have_won(self, env, dqn_player_id):
        """
        Checks if the folded agent would have ended up with the best hand
        had it not folded. In other words, compare the agent's best
        possible 5-card hand to the best hands of other non-folded players.
        
        Returns:
            bool: True if this agent's best hand is strictly better than
                every active (non-folded) opponent's hand; False otherwise.
        """
        # If by some chance the agent is not actually folded here, you can
        # either return False or skip. But presumably we call this only if
        # the agent has folded.
        #
        # Evaluate the agent's best 5-card hand *with current community cards*.
        agent_player = env.game.players[dqn_player_id]
        agent_hand_val = env.game.evaluate_best_hand(agent_player)  # returns (hand_rank, kicker_tuple)

        # Compare against each other player who hasn't folded:
        for p in env.game.players:
            if not p.folded and p.player_id != dqn_player_id:
                their_hand_val = env.game.evaluate_best_hand(p)
                if agent_hand_val <= their_hand_val:
                    return False

        return True

    
    def _calculate_reward(self, env, dqn_player_id, initial_stack, folded):
        final_stack = env.game.players[dqn_player_id].chips
        net_chips = final_stack - initial_stack
        scale_factor = 100.0

        if not folded:
            # Showdown: reward = scaled net chips
            return net_chips / scale_factor
        else:
            # Agent folded. Check if it was a dumb or smart fold.
            # Use our newly implemented _would_have_won to see if the agent
            # would have had the best hand if it had stayed in.
            would_have_won = self._would_have_won(env, dqn_player_id)
            if would_have_won:
                # Dumb fold: you had a winning hand but folded.
                return -1.0
            else:
                # Smart fold: zero or minimal penalty
                return 0.0


    def _assign_rewards(self, transitions, final_reward, gamma=0.99):
        """
        N-step / Monte Carlo style with discounting: 
        The last action sees final_reward, the step before sees gamma * final_reward, etc.
        """
        transitions_with_rewards = []
        cumulative = 0.0
        # Start from the last step, moving backwards
        for transition in reversed(transitions):
            # The last step sees final_reward, 
            # earlier steps get successively discounted
            cumulative = final_reward + gamma * cumulative
            # Build a new dict so as not to mutate the original
            transition_with_reward = {
                'state': transition['state'],
                'action': transition['action'],
                'amount': transition['amount'],
                'folded': transition['folded'],
                'reward': cumulative
            }
            transitions_with_rewards.append(transition_with_reward)
        # Reverse back to chronological order
        transitions_with_rewards.reverse()
        return transitions_with_rewards


    def run_episode(self):
        env = PokerEnv(self.agents)
        #env.reset() Not needed since we only train the model on a single round with started state so we never need to reset the game
        episode_transitions = []
        episode_reward = 0
        dqn_player_id = self.dqn_agent.player_id
        
        initial_stack = env.game.players[dqn_player_id].chips + env.game.players[dqn_player_id].current_bet
        
        folded = False  # Track if the DQN agent ended up folding
        
        while not env.game.hand_over:
            current_player_idx = env.game.current_player_index
            agent = self.agents[current_player_idx]
            observation = env._get_observation(current_player_idx)
            
            action, amount = agent.act(observation)
            
            # Collect transitions for the DQN agent only.
            if agent is self.dqn_agent:
                state = self.dqn_agent._preprocess_observation(observation)
                episode_transitions.append({
                    'state': state,
                    'action': action,
                    'amount': amount,
                    'folded': (action == Action.FOLD)
                })
                
            env.game.step(action, amount)

            # Check if the DQN agent folded
            if agent is self.dqn_agent and action == Action.FOLD:
                folded = True
        
        # --------------------------------------------
        # Once hand is over, calculate the final reward
        final_reward = self._calculate_reward(env, dqn_player_id, initial_stack, folded)
        episode_reward = final_reward
        # Now assign that final_reward to the last transition only
        transitions_with_rewards = self._assign_rewards(episode_transitions, final_reward)
        
        # Add to replay buffer
        for i, transition in enumerate(transitions_with_rewards):
            next_state = (transitions_with_rewards[i+1]['state'] 
                          if i < len(transitions_with_rewards) - 1 
                          else None)
            
            self.dqn_agent.replay_buffer.append((
                transition['state'],
                transition['action'],
                transition['reward'],
                next_state,
                next_state is None
            ))
        
        # Determine if agent won the hand (just for stats/logging)
        winners = env.game.determine_winners()
        won = (dqn_player_id in winners)
        
        return won, episode_reward, len(episode_transitions)
    

    def train(self):
        for episode in range(self.num_episodes):
            won, episode_reward, num_actions = self.run_episode()
            
            loss = self.dqn_agent.update_model()
            
            if loss is not None:
                self.episode_losses.append(loss)
                self.episode_rewards.append(episode_reward)
                self.win_history.append(won)
                
                if len(self.episode_losses) >= self.window_size:
                    self.moving_avg_loss.append(
                        sum(self.episode_losses[-self.window_size:])/self.window_size
                    )
                    self.moving_avg_reward.append(
                        sum(self.episode_rewards[-self.window_size:])/self.window_size
                    )
            
            if episode % self.update_target_every == 0 and episode > 0:
                self.dqn_agent.update_target_network()
            
            if episode % self.save_every == 0 and episode > 0:
                self.dqn_agent.save_model()
            
            if loss is not None:
                self.writer.add_scalar('Loss/train', loss, episode)
                self.writer.add_scalar('Reward/episode', episode_reward, episode)
                self.writer.add_scalar('Wins/outcome', int(won), episode)
                self.writer.add_scalar('Exploration/epsilon', self.dqn_agent.epsilon, episode)
            
            if episode % self.print_stats_every == 0 and episode > 0:
                recent_wins = sum(self.win_history[-self.print_stats_every:])
                avg_loss = sum(self.episode_losses[-self.print_stats_every:]) / self.print_stats_every
                avg_reward = sum(self.episode_rewards[-self.print_stats_every:]) / self.print_stats_every
                
                print(f"Episode {episode}/{self.num_episodes} | "
                      f"Avg Loss: {avg_loss:.4f} | "
                      f"Avg Reward: {avg_reward:.2f} | "
                      f"Wins: {recent_wins}/{self.print_stats_every} | "
                      f"Epsilon: {self.dqn_agent.epsilon:.3f} | "
                      f"Actions: {num_actions}")
        
        self._final_report()
        self.writer.close()
    
    def _final_report(self):
        total_episodes = len(self.win_history)
        total_wins = sum(self.win_history)
        win_rate = total_wins / total_episodes if total_episodes > 0 else 0
        avg_loss = sum(self.episode_losses)/len(self.episode_losses) if self.episode_losses else 0
        avg_reward = sum(self.episode_rewards)/len(self.episode_rewards) if self.episode_rewards else 0
        
        print("\n=== Training Complete ===")
        print(f"Total Episodes: {total_episodes}")
        print(f"Total Wins: {total_wins} ({win_rate*100:.1f}%)")
        print(f"Average Loss: {avg_loss:.4f}")
        print(f"Average Reward: {avg_reward:.2f}")
        
        plt.figure(figsize=(15, 5))
        plt.subplot(1, 3, 1)
        plt.title('Training Loss')
        plt.plot(self.episode_losses, label='Loss')
        if self.moving_avg_loss:
            plt.plot(
                range(self.window_size-1, len(self.moving_avg_loss)+self.window_size-1), 
                self.moving_avg_loss, label='Moving Avg'
            )
        plt.legend()
        
        plt.subplot(1, 3, 2)
        plt.title('Episode Rewards')
        plt.plot(self.episode_rewards, label='Reward')
        if self.moving_avg_reward:
            plt.plot(
                range(self.window_size-1, len(self.moving_avg_reward)+self.window_size-1),
                self.moving_avg_reward, label='Moving Avg'
            )
        plt.legend()
        
        plt.subplot(1, 3, 3)
        plt.title('Win Rate (Rolling 100)')
        rolling_win = [sum(self.win_history[i:i+100]) for i in range(len(self.win_history))]
        plt.plot(rolling_win)
        plt.tight_layout()
        plt.savefig('training_results.png')
        plt.close()

if __name__ == "__main__":
    trainer = PokerTrainer()
    trainer.train()
