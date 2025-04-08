import numpy as np
import torch

class ObservationProcessor:
    def __init__(self):
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.deck_size = 52
        
    def process(self, observation):
        # Extract card features
        hand = observation['hand']
        community_cards = observation['community_cards']
        
        # Create a single vector for all cards
        card_vector = [0] * self.deck_size
        
        # Mark cards in hand and community cards as present
        for card in hand + community_cards:
            if card != -1:  # Ignore placeholder cards
                card_vector[card] = 1
        
        # Convert to tensor
        tensor = torch.FloatTensor(card_vector).to(self.device)
        return tensor
