# Frozen lake - RL test

## Reference video - https://www.youtube.com/watch?v=EUrWGTCGzlA

Grid-based world where an agent (a character) needs to traverse a frozen lake to reach a goal. However, the ice is slippery, and some tiles might cause the agent to fall into a hole.

### Environment Setup
The environment is typically represented as an N × N grid.
Each tile in the grid can be one of the following:
S (Start): Where the agent begins.
F (Frozen): A safe tile where the agent can move.
H (Hole): A dangerous tile that ends the episode if the agent lands on it.
G (Goal): The destination the agent needs to reach.

Example 4 × 4 grid:

S  F  F  F
F  H  F  H
F  F  F  H
H  F  F  G

States accordingly:

 0  1  2  3
 4  5  6  7
 8  9 10 11
12 13 14 15

Agent Actions:
The agent can move in four directions:
- Left  : 0
- Down  : 1
- Right : 2
- Up    : 3

However, since the ice is slippery, the agent does not always move in the intended direction. Instead, it may slip and move in a different direction with some probability.

Reward Structure
- +1 if the agent reaches the Goal (G).
- 0 for frozen tiles (F) and the start position (S).
- Negative Reward (0 or termination) if the agent falls into a Hole (H).

## Epsilon greedy algorithm

### Both Q-Learning and Deep Q-

eps = 1
if random() < eps:
    select random action
else:
    select best action

### At the end of each episode:

eps = eps - decay rate


## Q-Table

Is a 2D array that in this example is 4 x 16 grid becouse agent can take 4 actions (up, down, right, left) and can be in 16 states (one for each tile in 4x4 grid)

### Q-Learning formula

q - Q-Table

q[state, action] = q[state, action] + learning_rate * ( reward + discount_factor * max( q[new_state,:] ) - q[state, action] )

if agent is in state 14 (stand on 14th tile of a grid) and want to go right (action 2):

q[14, 2] = 0        +     0,01      * ( 1      +     0,9       *      0                                     -      0)
           |               |            |             |               |                                            |
        initialy        learning    assuming        discount        in our q-table                             initialy for q-table
       for q-table        rate      theres goal      factor         tile 15 holds goal
                                    on tile 15                      so all actions in q-table have
                                                                    0 values becouse no action is required


q[14, 2] = 0,01

q[13, 2] = 0 + 0,1 * ( 0 + 0,9 * 0,01 - 0)
                       |          |
                    frozen     previously valcualted in q-table
                     tile      others are 0 so this is max for now

q[13, 2] = 0,009

## Deep Q-Network

Feed forward neural network that have 16 nodes in input layer for states (1 if theres agent in soem state and other are 0s) and 4 output nodes, one for each agent action

### Deep Q-Leaning formula

q[state, action] = reward if new_state is terminal else reward + discount_factor * max(q[new_state,:])

in practise we need 2 neural networks:

- policy network - the one we do training on
- target newtork - the one that makes use of q-leaning formula

Steps of training:
- 1. create policy network
- 2. copy policy network into target network
- 3. agent navigates through network
* lets say hes in state 14 and going into state 15 (action 2)
- 4. encode state (14 for example) so 0000000000000010 and send it through policy network
- 5. send input through target network
- 6. calculate state (14 for example) so q[14, 2] = 1 becouse 15 is terminal state (agent found the goal)
- 7. set the target, we set result of target network output on action to to calculated state
- 8. use target q values to train policy network
- 9. repeat 3 - 8 by episodes number
- 10. sync policy network with target network, make them identical
- repeat 9 again and 10 until done

## Experience replay

to effectivly train nn we need to randomize the training data that we send into nn

so we need to memorize (state, action, new_state, reward, terminated) when training into deque
and then use random samples to train nn