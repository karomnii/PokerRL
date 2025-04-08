import random
import numpy as np
from collections import namedtuple, deque
import torch
from game.poker_game import Action

Experience = namedtuple("Experience", ["state", "action", "reward"])

class ReplayBuffer:
    def __init__(self, capacity):
        self.memory = deque(maxlen=capacity)
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.all_actions = [Action.FOLD, Action.CALL, Action.RAISE]
        
    def add(self, state, action, reward):
        experience = Experience(state, action, reward)
        self.memory.append(experience)
        
    def sample(self, batch_size):
        experiences = random.sample(self.memory, k=batch_size)

        actions = torch.tensor([self.all_actions.index(e.action) for e in experiences], dtype=torch.long).to(self.device)
        
        states = torch.stack([e.state for e in experiences]).to(self.device)
        
        rewards = torch.tensor([e.reward for e in experiences], dtype=torch.float).to(self.device)
        
        return states, actions, rewards
    
    def __len__(self):
        return len(self.memory)
