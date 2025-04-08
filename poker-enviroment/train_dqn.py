import numpy as np
import torch
import matplotlib.pyplot as plt
from tqdm import tqdm
import time
import os

from enviroment import PokerEnv
from agents.dqn_agent import DQNAgent
from agents.random_agent import RandomAgent
from game.poker_game import Action

def train_dqn(episodes=10000, batch_size=32, epsilon_start=1.0, epsilon_end=0.01, epsilon_decay=0.999):
    state_dim = 52  # One input per card in the deck
    action_dim = 3  # FOLD, CALL, RAISE
    
    dqn_agent = DQNAgent(
        state_dim=state_dim, 
        action_dim=action_dim,
        epsilon_start=epsilon_start,
        epsilon_end=epsilon_end,
        epsilon_decay=epsilon_decay
    )

    agents = [dqn_agent]
    agents.extend([RandomAgent() for _ in range(3)])  # 3 random opponents
    
    env = PokerEnv(agents)
    rewards_history = []
    
    os.makedirs('models', exist_ok=True)

    observation_processor = dqn_agent.processor
    
    for episode in tqdm(range(episodes)):
        env.reset()
        list_of_move_data = []
        episode_reward = 0
        done = False
        
        # Main training loop
        while not done:
            current_index = env.game.current_player_index
            
            if current_index == 0:  # DQN agent's turn
                observation = env._get_observation(current_index)
                action, amount = dqn_agent.act(observation)
                
                # print(f"DQN_Agent {current_index} action: {action}, amount: {amount}, call_amount: {env.game.get_call_amount(current_index)}")

                reward, _ = env.step_rl(current_index, action, amount)
                
                list_of_move_data.append({
                    'observation': observation_processor.process(observation),
                    'action': action,
                    'reward': reward
                })
                episode_reward += reward
            else:  # Random agents' turn
                observation = env._get_observation(current_index)
                action, amount = agents[current_index].act(observation)

                # print(f"Agent {current_index} action: {action}, amount: {amount}, call_amount: {env.game.get_call_amount(current_index)}")
                
                env.game.step(action, amount)
                
            if env.game.hand_over:
                done = True
                for move in list_of_move_data:
                    move['reward'] = reward/len(list_of_move_data)
                    dqn_agent.memory.add(state=move['observation'],action=move['action'],reward=move['reward'])
        
        # Train after episode is done
        if len(dqn_agent.memory) > batch_size:
            dqn_agent.replay(batch_size)
            
        # Save rewards
        rewards_history.append(episode_reward)
        
        # Periodically save model
        if episode % 10000 == 0 and episode > 0:
            dqn_agent.save(f"models/dqn_poker_{episode}.pt")
            print("Number of folds, calls, raises:", dqn_agent.folds, dqn_agent.calls, dqn_agent.raises)

    # print final statistics
    print("Final number of folds:", dqn_agent.folds)
    print("Final number of calls:", dqn_agent.calls)
    print("Final number of raises:", dqn_agent.raises)

    print("Wins for each agent:")
    for i in range(len(env.games_won_by_agents)):
        print(f"Agent {i}: {env.games_won_by_agents[i]}")

    print("dqn_agent winrate:", env.games_won_by_agents[0] / episodes * 100, "%")

    # Save final model
    dqn_agent.save("models/dqn_poker_final.pt")
    
    return dqn_agent, rewards_history

