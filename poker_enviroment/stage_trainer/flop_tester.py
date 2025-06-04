import torch
from enviroment import PokerEnv
from game.poker_game import Action
from impoved_dqn_agent import DQNAgent

model_path = 'pretrained_models/pretrained_flop/dqn_model.pth'

class FlopTester:
    def __init__(self, num_episodes=100):
        self.num_episodes = num_episodes
        self.dqn_agent = DQNAgent(player_id=0)
        self.dqn_agent.model.load_state_dict(torch.load(model_path))
        self.dqn_agent.epsilon = 0.0
        self.dqn_agent.epsilon_end = 0.0

    def test(self):
        for episode in range(1, self.num_episodes + 1):
            env = PokerEnv([self.dqn_agent])
            env.game.deal_hole_cards()
            env.game.deal_community_cards(5)

            observation = env._get_observation(self.dqn_agent.player_id)
            action, _ = self.dqn_agent.act(observation)
            env.game.evaluate_best_hand(env.game.players[self.dqn_agent.player_id])

            rank = env.game.players[self.dqn_agent.player_id].best_hand["rank"]
            print(f"Episode {episode}: Hand Rank = {rank}, Action = {action.name}")
            input()


if __name__ == "__main__":
    tester = FlopTester(num_episodes=100)
    tester.test()
