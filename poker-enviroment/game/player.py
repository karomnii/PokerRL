from typing import List
from .card import Card

class Player:
    def __init__(self, player_id: int, chips: int = 1000) -> None:
        self.player_id = player_id
        self.chips = chips
        self.hand: List[Card] = []
        self.current_bet: int = 0
        self.total_bet: int = 0 
        self.folded: bool = False
        self.all_in: bool = False  

    def reset(self) -> None:
        self.hand = []
        self.current_bet = 0
        self.total_bet = 0
        self.folded = False
        self.all_in = False
