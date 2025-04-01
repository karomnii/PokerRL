import time
import torch
from agents.random_agent import RandomAgent
from dqn_agent import DQNAgent
from game.poker_game import PokerGame, Action
from enviroment import PokerEnv

def play_with_model(model_path='dqn_model.pth', num_hands=5, render_speed=0.7):
    # Initialize agents and tracking
    dqn_agent = DQNAgent(player_id=0)
    dqn_agent.model.load_state_dict(torch.load(model_path))
    dqn_agent.model.eval()  # Set to evaluation mode
    
    agents = [dqn_agent] + [RandomAgent() for _ in range(3)]
    dqn_wins = 0
    hand_results = []
    
    for hand_num in range(1, num_hands + 1):
        env = PokerEnv(agents)
        env.reset()
        
        print(f"\n=== Starting Hand {hand_num}/{num_hands} ===")
        print("Player 0: DQN Agent")
        print("Players 1-3: Random Agents")
        env.render()
        
        step_count = 0
        while not env.game.hand_over:
            current_idx = env.game.current_player_index
            print(f"\nStep {step_count}: Player {current_idx}'s turn")
            
            observation = env._get_observation(current_idx)
            
            # Get and execute action
            action, amount = agents[current_idx].act(observation)
            action_str = action.name + (f" (raise: {amount})" if amount is not None else "")
            print(f"Player {current_idx} action: {action_str}")
            
            env.game.step(action, amount)
            
            # Render game state
            env.render()
            step_count += 1
            time.sleep(render_speed)
        
        # Determine winners
        winners = env.game.determine_winners()
        dqn_won = 0 in winners
        dqn_wins += 1 if dqn_won else 0
        hand_results.append(dqn_won)
        
        print(f"\nHand over! Winner(s): {winners}")
        print(f"DQN Agent {'won' if dqn_won else 'lost'} this hand")
        # time.sleep(1)  # Pause between hands
    
    # Print final statistics
    print("\n=== Final Results ===")
    print(f"Hands played: {num_hands}")
    print(f"DQN Agent wins: {dqn_wins} ({dqn_wins/num_hands*100:.1f}%)")
    print(f"Win/loss sequence: {['W' if result else 'L' for result in hand_results]}")
    
    # Additional statistics
    showdowns = sum(1 for result in hand_results if result is not None)
    if showdowns > 0:
        print(f"Showdown win rate: {dqn_wins/showdowns*100:.1f}%")
    else:
        print("No showdowns occurred")

if __name__ == "__main__":
    play_with_model(
        model_path='./models/2025-04-01_12-39-19-015/dqn_model.pth',
        num_hands=1000,
        render_speed=0
    )