import time
from agents.random_agent import RandomAgent
from agents.console_player import ConsolePlayer 

from enviroment import PokerEnv

RENDER_SPEED = 0.7

def main():
    agents = [RandomAgent() for _ in range(3)]
    agents.append(ConsolePlayer())
    
    env = PokerEnv(agents)
    
    env.reset()
    print("Starting a new hand...\n")
    env.render()
    
    step_count = 0
    while not env.game.hand_over:
        current_index = env.game.current_player_index
        if current_index != 3:
            print(f"\nStep {step_count}:\n\nIt's Player {current_index}'s turn.")
        
        observation = env._get_observation(current_index)
        
        action, amount = agents[current_index].act(observation)
        action_str = action.name + (f" (raise: {amount})" if amount is not None else "")
        if current_index == 3:
            print(f"Console player takes action: {action_str}\n")
        else:
            print(f"Player {current_index} takes action: {action_str}\n")
        
        env.game.step(action, amount)
        
        env.render()
        step_count += 1

        if current_index != 3:
            time.sleep(RENDER_SPEED)
        
    
    winners = env.game.determine_winners()
    if len(winners) == 1 and winners[0] == 3:
        print("Console player wins!")
    elif len(winners) == 1:
        print(f"Player {winners[0]} wins!")
    else:
        print(f"\nHand over! Winner is Player(s) {winners}, console player number is 3")

if __name__ == "__main__":
    main()
