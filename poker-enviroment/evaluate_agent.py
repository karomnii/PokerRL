import numpy as np
import matplotlib.pyplot as plt
import argparse
from tqdm import tqdm

from enviroment import PokerEnv
from agents.dqn_agent import DQNAgent
from agents.random_agent import RandomAgent
from game.poker_game import Action

def evaluate_agent(agent, num_games=2000, opponent_type='random'):
    """Evaluate agent performance against specified opponents"""
    if opponent_type == 'random':
        opponents = [RandomAgent() for _ in range(3)]
    else:
        # Other opponent types
        pass
    
    all_agents = [agent] + opponents
    env = PokerEnv(all_agents)
    
    wins = 0
    total_reward = 0
    actions_taken = {"FOLD": 0, "CALL": 0, "RAISE": 0}
    hands_played = 0
    total_hands = 0
    chips_won = 0
    starting_chips = 1000  # Adjust to match your game config
    
    for game in tqdm(range(num_games)):
        env.reset()
        game_reward = 0
        
        while not env.game.hand_over:
            current_index = env.game.current_player_index
            observation = env._get_observation(current_index)
            
            action, amount = all_agents[current_index].act(observation)
                
            if current_index == 0:
                actions_taken[action.name] += 1
                reward, _ = env.step_rl(current_index, action, amount)
                game_reward += reward
            else:
                env.game.step(action, amount)
    
        total_hands += 1
            
        if env.game.winners is not None and 0 in env.game.winners:
            wins += 1
            chips_won += env.game.players[0].chips - starting_chips
            
        total_reward += game_reward


    # Calculate additional statistics
    hands_played_pct = hands_played / total_hands if total_hands > 0 else 0
    action_distribution = {action: count/sum(actions_taken.values()) 
                           for action, count in actions_taken.items()}
    bb_per_100 = (chips_won / 20) / (num_games / 100)  # Assuming big blind is 20
    
    return {
        'win_rate': wins / num_games,
        'avg_reward': total_reward / num_games,
        'hands_played_pct': hands_played_pct,
        'action_distribution': action_distribution,
        'bb_per_100': bb_per_100,
        'total_hands': total_hands,
        'wins_from_env.game': env.games_won_by_agents
    }

def plot_learning_curve(rewards_history):
    """Plot the rewards during training"""
    plt.figure(figsize=(10, 6))
    plt.plot(rewards_history)
    plt.title('DQN Learning Curve')
    plt.xlabel('Episode')
    plt.ylabel('Total Reward')
    plt.savefig('learning_curve.png')
    plt.show()
