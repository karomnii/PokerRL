# Poker Game Engine – Rules and Documentation

This project implements a Texas Hold’em style poker game enviroment with support for multiple players, blinds, betting rounds, all–in handling, side–pot calculations, and tie resolution. This document details the rules and mechanics as defined in the `PokerGame` class.

---

## 1. Overview

The game engine simulates a simplified version of Texas Hold’em poker. It manages:

- Dealing cards (hole cards and community cards)
- Posting blinds
- Running betting rounds
- Evaluating hands
- Determining winners (with side–pot and tie resolution logic)

The engine supports two or more players and follows standard poker betting rounds with additional handling for all–in scenarios and split pots.

---

## 2. Game Structure and Flow

The game is divided into several sequential phases (rounds):

- **Pre-flop:**  
  Each player is dealt two private (hole) cards. No community cards are dealt yet.

- **Flop:**  
  Three community cards are dealt face-up.

- **Turn:**  
  One additional community card is dealt.

- **River:**  
  A final community card is dealt.

- **Showdown:**  
  At the end of the betting rounds, if more than one active player remains, a showdown occurs. The best 5-card poker hand (using any combination of a player’s hole cards and the community cards) wins the pot. In case of ties, the pot is split equally among the winners.

---

## 3. Betting and Turn Order

- **Blinds:**
  - **Two-player game:**  
    The dealer posts the small blind and the other player posts the big blind.
  - **Multi-player game:**  
    The player immediately to the left of the dealer posts the small blind, and the next player posts the big blind.
  - The blinds are posted at the start of the hand and are added to the pot.

- **Initial Turn:**  
  - **Heads-up:** The dealer (small blind) acts first.
  - **Multi-player:** The first actor is determined based on the dealer’s position (typically the player to the left of the big blind).

- **Betting Actions:**  
  Players take turns performing one of the following actions:
  - **FOLD:** The player forfeits the current hand.
  - **CALL:** The player matches the highest bet currently on the table.
  - **RAISE:** The player increases the bet by a specified amount.  
    When a raise occurs, the pending players list is reset so that every active (non-folded and not all–in) player is given a chance to respond.

- **Turn Order Maintenance:**  
  The engine maintains a set of pending players who have yet to act during the current betting round. If a player is all–in or has folded, they are skipped.

---

## 4. All–In Handling and Automatic Completion

- **All–In Players:**  
  When a player does not have enough chips to call a bet, they bet all of their remaining chips and are marked as “all–in.”

- **Automatic Hand Completion:**  
  If all remaining players are either folded or all–in, the game automatically advances through the remaining rounds (dealing any missing community cards) and moves directly to showdown without waiting for further betting actions.

---

## 5. Showdown and Side–Pot Calculations

At showdown, the engine uses side–pot logic to fairly distribute the pot among players:

1. **Contribution Calculation:**  
   Each active player’s total bet is considered their contribution to the pot.

2. **Side Pot Creation:**  
   The pot is divided into portions (side pots) by "peeling off" the smallest contributions. Each side pot includes all players whose contribution meets or exceeds a certain threshold.

3. **Hand Evaluation and Pot Distribution:**  
   - For each side pot, the best hand among eligible players wins that portion.
   - If two or more players tie for the best hand, that pot portion is split equally among them.

4. **Tie Resolution:**  
   The overall winnings are mapped by player ID.

---

## 6. Hand Evaluation

The game engine evaluates the best possible 5-card hand for each player using any combination of their hole cards and the community cards. Hands are ranked using a tuple representation, where a higher tuple indicates a better hand. The rankings are as follows:

- **8 – Straight Flush:**  
  Five sequential cards of the same suit.
- **7 – Four of a Kind:**  
  Four cards of the same rank.
- **6 – Full House:**  
  Three cards of one rank and two cards of another rank.
- **5 – Flush:**  
  Any five cards of the same suit (not in sequence).
- **4 – Straight:**  
  Five sequential cards of mixed suits.
- **3 – Three of a Kind:**  
  Three cards of the same rank.
- **2 – Two Pair:**  
  Two different pairs.
- **1 – One Pair:**  
  Two cards of the same rank.
- **0 – High Card:**  
  No matching combinations.

The evaluation also considers "kickers" (the remaining highest cards) to break ties between hands with the same ranking.

---

## 7. Dealer Rotation

After each hand, the dealer rotates to the next player in sequence. This rotation affects:
- The order in which blinds are posted.
- The initial turn for the following hand.

---

## 8. Additional Notes

- **Chip Management:**  
  - Chips are deducted when players bet (call or raise).
  - Chips are awarded to players when they win a pot (including split pots).

- **Pending Actions:**  
  The game maintains a list of pending players for each betting round, which is updated after each action.

- **Game Termination:**  
  The hand ends automatically when:
  - Only one active player remains.
  - The showdown is reached after the final betting round.
  
  The winners (one or more, in case of ties) are recorded in the `winners` attribute.
