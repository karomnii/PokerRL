import json
from typing import Dict, Optional


class PreflopChartEvaluator:

    def __init__(self, chart: Optional[Dict[str, str]] = None):
        """
        Initialize the evaluator with an optional chart dictionary.
        Chart keys are strings like "AKs", "JJ", "T9o", etc.
        Chart values are actions like "raise", "fold", etc.
        """
        self.chart = chart or {}
        self.ranks_str = "23456789TJQKA"

    def load_chart_from_file(self, filepath: str) -> None:
        """Load a preflop chart from a JSON file."""
        with open(filepath, "r") as f:
            self.chart = json.load(f)

    def evaluate(self, card1: int, card2: int) -> str | None:
        """
        Evaluate action for two cards encoded as integers [0..51].

        Returns the action ("raise", "fold", etc.) or None if not found.
        """

        # Extract rank and suit from cards
        rank1 = card1 % 13
        suit1 = card1 // 13
        rank2 = card2 % 13
        suit2 = card2 // 13

        # Get rank characters
        r1_char = self.ranks_str[rank1]
        r2_char = self.ranks_str[rank2]

        # Determine if pair
        if rank1 == rank2:
            key = r1_char * 2
        else:
            # Order ranks descending (high card first)
            if rank1 > rank2:
                high, low = r1_char, r2_char
            else:
                high, low = r2_char, r1_char

            # Determine suited or offsuit
            suited = (suit1 == suit2)
            suited_char = "s" if suited else "o"

            key = f"{high}{low}{suited_char}"
        return self.chart.get(key)

