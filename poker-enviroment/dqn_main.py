import argparse
import torch
import numpy as np
import os

from train_dqn import train_dqn
from evaluate_agent import evaluate_agent, plot_learning_curve
from agents.dqn_agent import DQNAgent

def main():
    parser = argparse.ArgumentParser(description='Poker DQN Training')
    parser.add_argument('--mode', type=str, default='train', 
                        choices=['train', 'evaluate'],
                        help='Operation mode')
    parser.add_argument('--episodes', type=int, default=10000,
                        help='Number of training episodes')
    parser.add_argument('--model_path', type=str, default=None,
                        help='Path to saved model for evaluation')
    parser.add_argument('--games', type=int, default=10000,
                        help='Number of games to evaluate')
    args = parser.parse_args()
    
    # Create directories
    os.makedirs('models', exist_ok=True)
    
    # Define state dimensions based on one-hot encoding
    state_dim = 52  # One input per card in the deck
    action_dim = 3  # FOLD, CALL, RAISE
    
    if args.mode == 'train':
        print("Starting DQN training...")
        agent, rewards = train_dqn(episodes=args.episodes)
        plot_learning_curve(rewards)
    elif args.mode == 'evaluate':
        if args.model_path is None:
            args.model_path = 'models/dqn_poker_final.pt'
            
        print(f"Evaluating model from {args.model_path}...")
        agent = DQNAgent(state_dim=state_dim, action_dim=action_dim)
        
        try:
            agent.load(args.model_path)
            # Set epsilon to a small value for some exploration during evaluation
            agent.epsilon = 0.05
            
            results = evaluate_agent(agent, num_games=args.games)
            # In dqn_main.py
            print(f"Evaluation results:")
            print(f"Win rate: {results['win_rate']:.2f}")
            print(f"Average reward: {results['avg_reward']:.2f}")
            print(f"Hands played: {results['hands_played_pct']:.2%}")
            print(f"Action distribution:")
            for action, pct in results['action_distribution'].items():
                print(f"  {action}: {pct:.2%}")
            print(f"BB/100: {results['bb_per_100']:.2f}")
            print(f"Total hands: {results['total_hands']}")

        except Exception as e:
            print(f"Error loading model: {e}")
    
if __name__ == "__main__":
    main()
