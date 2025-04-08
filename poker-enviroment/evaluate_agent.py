import numpy as np
import matplotlib.pyplot as plt
import argparse

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
    
    for game in range(num_games):
        env.reset()
        game_reward = 0
        agent_acted = False
        
        while not env.game.hand_over:
            current_index = env.game.current_player_index
            observation = env._get_observation(current_index)
            
            try:
                action, amount = all_agents[current_index].act(observation)
                
                # Validate raise amount
                if action == Action.RAISE:
                    call_amt = env.game.get_call_amount(current_index)
                    if amount <= call_amt:
                        # Fix invalid raise
                        amount = call_amt + 1
                
                if current_index == 0:  # Our agent
                    agent_acted = True
                    # Track action distribution
                    actions_taken[action.name] += 1
                    next_observation, reward, done, _ = env.step_rl(current_index, action, amount)
                    game_reward += reward
                else:
                    env.game.step(action, amount)
            except ValueError as e:
                # If action fails, default to FOLD
                print(f"Agent {current_index} made invalid action, defaulting to FOLD")
                action = Action.FOLD
                amount = None
                if current_index == 0:
                    next_observation, reward, done, _ = env.step_rl(current_index, action, amount)
                    game_reward += reward
                else:
                    env.game.step(action, amount)
    
        total_hands += 1
        if agent_acted and not all_agents[0].folded:
            hands_played += 1
            
        if env.game.winners is not None and 0 in env.game.winners:
            wins += 1
            # Track chips won
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
        'total_hands': total_hands
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

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Evaluate DQN Poker Agent')
    parser.add_argument('--model_path', type=str, default='models/dqn_poker_final.pt',
                        help='Path to the model file')
    parser.add_argument('--games', type=int, default=100,
                        help='Number of games to evaluate')
    args = parser.parse_args()
    
    # Initialize agent
    state_dim = 15  # Same as in training
    action_dim = 3
    agent = DQNAgent(state_dim=state_dim, action_dim=action_dim)
    agent.load(args.model_path)
    
    # Set epsilon to a small value for some exploration during evaluation
    agent.epsilon = 0.05
    
    # Evaluate
    results = evaluate_agent(agent, num_games=args.games)
    print(f"Evaluation results:")
    print(f"Win rate: {results['win_rate']:.2f}")
    print(f"Average reward: {results['avg_reward']:.2f}")
