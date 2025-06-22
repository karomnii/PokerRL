import random
from datetime import datetime
import matplotlib.pyplot as plt
import numpy as np
import torch
from training_stage_helper.encoded_card_evaluator import EncodedCardEvaluator

from sympy.physics.units import action

from torch.utils.tensorboard import SummaryWriter

from agents.aggresive_agent import AggressiveAgent
from agents.pseudo_inteligent_agent import PseudoIntelligent
from agents.cautious_agent import CautiousAgent
from agents.random_agent import RandomAgent
from game.poker_game import Action, PokerGame
from enviroment.poker_env import PokerEnv
from impoved_dqn_agent import DQNAgent
from training_stage_helper.preflop_chart_evaluator import PreflopChartEvaluator

ece = EncodedCardEvaluator()
pce = PreflopChartEvaluator()
pce.load_chart_from_file("training_stage_helper/DQN_preflop_chart.json")

class PokerTrainer:
    def __init__(self):
        self.update_grace_period = 5000
        self.num_episodes = 501_000
        self.update_target_every = 100
        self.save_every = 20_000
        self.print_stats_every = 250
        self.window_size = 1000
        self.total_earnings = 0

        self.episode_losses = []
        self.episode_rewards = []
        self.episode_earnings = []
        self.episode_epsilon = []
        self.episode_actions = []
        self.win_history = []
        self.earnings_history = []
        self.moving_avg_loss = []
        self.moving_avg_reward = []
        self.moving_avg_earnings = []
        self.moving_avg_actions = []

        self.writer = SummaryWriter()
        
        self.dqn_agent = DQNAgent(player_id=0)

        self.agents = [self.dqn_agent] + [CautiousAgent(), PseudoIntelligent(), AggressiveAgent()]
        #self.agents[0].model.load_state_dict(torch.load('./best_models/2025-06-12_08-29-15-023/dqn_model.pth',map_location=torch.device('cpu')))
        # self.agents = [self.dqn_agent] + [DQNAgent(player_id=i+1) for i in range(2)] + [RandomAgent()]
        #
        # #Load models
        # self.agents[1].model.load_state_dict(torch.load('./models/2025-04-22_23-51-42-711/dqn_model.pth'))
        # self.agents[1].epsilon=0
        # self.agents[2].model.load_state_dict(torch.load('./models/2025-04-19_13-11-31-302/dqn_model.pth'))
        # self.agents[2].epsilon=0
        # self.num_episodes += 1
        


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
        env.game.evaluate_best_hand(agent_player)

        # Compare against each other player who hasn't folded:
        for p in env.game.players:
            if not p.folded and p.player_id != dqn_player_id:
                env.game.evaluate_best_hand(p)
                if agent_player.best_hand["rank"]<p.best_hand["rank"]:
                    return False
                elif agent_player.best_hand["rank"]==p.best_hand["rank"]:
                    temp = env.game.compare_hands(agent_player.best_hand["hand"], p.best_hand["hand"],agent_player.best_hand["rank"])
                    if temp is p.best_hand["hand"]:
                        return False
        return True


    def _calculate_reward(self, env, dqn_player_id, folded, episode_transitions):
        if len(episode_transitions) == 1:
            card1 = ece._decode_onehotencoded_card(episode_transitions[0]['state'][:17])
            card2 = ece._decode_onehotencoded_card(episode_transitions[0]['state'][17:34])
            if episode_transitions[0]['action']==Action.FOLD:
                if pce.evaluate(card1, card2) == 'raise':
                    return -0.7
                elif pce.evaluate(card2, card1) == 'call':
                    return -0.2
                else:
                    return 0.3
            elif episode_transitions[0]['action']==Action.RAISE:
                if pce.evaluate(card1, card2) == 'fold':
                    return -0.7
                elif pce.evaluate(card2, card1) == 'call':
                    return 0.1
                else:
                    return 0.3
            else:
                if pce.evaluate(card1, card2) == 'fold':
                    return -0.2
                elif pce.evaluate(card2, card1) == 'raise':
                    return 0.1
                else:
                    return 0.3

        # discourage bad folds
        if folded:
            cards=[]
            for i in range(7):
                card_vector = episode_transitions[len(episode_transitions)-1]['state'][i*17:(i+1)*17]
                # Workaround since -1 was encoded as no card instead of 0 so the empty vector looks like this
                if not torch.equal(card_vector, torch.tensor([0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 1., 0., 0., 0., 0.])):
                    cards.append(ece._decode_onehotencoded_card(episode_transitions[len(episode_transitions)-1]['state'][i*17:(i+1)*17]))
            pocked_card_evaluation = pce.evaluate(cards[0], cards[1])
            if len(cards)==2:
                if pocked_card_evaluation == 'fold':
                    return 0.1
                else:
                    return -0.4
            elif len(cards) == 5:
                rank,hand = ece.evaluate_best_hand(cards[:2],cards[2:])
                if rank >= 4:
                    return -0.8
                elif rank >= 2:
                    return -0.4
                else:
                    if pocked_card_evaluation == 'fold':
                        return 0.1
                    else:
                        return -0.2
            elif len(cards) == 6:
                rank, hand = ece.evaluate_best_hand(cards[:2], cards[2:])
                if rank >= 4:
                    return -0.9
                elif rank >= 2:
                    return -0.35
                else:
                    if pocked_card_evaluation == 'fold':
                        return 0.2
                    else:
                        return -0.3
            else:
                rank, hand = ece.evaluate_best_hand(cards[:2], cards[2:])
                if rank >= 4:
                    return -1
                elif rank >= 2:
                    return -0.3
                else:
                    if pocked_card_evaluation == 'fold':
                        return 0.3
                    else:
                        return -0.4

        net_chips = env.game.get_chip_earning_data()[dqn_player_id]
        self.total_earnings+=net_chips
        scale_factor = env.game.big_blind * 50
        chip_reward = np.clip(net_chips / scale_factor, -1.0, 1.0)

        return chip_reward



    def _assign_rewards(self, transitions, final_reward, gamma=0.95):
        """
        N-step / Monte Carlo style with discounting: 
        The last action sees final_reward, the step before sees gamma * final_reward, etc.
        """
        transitions_with_rewards = []
        cumulative = final_reward
        # Start from the last step, moving backwards
        for transition in reversed(transitions):
            # The last step sees final_reward, 
            # earlier steps get successively discounted
            # Build a new dict so as not to mutate the original
            transition_with_reward = {
                'state': transition['state'],
                'action': transition['action'],
                'amount': transition['amount'],
                'folded': transition['folded'],
                'reward': cumulative
            }
            transitions_with_rewards.append(transition_with_reward)
            cumulative *= gamma

        # Reverse back to chronological order
        transitions_with_rewards.reverse()
        return transitions_with_rewards


    def run_episode(self):
        env = PokerEnv(self.agents)
        env.reset()
        episode_transitions = []
        dqn_player_id = self.dqn_agent.player_id

        folded = False  # Track if the DQN agent ended up folding
        
        while not env.game.chip_data_flag:
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
        final_reward = self._calculate_reward(env, dqn_player_id, folded, episode_transitions)
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
        won = False
        if env.game.get_chip_earning_data()[dqn_player_id]>0:
            won = True

        
        return won, final_reward, len(episode_transitions),env.game.get_chip_earning_data()[dqn_player_id]

    

    def train(self):
        for episode in range(self.num_episodes):
            won, episode_reward, num_actions, net_chips = self.run_episode()

            loss = self.dqn_agent.update_model()
            
            if loss is not None:
                self.episode_losses.append(loss)
                self.episode_rewards.append(episode_reward)
                self.episode_earnings.append(net_chips)
                self.episode_epsilon.append(self.dqn_agent.epsilon)
                self.episode_actions.append(num_actions)
                self.win_history.append(won)

                if len(self.episode_losses) >= self.window_size:
                    self.moving_avg_loss.append(
                        sum(self.episode_losses[-self.window_size:])/self.window_size
                    )
                    self.moving_avg_reward.append(
                        sum(self.episode_rewards[-self.window_size:])/self.window_size
                    )
                    self.moving_avg_earnings.append(
                        sum(self.episode_earnings[-self.window_size:])/self.window_size
                    )
                    self.moving_avg_actions.append(
                        sum(self.episode_actions[-self.window_size:]) / self.window_size
                    )

            if episode > self.update_grace_period:
                if episode % self.save_every == 0 and episode > 0:
                    self.dqn_agent.save_model()
            
            if loss is not None:
                self.writer.add_scalar('Loss/train', loss, episode)
                self.writer.add_scalar('Reward/episode', episode_reward, episode)
                self.writer.add_scalar('Exploration/epsilon', self.dqn_agent.epsilon, episode)
            
            if episode % self.print_stats_every == 0 and episode > 0:
                recent_wins = sum(self.win_history[-self.print_stats_every:])
                recent_earnings = sum(self.episode_earnings[-self.print_stats_every:])
                avg_loss = sum(self.episode_losses[-self.print_stats_every:]) / self.print_stats_every
                avg_reward = sum(self.episode_rewards[-self.print_stats_every:]) / self.print_stats_every
                
                print(f"Episode {episode}/{self.num_episodes} | "
                      f"Avg Loss: {avg_loss:.4f} | "
                      f"Avg Reward: {avg_reward:.2f} | "
                      f"Epsilon: {self.dqn_agent.epsilon:.3f} | "
                      f"Actions: {sum(self.episode_actions[-self.window_size:]) / self.window_size} | "
                      f"AVG Net Chips: {recent_earnings/self.print_stats_every} | ")
        
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
        print(f"Total earnings: {self.total_earnings}")
        print(f"Avrage earnings: {self.total_earnings/self.num_episodes}")

        plt.figure(figsize=(18, 10))  # Larger figure to fit 6 plots

        plt.subplot(2, 3, 1)
        plt.title('Training Loss')
        plt.plot(self.episode_losses, label='Loss')
        plt.legend()

        plt.subplot(2, 3, 2)
        plt.title('Moving Avg Loss')
        if self.moving_avg_loss:
            plt.plot(
                range(self.window_size - 1, len(self.moving_avg_loss) + self.window_size - 1),
                self.moving_avg_loss, label='Moving Avg'
            )
            plt.legend()

        plt.subplot(2, 3, 3)
        plt.title('Episode Epsilon')
        plt.plot(self.episode_epsilon, label='Epsilon')
        plt.legend()

        plt.subplot(2, 3, 4)
        plt.title('Moving Avg Reward')
        if self.moving_avg_reward:
            plt.plot(
                range(self.window_size - 1, len(self.moving_avg_reward) + self.window_size - 1),
                self.moving_avg_reward, label='Moving Avg'
            )
            plt.legend()

        plt.subplot(2, 3, 5)
        plt.title('Actions')
        plt.plot(
            range(self.window_size - 1, len(self.moving_avg_actions) + self.window_size - 1),
            self.moving_avg_actions, label='Moving Actions Avg'
        )

        plt.subplot(2, 3, 6)
        plt.title('Moving Avg Net Chips')
        if self.moving_avg_earnings:
            plt.plot(
                range(self.window_size - 1, len(self.moving_avg_earnings) + self.window_size - 1),
                self.moving_avg_earnings, label='Moving Chip Avg'
            )
            plt.legend()

        plt.tight_layout()
        plt.savefig('training_results.png')
        plt.close()


if __name__ == "__main__":
    trainer = PokerTrainer()
    trainer.train()
