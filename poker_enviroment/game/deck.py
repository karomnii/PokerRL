import random
from typing import List
from .card import Card, Suit, Rank

class Deck:
    def __init__(self) -> None:
        self.cards: List[Card] = [Card(s, r) for s in Suit for r in Rank]
        self.shuffle()

    def shuffle(self) -> None:
        random.shuffle(self.cards)

    def draw(self, n: int = 1) -> List[Card]:
        drawn: List[Card] = self.cards[:n]
        self.cards = self.cards[n:]
        return drawn
