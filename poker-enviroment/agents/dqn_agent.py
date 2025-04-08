# agents/dqn_agent.py
import random
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
import os

from game.poker_game import Action
from .iagent import IAgent
from .dqn_model import PokerDQN
from utils.observation_processor import ObservationProcessor
from utils.replay_buffer import ReplayBuffer

class DQNAgent(IAgent):
    def __init__(self, state_dim, action_dim=3, learning_rate=0.001, gamma=0.99, 
                 epsilon_start=1.0, epsilon_end=0.1, epsilon_decay=0.99999,
                 target_update=10, hidden_dim=128):
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.q_network = PokerDQN(state_dim, hidden_dim=hidden_dim, output_dim=action_dim).to(self.device)
        self.target_network = PokerDQN(state_dim, hidden_dim=hidden_dim, output_dim=action_dim).to(self.device)
        self.target_network.load_state_dict(self.q_network.state_dict())
        
        self.optimizer = optim.Adam(self.q_network.parameters(), lr=learning_rate)
        self.loss_fn = nn.MSELoss()
        self.memory = ReplayBuffer(capacity=10000)
        self.processor = ObservationProcessor()
        
        # Hyperparameters
        self.gamma = gamma
        self.epsilon = epsilon_start
        self.epsilon_end = epsilon_end
        self.epsilon_decay = epsilon_decay
        self.target_update = target_update
        self.update_counter = 0
        
        # Action mapping
        self.actions = [Action.FOLD, Action.CALL, Action.RAISE]

        self.folds = 0
        self.calls = 0
        self.raises = 0
        
    def act(self, observation):
        # Process observation
        state = self.processor.process(observation)
        
        # Epsilon-greedy action selection
        if random.random() < self.epsilon:
            action_idx = random.randrange(len(self.actions))
            action = self.actions[action_idx]
        else:
            with torch.no_grad():
                state = state.unsqueeze(0)  # Add batch dimension
                q_values = self.q_network(state)
                action_idx = q_values.argmax().item()
                action = self.actions[action_idx]
        
        # Determine raise amount if action is RAISE
        amount = None
        if action == Action.RAISE:
            call_amount = observation.get("call_amount", 0)
            min_raise = call_amount * 2 if call_amount > 0 else 20
            if min_raise > observation.get("chips", 0):
                action = Action.CALL
            elif random.random() < 0.5:
                # Sometimes raise by a percentage
                amount = min_raise
            else:
                # Sometimes raise by a multiple
                amount = min_raise * random.randint(1, 5)

        
        # Update action counts
        if action == Action.FOLD:
            self.folds += 1
        elif action == Action.CALL:
            self.calls += 1
        elif action == Action.RAISE:
            self.raises += 1

        return action, amount
    
    def remember(self, state, action, reward, next_state, done):
        # Process states
        state_tensor = self.processor.process(state)
        next_state_tensor = self.processor.process(next_state)
        
        # Add to replay buffer
        self.memory.add(state_tensor, action, reward, next_state_tensor, done)

    def replay(self, batch_size):
        if len(self.memory) < batch_size:
            return
        
        # Sample batch from replay buffer
        states, actions, rewards = self.memory.sample(batch_size)

        # print(f"Batch size: {batch_size}, Replay buffer size: {len(self.memory)}")
        # print(f"States shape: {states.shape}, Actions shape: {actions.shape}, Rewards shape: {rewards.shape}")
        
        # Compute Q values
        q_values = self.q_network(states).gather(1, actions.unsqueeze(1)).squeeze(1)
        # print(f"Q values shape: {q_values.shape}")
        
        # Double DQN: use online network to select actions and target network to evaluate them
        with torch.no_grad():
            next_q_values = self.target_network(states).max(1)[0]
            # print(f"Next Q values shape: {next_q_values.shape}")
            target_q_values = rewards + (self.gamma * next_q_values)
        
        # print(f"Target Q values shape: {target_q_values.shape}")
        # Compute loss and update
        loss = self.loss_fn(q_values, target_q_values)
        
        self.optimizer.zero_grad()
        loss.backward()
        
        # Gradient clipping to prevent exploding gradients
        torch.nn.utils.clip_grad_norm_(self.q_network.parameters(), 1.0)
        
        self.optimizer.step()
        
        # Update target network periodically
        self.update_counter += 1
        if self.update_counter % self.target_update == 0:
            self.target_network.load_state_dict(self.q_network.state_dict())
        
        # Decay epsilon
        self.epsilon = max(self.epsilon_end, self.epsilon * self.epsilon_decay)
        
        return loss.item()

    
    def save(self, path):
        torch.save({
            'q_network': self.q_network.state_dict(),
            'target_network': self.target_network.state_dict(),
            'optimizer': self.optimizer.state_dict(),
            'epsilon': self.epsilon
        }, path)
    
    def load(self, path):
        if os.path.exists(path):
            checkpoint = torch.load(path)
            self.q_network.load_state_dict(checkpoint['q_network'])
            self.target_network.load_state_dict(checkpoint['target_network'])
            self.optimizer.load_state_dict(checkpoint['optimizer'])
            self.epsilon = checkpoint['epsilon']
