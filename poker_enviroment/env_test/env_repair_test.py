import time
from agents.random_agent import RandomAgent
from agents.console_player import ConsolePlayer

from enviroment import PokerEnv

GAMES_TO_PLAY=10

def main():
    agents = [RandomAgent() for _ in range(4)]

    env = PokerEnv(agents)
    env.reset()

    print("Starting a new sim...\n")
    env.render()
    while env.game.games_played<GAMES_TO_PLAY:
        current_index = env.game.current_player_index
        observation = env._get_observation(current_index)

        action, amount = agents[current_index].act(observation)
        action_str = action.name + (f" (raise: {amount})" if amount is not None else "")
        print(f"Player {current_index} takes action: {action_str}\n")

        env.game.step(action, amount)
        env.render()
        if env.game.chip_data_flag:

            print(env.game.get_chip_earning_data())
        # Waiting input
        input()
    print("Sim finished")


if __name__ == "__main__":
    main()
