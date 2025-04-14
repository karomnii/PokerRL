from typing import List
from .card import Card

class Player:
    def __init__(self, player_id: int, chips: int = 100) -> None:
        self.player_id = player_id
        self.chips = chips
        self.hand: List[Card] = []
        self.best_hand = {"hand":[],"rank":0}
        self.current_bet: int = 0
        self.total_bet: int = 0 
        self.folded: bool = False
        self.busted: bool = False
        self.all_in: bool = False  

    def reset(self) -> None:
        self.hand = []
        self.current_bet = 0
        self.total_bet = 0
        self.folded = False
        self.all_in = False
        if self.chips==0:
            self.busted = True

    def prepare_for_new_game(self) -> None:
        self.reset()
        self.chips=100
        self.busted=False