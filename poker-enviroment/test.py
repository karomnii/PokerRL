from agents.random_agent import RandomAgent
from agents.dummy_agent import DummyAgent 

import unittest
from game.poker_game import PokerGame, Action
from game.card import Card, Suit, Rank
from enviroment import PokerEnv

PLAY_FULL_GAME_WITH_LOGS = False

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

class TestPokerGame(unittest.TestCase):
    def setUp(self):
        self.game = PokerGame(num_players=4, small_blind=10, big_blind=20)
        self.game.reset()

    def test_blinds_posted(self):
        # For 4 players with dealer_index = 0:
        #   - Player 1 posts small blind (10 chips)
        #   - Player 2 posts big blind (20 chips)
        p1 = self.game.players[1]
        p2 = self.game.players[2]
        self.assertEqual(p1.current_bet, 10, "Player 1 should have posted the small blind (10)")
        self.assertEqual(p2.current_bet, 20, "Player 2 should have posted the big blind (20)")
        self.assertEqual(self.game.pot, 30, "The pot should equal 30 after blinds are posted")

    def test_deal_hole_cards(self):
        # Verify that each player is dealt 2 cards.
        for p in self.game.players:
            self.assertEqual(len(p.hand), 2, f"Player {p.player_id} should have 2 hole cards")

    def test_round_advancement_all_in(self):
        # Force all players to be all–in so that the game auto–advances to showdown.
        for p in self.game.players:
            p.chips = 0
            p.all_in = True
            p.total_bet = 1000
            p.current_bet = 1000

        self.game.hand_over = False
        self.game.round_stage = "pre-flop"
        self.game.pending_players = set(range(4))
        
        while not self.game.hand_over:
            self.game.step(Action.CALL)
            
        self.assertTrue(self.game.hand_over, "The hand should be marked over when all players are all-in")
        self.assertEqual(self.game.round_stage, "showdown", "Round stage should be 'showdown'")
        self.assertIsNotNone(self.game.winners, "Winners should be determined when all players are all-in")
        
    def test_showdown_tie(self):
        # Set up a scenario where all players have identical hole cards and community cards yield the same best hand.
        shared_hand = [Card(Suit.HEARTS, Rank.ACE), Card(Suit.HEARTS, Rank.KING)]
        for p in self.game.players:
            p.hand = shared_hand.copy()
            p.total_bet = 1000
            p.current_bet = 1000

        # Community cards form a royal flush in hearts for everyone.
        self.game.community_cards = [
            Card(Suit.HEARTS, Rank.QUEEN),
            Card(Suit.HEARTS, Rank.JACK),
            Card(Suit.HEARTS, Rank.TEN),
            Card(Suit.CLUBS, Rank.TWO),
            Card(Suit.DIAMONDS, Rank.THREE)
        ]
        winnings = self.game.showdown()

        winners = [pid for pid, win in winnings.items() if win > 0]
        self.assertTrue(len(winners) > 1, "There should be a tie in the showdown")
        determined_winners = self.game.determine_winners()
        self.assertTrue(len(determined_winners) > 1, "determine_winners should return a tie (multiple winners)")

    def test_simulation_with_dummy_agents(self):
        # Use the environment simulation to run through a full hand.
        from enviroment import PokerEnv
        agents = [DummyAgent(Action.CALL) for _ in range(4)]
        env = PokerEnv(agents)
        env.reset()

        # Run the hand until it is over.
        while not env.game.hand_over:
            current_index = env.game.current_player_index
            observation = env._get_observation(current_index)
            action, amount = agents[current_index].act(observation)
            env.game.step(action, amount)
        
        winners = env.game.determine_winners()
        self.assertIsNotNone(winners, "Winners should be determined after simulation")
        self.assertGreaterEqual(len(winners), 1, "At least one winner must be determined")
    
    def test_simulation_with_random_agents(self):
        from enviroment import PokerEnv
        agents = [RandomAgent() for _ in range(4)]
        env = PokerEnv(agents)
        env.reset()

        while not env.game.hand_over:
            current_index = env.game.current_player_index
            observation = env._get_observation(current_index)
            action, amount = agents[current_index].act(observation)
            env.game.step(action, amount)
        
        winners = env.game.determine_winners()
        self.assertIsNotNone(winners, "Winners should be determined after simulation")
        self.assertGreaterEqual(len(winners), 1, "At least one winner must be determined")

if __name__ == "__main__":
    unittest.main(exit=False)
    if PLAY_FULL_GAME_WITH_LOGS:
        main()
    

