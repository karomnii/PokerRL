from enum import Enum

class Suit(Enum):
    HEARTS =    "♡"     # ♥️
    DIAMONDS =  "♢"     # ♦️
    CLUBS =     "♧"     # ♣️
    SPADES =    "♤"     # ♠️

class Rank(Enum):
    TWO =   "2"
    THREE = "3"
    FOUR =  "4"
    FIVE =  "5"
    SIX =   "6"
    SEVEN = "7"
    EIGHT = "8"
    NINE =  "9"
    TEN =   "T"
    JACK =  "J"
    QUEEN = "Q"
    KING =  "K"
    ACE =   "A"

class Card:
    def __init__(self, suit: Suit, rank: Rank) -> None:
        self.suit: Suit = suit
        self.rank: Rank = rank

    def __repr__(self) -> str:
        return f"{self.rank.value}{self.suit.value}"
