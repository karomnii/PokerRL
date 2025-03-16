import gymnasium as gym
from torch import nn
import torch.nn.functional as F
from collections import deque
import random
import torch
import numpy as np
import matplotlib.pyplot as plt
import os

class DQN(nn.Module):
    def __init__(self, in_states, h1_nodes, out_actions):
        super().__init__()

        #Define network layers
        self.fc1 = nn.Linear(in_states, h1_nodes)
        self.out = nn.Linear(h1_nodes, out_actions)

    def forward(self, x):
        x = F.relu(self.fc1(x))
        x = self.out(x)
        return x
    
class ReplayMemory():
    def __init__(self, maxlen):
        self.memory = deque([], maxlen=maxlen)
    
    def append(self, transition):
        # transition is tuple of (state, action, new_state, reward, terminated)
        self.memory.append(transition)

    def sample(self, sample_size):
        return random.sample(self.memory, sample_size)
    
    def __len__(self):
        return len(self.memory)
    
class FrozenLakeDQL():
    # Hyperparameters (adjustable)
    learning_rate_a = 0.001         # learning rate (aplha)
    discount_factor_g = 0.9         # discount rate (gamma)
    network_sync_rate = 10          # number of steps the agent takes before syncing the policy and target network
    replay_memory_size = 1000       # size of replay memory
    mini_batch_size = 32            # size of the training data set sampled from the replay memory

    # Neural network
    loss_fn = nn.MSELoss()          # loss function, this can be changed - (from google) Mean Squared Error (MSE) loss is a common loss function used in machine learning that measures the average of the squares of the errors between predicted values and actual values. It quantifies how well a model's predictions match the true outcomes, with lower values indicating better performance.
    optimizer = None                # nn optimizer, to be initialized later

    ACTIONS = ['L', 'D', 'R', 'U']  # for debuging actions from 0,1,2,3 -> L D R U


    def train(self, episodes, render=False, is_slippery=False):
        # Create frozen lake instance
        env = gym.make('FrozenLake-v1', map_name="4x4", is_slippery=is_slippery, render_mode='human' if render else None)
        num_states = env.observation_space.n
        num_actions = env.action_space.n

        epsilon = 1 # 100% random actions for start
        memory = ReplayMemory(self.replay_memory_size)

        # Create networks
        policy_dqn = DQN(in_states=num_states, h1_nodes=num_states, out_actions=num_actions)
        target_dqn = DQN(in_states=num_states, h1_nodes=num_states, out_actions=num_actions)

        target_dqn.load_state_dict(policy_dqn.state_dict())

        print('policy before train:')
        self.print_dqn(policy_dqn)

        # we add optimizer now when we have nn initialized, adam can be changed to sth different but its in tutorial :)
        self.optimizer = torch.optim.Adam(policy_dqn.parameters(), lr=self.learning_rate_a)

        # keep track of reward throughout episodes
        reward_per_episode = np.zeros(episodes)

        # keep track of epsilon decay
        epsilon_history = []

        # for syncing policy
        step_count = 0

        for i in range(episodes):
            state = env.reset()[0]      # initialy state 0
            terminated = False          # True when in hole or goal
            truncated = False           # True when taken above 200 actions (upper bound of some kind lets say)
            
            while(not terminated and not truncated):

                # select action based on epsilon greedy alg
                if random.random() < epsilon:
                    action = env.action_space.sample() # random action
                else:
                    with torch.no_grad(): # turns off torch gradient operations inside the block
                        action = policy_dqn(self.state_to_dqn_input(state, num_states)).argmax().item() # best move from nn

                # execute action
                new_state, reward, terminated, truncated, _ = env.step(action)

                # save experience
                memory.append((state, action, new_state, reward, terminated))

                # move to the next state
                state = new_state

                step_count += 1

            if reward == 1: # if agent managed to reach goal in episode
                reward_per_episode[i] = 1

            # if we have enough experience and we have at least one reward
            if len(memory) > self.mini_batch_size and np.sum(reward_per_episode) > 0:
                mini_batch = memory.sample(self.mini_batch_size)
                self.optimize(mini_batch, policy_dqn, target_dqn)

                # epsilon decay over time
                epsilon = max(epsilon - 1 / episodes, 0)
                epsilon_history.append(epsilon)

                # syncing networks | step 10.
                if step_count > self.network_sync_rate:
                    target_dqn.load_state_dict(policy_dqn.state_dict())
                    step_count = 0
        
        # after episodes

        env.close()

        torch.save(policy_dqn.state_dict(), 'frozen_lake_dqn.pt')

        # visualizations
        plt.figure(1)

        sum_rewards = np.zeros(episodes)
        for x in range(episodes):
            sum_rewards[x] = np.sum(reward_per_episode[max(0, x-100):(x + 1)])
        plt.subplot(121)
        plt.plot(sum_rewards)

        plt.subplot(122)
        plt.plot(epsilon_history)

        plt.savefig('frozen_lake_dqn.png')

    def state_to_dqn_input(self, state:int, num_states:int)-> torch.Tensor:
        input_tensor = torch.zeros(num_states)
        input_tensor[state] = 1
        return input_tensor

    def optimize(self, mini_batch, policy_dqn: DQN, target_dqn: DQN):

        num_states = policy_dqn.fc1.in_features

        current_q_list = []
        target_q_list = []

        # playing the experience
        for state, action, new_state, reward, terminated in mini_batch:
            
            # step 6.
            if terminated:
                # when terminated targer q value should be set to the reward
                target = torch.FloatTensor([reward])
            else:
                # calculate target q value
                with torch.no_grad():
                    target = torch.FloatTensor(
                        reward + self.discount_factor_g * target_dqn(self.state_to_dqn_input(new_state, num_states)).max()
                    )
            
            # calculate from policy nn | step 4.
            current_q = policy_dqn(self.state_to_dqn_input(state, num_states))
            current_q_list.append(current_q)

            # pass the same to target nn | step 5.
            target_q = target_dqn(self.state_to_dqn_input(state, num_states))

            # adjust the specific action to the target that was just calculated | step 7.
            target_q[action] = target
            target_q_list.append(target_q)
        
        # compute loss for whole minibatch | step 8.
        loss = self.loss_fn(torch.stack(current_q_list), torch.stack(target_q_list))

        self.optimizer.zero_grad()
        loss.backward()
        self.optimizer.step()

    def test(self, episodes, is_slippery=False):
        env = gym.make('FrozenLake-v1', map_name="4x4", is_slippery=is_slippery, render_mode='human')
        num_states = env.observation_space.n
        num_actions = env.action_space.n

        policy_dqn = DQN(in_states=num_states, h1_nodes=num_states, out_actions=num_actions)
        policy_dqn.load_state_dict(torch.load("frozen_lake_dqn.pt"))
        policy_dqn.eval()

        print('policy trained:')
        self.print_dqn(policy_dqn)

        for i in range(episodes):
            state = env.reset()[0]
            terminated = False
            truncated = False

            while(not terminated and not truncated):
                with torch.no_grad():
                    action = policy_dqn(self.state_to_dqn_input(state, num_states)).argmax().item()

                state, reward, terminated, truncated, _ = env.step(action)
        env.close()

    def print_dqn(self, dqn):
        # Get number of input nodes
        num_states = dqn.fc1.in_features

        # Loop each state and print policy to console
        for s in range(num_states):
            #  Format q values for printing
            q_values = ''
            for q in dqn(self.state_to_dqn_input(s, num_states)).tolist():
                q_values += "{:+.2f}".format(q)+' '  # Concatenate q values, format to 2 decimals
            q_values=q_values.rstrip()              # Remove space at the end

            # Map the best action to L D R U
            best_action = self.ACTIONS[dqn(self.state_to_dqn_input(s, num_states)).argmax()]

            # Print policy in the format of: state, action, q values
            # The printed layout matches the FrozenLake map.
            print(f'{s:02},{best_action},[{q_values}]', end=' ')         
            if (s+1)%4==0:
                print() # Print a newline every 4 states
                
if __name__ == '__main__':
    # without this my machine goes brr
    os.environ["KMP_DUPLICATE_LIB_OK"] = "TRUE"
    os.environ["QT_AUTO_SCREEN_SCALE_FACTOR"] = "1"
    os.environ["QT_SCREEN_SCALE_FACTORS"] = "1"
    os.environ["QT_SCALE_FACTOR"] = "1"

    frozen_lake = FrozenLakeDQL()
    is_slippery = False
    frozen_lake.train(1000, is_slippery=is_slippery)
    frozen_lake.test(4, is_slippery=is_slippery)