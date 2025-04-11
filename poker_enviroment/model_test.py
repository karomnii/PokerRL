import time
import torch
from agents.random_agent import RandomAgent
from dqn_agent import DQNAgent
from game.poker_game import PokerGame, Action
from enviroment.poker_env import PokerEnv

def play_with_model(model_path='dqn_model.pth', num_hands=5, render_speed=0.7):
    """
    Loads a trained DQN model and has it play against 3 RandomAgents for 'num_hands' hands.
    Tracks both win rates and chip economy for all players.
    """
    
    # Initialize agents
    dqn_agent = DQNAgent(player_id=0)
    dqn_agent.model.load_state_dict(torch.load(model_path))
    dqn_agent.model.eval()
    
    agents = [dqn_agent] + [RandomAgent() for _ in range(3)]
    num_players = len(agents)
    
    # Player statistics tracking
    player_stats = [
        {
            'player_id': i,
            'hands_played': 0,
            'hands_won': 0,
            'folds': 0,
            'calls': 0,
            'raises': 0,
            'chips_won': 0,
            'starting_stack': 0,
            'total_bet': 0
        }
        for i in range(num_players)
    ]
    
    hand_results = []
    
    for hand_num in range(1, num_hands + 1):
        env = PokerEnv(agents)
        env.reset()
        
        # Record initial state
        for i, player in enumerate(env.game.players):
            player_stats[i]['starting_stack'] = player.chips + player.current_bet
            player_stats[i]['total_bet'] = 0
            player_stats[i]['hands_played'] += 1
        
        print(f"\n=== Hand {hand_num}/{num_hands} ===")
        env.render()
        
        while not env.game.hand_over:
            current_idx = env.game.current_player_index
            player = env.game.players[current_idx]
            observation = env._get_observation(current_idx)
            
            # Track bets before action
            pre_action_stack = player.chips
            pre_action_bet = player.current_bet
            
            # Get and execute action
            action, amount = agents[current_idx].act(observation)
            env.game.step(action, amount)
            
            # Track betting activity
            bet_delta = (pre_action_stack - player.chips) + (player.current_bet - pre_action_bet)
            player_stats[current_idx]['total_bet'] += bet_delta
            
            # Track action types
            if action == Action.FOLD:
                player_stats[current_idx]['folds'] += 1
            elif action == Action.CALL:
                player_stats[current_idx]['calls'] += 1
            elif action == Action.RAISE:
                player_stats[current_idx]['raises'] += 1
            
            env.render()
            time.sleep(render_speed)
        
        # Calculate chip changes
        winners = env.game.determine_winners()
        pot = sum(player.current_bet for player in env.game.players)
        
        for i, player in enumerate(env.game.players):
            # Calculate net chips won/lost
            final_stack = player.chips
            initial_total = player_stats[i]['starting_stack']
            net_chips = final_stack - initial_total
            
            # Adjust for pot winnings
            if i in winners:
                net_chips += pot / len(winners)
            
            player_stats[i]['chips_won'] += net_chips
            
            # Track wins
            player_stats[i]['hands_won'] += 1 if i in winners else 0
        
        hand_results.append(0 in winners)
    
    # Print comprehensive results
    print("\n=== Final Performance Report ===")
    print(f"Total Hands Played: {num_hands}")
    print(f"Total Pots Contested: {sum(1 for res in hand_results if res)}")
    print("-" * 50)
    
    # Chip economy overview
    total_chips_in_play = sum(abs(stats['chips_won']) for stats in player_stats)
    dqn_net = player_stats[0]['chips_won']
    opponents_net = sum(stats['chips_won'] for stats in player_stats[1:])
    
    print(f"\n{'Chip Economy':<25} {'Total':<15} {'Avg/Hand':<15}")
    print(f"{'-'*25} {'-'*15} {'-'*15}")
    print(f"{'DQN Net Chips':<25} {dqn_net:>+,}{'':<15} {dqn_net/num_hands:>+8.1f}{'':<15}")
    print(f"{'Opponents Net Chips':<25} {opponents_net:>+,}{'':<15} {opponents_net/num_hands:>+8.1f}{'':<15}")
    print(f"{'System Imbalance':<25} {dqn_net + opponents_net:>+,}{'':<15}")
    print("\n" + "-"*50)

    # DQN Agent detailed breakdown
    dqn_stats = player_stats[0]
    print(f"\n{'DQN Agent Performance':^50}")
    print(f"{'Metric':<25} {'Total':<15} {'Per Hand':<15}")
    print(f"{'-'*25} {'-'*15} {'-'*15}")
    print(f"{'Hands Won':<25} {dqn_stats['hands_won']:<15} {dqn_stats['hands_won']/num_hands:.1%}")
    print(f"{'Net Chips':<25} {dqn_stats['chips_won']:>+,} {dqn_stats['chips_won']/num_hands:>+8.1f}")
    print(f"{'Total Raises':<25} {dqn_stats['raises']:<15} {dqn_stats['raises']/num_hands:.1f}")
    print(f"{'Total Calls':<25} {dqn_stats['calls']:<15} {dqn_stats['calls']/num_hands:.1f}")
    print(f"{'Total Folds':<25} {dqn_stats['folds']:<15} {dqn_stats['folds']/num_hands:.1f}")
    print(f"{'Aggression Frequency':<25} {dqn_stats['raises']/(dqn_stats['calls']+dqn_stats['raises']):.1%}")
    print(f"{'Voluntary Put $ in Pot':<25} {(1 - (dqn_stats['folds']/num_hands)):.1%}")
    print("\n" + "-"*50)

    # Individual opponent breakdowns
    print("\nOpponent Performance Details:")
    for stats in player_stats[1:]:
        print(f"\nPlayer {stats['player_id']}:")
        print(f"  Hands Won:        {stats['hands_won']} ({stats['hands_won']/num_hands:.1%})")
        print(f"  Net Chips:        {stats['chips_won']:>+,} (Avg: {stats['chips_won']/num_hands:>+8.1f}/hand)")
        print(f"  Actions:")
        print(f"    Folds:          {stats['folds']} ({stats['folds']/num_hands:.1%})")
        print(f"    Calls:          {stats['calls']} ({stats['calls']/num_hands:.1%})")
        print(f"    Raises:         {stats['raises']} ({stats['raises']/num_hands:.1%})")
        print(f"  Aggression Ratio: {stats['raises']/max(1, stats['calls']):.2f}")
        print(f"  Total Bets:       {stats['total_bet']:+,}")
        print("-"*50)

    # Replace the Win Distribution Analysis section with this:

    print("\nWin Distribution Analysis:")

    # Initialize counters
    showdown_wins = 0
    preflop_wins = 0
    multiway_wins = 0
    fold_wins = 0

    # Track which rounds the DQN won in
    round_wins = {
        "pre-flop": 0,
        "flop": 0,
        "turn": 0,
        "river": 0,
        "showdown": 0
    }

    # Replay the hand results using available game data
    for i, won in enumerate(hand_results):
        if won:
            # Get the number of active players when hand ended
            active_players = sum(1 for p in env.game.players if not p.folded)
            
            # Count multiway pots (more than one active player at showdown)
            if active_players > 1:
                multiway_wins += 1
                round_wins["showdown"] += 1
                showdown_wins += 1
            else:
                # Determine which betting round the hand ended in
                if env.game.round_stage == "pre-flop":
                    preflop_wins += 1
                    round_wins["pre-flop"] += 1
                elif env.game.round_stage == "flop":
                    round_wins["flop"] += 1
                elif env.game.round_stage == "turn":
                    round_wins["turn"] += 1
                elif env.game.round_stage == "river":
                    round_wins["river"] += 1
                
                # Count wins by forcing folds
                fold_wins += 1

    # Print the analysis
    print(f"Total Wins:             {dqn_stats['hands_won']}")
    print(f"Showdown Wins:          {showdown_wins} ({showdown_wins/max(1,dqn_stats['hands_won']):.1%})")
    print(f"Pre-flop Wins:          {preflop_wins} ({preflop_wins/max(1,dqn_stats['hands_won']):.1%})")
    print(f"Multi-way Pots Won:     {multiway_wins}")
    print(f"Wins by Forcing Folds:  {fold_wins}")

    print("\nWins by Betting Round:")
    for stage, count in round_wins.items():
        if count > 0:
            print(f"  {stage.title():<10}: {count} ({count/max(1,dqn_stats['hands_won']):.1%})")

    # Calculate and display aggression metrics
    total_actions = dqn_stats['folds'] + dqn_stats['calls'] + dqn_stats['raises']
    if total_actions > 0:
        print("\nAction Frequencies:")
        print(f"  Fold Frequency  : {dqn_stats['folds']/total_actions:.1%}")
        print(f"  Call Frequency  : {dqn_stats['calls']/total_actions:.1%}")
        print(f"  Raise Frequency : {dqn_stats['raises']/total_actions:.1%}")
        print(f"  Aggression Ratio:  {dqn_stats['raises']/max(1, dqn_stats['calls']):.2f}")

    # Action frequency visualization
    print("\nAction Frequency Heatmap:")
    for stats in player_stats:
        total_actions = stats['folds'] + stats['calls'] + stats['raises']
        if total_actions == 0:
            continue
            
        folds_pct = stats['folds'] / total_actions
        calls_pct = stats['calls'] / total_actions
        raises_pct = stats['raises'] / total_actions
        
        print(f"\nPlayer {stats['player_id']}:")
        print(f"  Folds : {'█' * int(folds_pct*20)}     {folds_pct:.1%}")
        print(f"  Calls : {'█' * int(calls_pct*20)}     {calls_pct:.1%}")
        print(f"  Raises: {'█' * int(raises_pct*20)}    {raises_pct:.1%}")
    
    # Chip efficiency analysis
    total_dqn_chips = player_stats[0]['chips_won']
    avg_chips_per_hand = total_dqn_chips / num_hands
    print(f"\nDQN Chip Efficiency: {avg_chips_per_hand:.1f} chips/hand")

if __name__ == "__main__":
    play_with_model(
        model_path='./models/2025-04-11_21-02-08-549/dqn_model.pth',
        num_hands=100,
        render_speed=0  # Set to 0 for fast execution
    )