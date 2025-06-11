import json
from typing import Dict, Optional
import matplotlib.colors as mcolors

import numpy as np
from matplotlib import pyplot as plt


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

    def display_chart(self, filepath: str) -> None:
        with open(filepath, 'r') as f:
            hand_range = json.load(f)

        ranks = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']
        grid = np.empty((13, 13), dtype=object)

        for i, r2 in enumerate(ranks):  # rows
            for j, r1 in enumerate(ranks):  # columns
                if j == i:
                    key = r1 + r2
                elif j < i:
                    key = r1 + r2 + 'o'
                else:
                    key = r2 + r1 + 's'

                action = hand_range.get(key, '')
                grid[i, j] = action

        action_to_color = {'raise': 'green', 'fold': 'red', '': 'white'}

        # colors is a numpy array of color names (strings)
        colors = np.vectorize(lambda x: action_to_color.get(x, 'gray'))(grid)
        colors_rgb = np.array([mcolors.to_rgb(c) for c in colors.flatten()]).reshape(colors.shape + (3,))

        fig, ax = plt.subplots(figsize=(10, 10))
        ax.imshow(colors_rgb, aspect='equal')

        # ... rest unchanged

        for i in range(13):
            for j in range(13):
                text = grid[i, j]
                ax.text(j, i, text, ha='center', va='center', fontsize=8, color='black')

        ax.set_xticks(np.arange(13))
        ax.set_yticks(np.arange(13))
        ax.set_xticklabels(ranks)
        ax.set_yticklabels(ranks)
        ax.set_xlabel("Second Card")
        ax.set_ylabel("First Card")
        ax.set_title("Preflop Strategy Chart")

        ax.set_xticks(np.arange(-0.5, 13, 1), minor=True)
        ax.set_yticks(np.arange(-0.5, 13, 1), minor=True)
        ax.grid(which='minor', color='black', linestyle='-', linewidth=0.5)
        ax.tick_params(which='minor', bottom=False, left=False)

        plt.tight_layout()
        plt.show()

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

