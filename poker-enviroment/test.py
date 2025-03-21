import time
from agents.random_agent import RandomAgent  # Ensure this path is correct in your project.

from enviroment import PokerEnv

def main():
    # Create a list of agents; here we use 2 random agents.
    agents = [RandomAgent() for _ in range(4
                                           )]
    
    # Create the environment with these agents.
    env = PokerEnv(agents)
    
    # Start a new hand.
    env.reset()
    print("Starting a new hand...\n")
    env.render()
    
    step_count = 0
    # Continue until the hand is over.
    while not env.game.hand_over:
        current_index = env.game.current_player_index
        print(f"\nStep {step_count}: It's Player {current_index}'s turn.")
        
        # Get observation for the current player.
        observation = env._get_observation(current_index)
        
        # Agent selects an action.
        action, amount = agents[current_index].act(observation)
        action_str = action.name + (f" (raise: {amount})" if amount is not None else "")
        print(f"Player {current_index} takes action: {action_str}")
        
        # Execute the action in the game.
        env.game.step(action, amount)
        
        # Render the updated game state.
        env.render()
        step_count += 1
        
        # Slow down output for readability.
        time.sleep(1)
    
    # Once the hand is over, determine and print the winner.
    winner = env.game.determine_winner()
    print(f"\nHand over! Winner is Player {winner}")

if __name__ == "__main__":
    main()
