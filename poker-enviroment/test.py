import time
from agents.random_agent import RandomAgent  # Ensure this path is correct in your project.

from enviroment import PokerEnv

def main():
    agents = [RandomAgent() for _ in range(4)]
    
    env = PokerEnv(agents)
    
    env.reset()
    print("Starting a new hand...\n")
    env.render()
    
    step_count = 0
    while not env.game.hand_over:
        current_index = env.game.current_player_index
        print(f"\nStep {step_count}:\n\nIt's Player {current_index}'s turn.")
        
        observation = env._get_observation(current_index)
        
        action, amount = agents[current_index].act(observation)
        action_str = action.name + (f" (raise: {amount})" if amount is not None else "")
        print(f"Player {current_index} takes action: {action_str}\n")
        
        env.game.step(action, amount)
        
        env.render()
        step_count += 1
        
    
    winners = env.game.determine_winners()
    print(f"\nHand over! Winner is Player(s) {winners}")

if __name__ == "__main__":
    main()
