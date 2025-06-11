import time

from agents.pseudo_inteligent_agent import PseudoIntelligent
from agents.random_agent import RandomAgent
from agents.console_player import ConsolePlayer
from impoved_dqn_agent import DQNAgent
import torch
from game.poker_game import Action

from enviroment import PokerEnv

print_stats_every = 50


def play_with_model(model_path='dqn_model.pth', num_hands=5, render_speed=0.7):
    dqn_agent = DQNAgent(player_id=0)
    dqn_agent.model.load_state_dict(torch.load(model_path))
    dqn_agent.model.eval()
    dqn_agent.epsilon=0

    agents = [dqn_agent] + [PseudoIntelligent() for _ in range(3)]
    # agents = [dqn_agent] + [DQNAgent(player_id=i + 1) for i in range(2)] + [RandomAgent()]
    #
    # # Load models
    # agents[1].model.load_state_dict(torch.load('./models/2025-04-22_23-51-42-711/dqn_model.pth'))
    # agents[1].epsilon = 0
    # agents[2].model.load_state_dict(torch.load('./models/2025-04-19_13-11-31-302/dqn_model.pth'))
    # agents[2].epsilon = 0
    model_earnings=0
    hands_played = 0
    env = PokerEnv(agents)
    env.reset()
    recent_earnings=0
    actions_made = {
        Action.CALL: 0,
        Action.RAISE: 0,
        Action.FOLD: 0
    }
    print("Starting a new sim...\n")
    #env.render()
    while hands_played < num_hands:
        current_index = env.game.current_player_index
        observation = env._get_observation(current_index)

        action, amount = agents[current_index].act(observation)
        #action_str = action.name + (f" (raise: {amount})" if amount is not None else "")
        #print(f"Player {current_index} takes action: {action_str}\n")

        env.game.step(action, amount)
        if current_index == 0:
            actions_made[action] += 1
        if env.game.chip_data_flag:
            earnings = env.game.get_chip_earning_data()[0]
            recent_earnings+= earnings
            model_earnings += earnings
            hands_played += 1
            env.game.restart_table()
            if hands_played % print_stats_every == 0 and hands_played > 0:
                print(f"Episode{hands_played}/{num_hands}   Recent Earnings: {recent_earnings}, Average earnings {recent_earnings / print_stats_every}")
                recent_earnings = 0
        # env.render()

        # Waiting input
        # input()
    print(f"Actions made: {actions_made}")
    print(f"Sim finished model earned: {model_earnings} Per Hand {model_earnings/hands_played}")

if __name__ == "__main__":
    play_with_model(
        #model_path='./models/2025-05-08_21-27-41-675/dqn_model.pth',
        #Goat
        model_path='./models/2025-06-11_11-51-19-187/dqn_model.pth',
        num_hands=2_000,
        render_speed=0  # Set to 0 for fast execution
    )
