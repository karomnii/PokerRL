import time
import torch
from agents.random_agent import RandomAgent
from dqn_agent import DQNAgent
from game.poker_game import PokerGame, Action
from enviroment.poker_env import PokerEnv

def play_with_model(model_path='dqn_model.pth', num_hands=5, render_speed=0.7):
    """
    Loads a trained DQN model and has it play against 3 RandomAgents for 'num_hands' hands.
    During play, detailed statistics are gathered for all players.
    """
    
    # --- 1) Initialize Agents ---
    dqn_agent = DQNAgent(player_id=0)
    dqn_agent.model.load_state_dict(torch.load(model_path))
    dqn_agent.model.eval()  # Set to evaluation mode
    
    agents = [dqn_agent] + [RandomAgent() for _ in range(3)]
    num_players = len(agents)
    
    # --- 2) Statistics Tracking for Each Player ---
    # We track action counts, hands played, hands won, etc.
    player_stats = [
        {
            'player_id': i,
            'hands_played': 0,
            'hands_won': 0,
            'folds': 0,
            'calls': 0,
            'raises': 0,
            # Optionally track total chips won if your environment supports it:
            # 'chip_change': 0
        }
        for i in range(num_players)
    ]
    
    # Track pot sizes if your environment provides env.game.pot or similar
    pot_sizes = []
    
    # Per-hand tracking
    hand_results = []
    
    # --- 3) Simulate Multiple Hands ---
    for hand_num in range(1, num_hands + 1):
        env = PokerEnv(agents)
        env.reset()
        
        # Before the hand starts, increment "hands_played" for all active players:
        for i in range(num_players):
            player_stats[i]['hands_played'] += 1
        
        print(f"\n=== Starting Hand {hand_num}/{num_hands} ===")
        print("Player 0: DQN Agent")
        print("Players 1-3: Random Agents")
        
        env.render()
        
        step_count = 0
        
        # (Optional) If environment has per-player chip info, record it:
        # start_chips = env.game.chips[:]  # if env.game.chips is a list of chip counts
        
        while not env.game.hand_over:
            current_idx = env.game.current_player_index
            print(f"\nStep {step_count}: Player {current_idx}'s turn")
            
            observation = env._get_observation(current_idx)
            
            action, amount = agents[current_idx].act(observation)
            
            # Track action counts
            if action == Action.FOLD:
                player_stats[current_idx]['folds'] += 1
            elif action == Action.CALL:
                player_stats[current_idx]['calls'] += 1
            elif action == Action.RAISE:
                player_stats[current_idx]['raises'] += 1
            
            # Print the action
            action_str = action.name
            if amount is not None:
                action_str += f" (raise: {amount})"
            print(f"Player {current_idx} action: {action_str}")
            
            # Step the environment
            env.game.step(action, amount)
            
            # Render game state
            env.render()
            step_count += 1
            time.sleep(render_speed)
        
        # Once the hand is over, we determine winners
        winners = env.game.determine_winners()
        print(f"\nHand over! Winner(s): {winners}")
        
        # Update winner stats
        for w in winners:
            player_stats[w]['hands_won'] += 1
        
        dqn_won = (0 in winners)
        hand_results.append(dqn_won)
        
        print(f"DQN Agent {'won' if dqn_won else 'lost'} this hand")
        
        # (Optional) If environment has a pot attribute:
        # final_pot = env.game.pot
        # pot_sizes.append(final_pot)
        
        # (Optional) If you want to track chip changes:
        # end_chips = env.game.chips[:]
        # for i in range(num_players):
        #     chip_diff = end_chips[i] - start_chips[i]
        #     player_stats[i]['chip_change'] += chip_diff
    
    # --- 4) Print Final Statistics ---
    print("\n=== Final Results ===")
    print(f"Hands played: {num_hands}")
    
    # Overall DQN stats:
    dqn_wins = sum(hand_results)
    print(f"DQN Agent (Player 0) wins: {dqn_wins} ({dqn_wins/num_hands*100:.1f}%)")
    print("Win/loss sequence:", ['W' if r else 'L' for r in hand_results])
    
    # Per-player aggregated results
    print("\n=== Detailed Player Statistics ===")
    for stats in player_stats:
        pid = stats['player_id']
        hp = stats['hands_played']
        hw = stats['hands_won']
        folds = stats['folds']
        calls = stats['calls']
        raises = stats['raises']
        win_rate = (hw / hp * 100.0) if hp > 0 else 0.0
        
        print(f"--- Player {pid} ---")
        print(f" Hands Played : {hp}")
        print(f" Hands Won    : {hw}  (Win Rate: {win_rate:.1f}%)")
        print(f" Folds        : {folds}")
        print(f" Calls        : {calls}")
        print(f" Raises       : {raises}")
        # If tracking chips:
        # print(f" Total Chip Change: {stats['chip_change']}")  
        print("---------------------")
    
    # If pot sizes were recorded:
    # if pot_sizes:
    #     avg_pot = sum(pot_sizes) / len(pot_sizes)
    #     print(f"Average Final Pot Size: {avg_pot:.2f}")
    
    # Showdown rate if you differentiate between showdown and non-showdown
    # For instance, if you treat a "showdown" as happening when more than one
    # player remains at the end:
    # showdowns = sum(1 for winners in hand_results if len(winners) > 1)  # Pseudocode
    # print(f"Showdown count: {showdowns}")
    # ...
    
    # Summarize how many times the DQN agent participated in a showdown, etc.

if __name__ == "__main__":
    play_with_model(
        model_path='./models/2025-04-07_23-29-22-736/dqn_model.pth',
        num_hands=1000,
        render_speed=0
    )
