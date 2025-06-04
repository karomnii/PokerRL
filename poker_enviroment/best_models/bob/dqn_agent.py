import torch
import torch.nn as nn
import torch.nn.functional as F
import random
from typing import Optional, Tuple
from game.poker_game import Action
from agents.iagent import IAgent
import datetime
import os


def encode_card(card: int) -> torch.Tensor:
    """
    Encodes a single card (0..51) into a 17-dim one-hot vector:
      - 13 for rank (0..12)
      - 4  for suit (0..3)
    """
    # card // 4 => rank in [0..12]
    # card % 4  => suit in [0..3]
    rank = card // 4
    suit = card % 4

    vector = torch.zeros(17)
    vector[rank] = 1.0
    vector[13 + suit] = 1.0
    return vector


class DQN(nn.Module):
    def __init__(
        self,
        input_dim=119,
        hidden_layers=[512, 256],
        output_dim=3
    ):
        """
        A flexible MLP for Q-value approximation.
        - input_dim: size of input features
        - hidden_layers: list indicating the number of neurons in each hidden layer
        - output_dim: number of actions (Q-value outputs)
        """
        super(DQN, self).__init__()

        # Build a sequence of [Linear -> ReLU] for each hidden layer
        layers = []
        prev_dim = input_dim
        for layer_size in hidden_layers:
            layers.append(nn.Linear(prev_dim, layer_size))
            layers.append(nn.ReLU())
            prev_dim = layer_size

        # Final layer: from last hidden layer to output_dim
        layers.append(nn.Linear(prev_dim, output_dim))

        # Wrap it all in an nn.Sequential so forward() can just pass through
        self.model = nn.Sequential(*layers)

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.model(x)


class DQNAgent(IAgent):
    def __init__(self,
                 player_id=0,
                 gamma=0.99,
                 epsilon_start=1.0,
                 epsilon_end=0.05,
                 epsilon_decay=0.9999):
        super().__init__()
        self.player_id = player_id

        # Main and target networks
        self.model = DQN()
        self.target_model = DQN()
        self.target_model.load_state_dict(self.model.state_dict())

        # Optimizer
        self.optimizer = torch.optim.Adam(self.model.parameters(), lr=3e-4)

        # Hyperparameters
        self.gamma = gamma
        self.epsilon = epsilon_start
        self.epsilon_end = epsilon_end
        self.epsilon_decay = epsilon_decay

        # Replay buffer and related
        self.replay_buffer = []
        self.batch_size = 64

        # For tracking training
        self.loss_history = []

    def _preprocess_observation(self, observation) -> torch.Tensor:
        """
        Convert the observation (dict with 'hand' and 'community_cards') to a
        119-dim vector: 7 cards each encoded with 17 dims (13 rank + 4 suit).

        If the community has fewer than 5 cards, the remainder are zero-padded.
        """
        hand = observation['hand']            # up to 2 cards
        community = observation['community_cards']  # up to 5 cards
        all_cards = hand + community

        # If there are fewer than 7 total cards, pad with zeros
        # If there are more than 7 for some reason (extreme game variation),
        # we'll just take the first 7. (Typically not needed for Texas Hold'em)
        max_cards = 7

        card_vectors = []
        for i in range(max_cards):
            if i < len(all_cards):
                card_vectors.append(encode_card(all_cards[i]))
            else:
                card_vectors.append(torch.zeros(17))

        # Flatten into a single 119-dim vector
        return torch.cat(card_vectors)

    def act(self, observation: dict) -> Tuple[Action, Optional[int]]:
        """
        Choose an action using an ε-greedy policy.
        Returns: (Action, amount)
        """
        state = self._preprocess_observation(observation)

        # Epsilon-greedy action selection
        if random.random() < self.epsilon:
            action = random.choice([Action.RAISE, Action.CALL, Action.FOLD])
        else:
            with torch.no_grad():
                q_values = self.model(state)
                action_idx = torch.argmax(q_values).item()
                action = [Action.RAISE, Action.CALL, Action.FOLD][action_idx]

        amount = None
        if action == Action.RAISE:
            call_amount = observation['call_amount']
            min_raise = call_amount + 1
            max_raise = observation['chips']

            if max_raise >= min_raise:
                amount = random.randint(min_raise, max_raise)
            else:
                # If we cannot legally raise, decide to CALL or FOLD
                if observation['chips'] >= call_amount:
                    action = Action.CALL
                else:
                    action = Action.FOLD

        return action, amount

    def _action_to_index(self, action: Action) -> int:
        return [Action.RAISE, Action.CALL, Action.FOLD].index(action)

    def update_model(self) -> Optional[float]:
        """
        Sample a mini-batch of experiences from the replay buffer, compute the
        loss, and update the network. Also decays epsilon.

        Returns: The loss value (float) if an update happened, otherwise None.
        """

        if len(self.replay_buffer) < self.batch_size:
            return None

        batch = random.sample(self.replay_buffer, self.batch_size)
        states, actions, rewards, next_states, dones = zip(*batch)

        states = torch.stack(states)
        actions = torch.tensor([self._action_to_index(a) for a in actions], dtype=torch.long)
        rewards = torch.tensor(rewards, dtype=torch.float32)
        next_states = torch.stack([
            s if s is not None else torch.zeros_like(states[0])
            for s in next_states
        ])
        dones = torch.tensor(dones, dtype=torch.float32)

        # Current Q for chosen actions
        current_q = self.model(states).gather(1, actions.unsqueeze(1)).squeeze(1)

        # Next Q from target network
        next_q = self.target_model(next_states).max(1)[0].detach()

        # Target values
        target_q = rewards + (1 - dones) * self.gamma * next_q

        loss = F.mse_loss(current_q, target_q)
        self.loss_history.append(loss.item())

        self.optimizer.zero_grad()
        loss.backward()
        torch.nn.utils.clip_grad_norm_(self.model.parameters(), max_norm=1.0)
        self.optimizer.step()

        # Epsilon decay
        self.epsilon = max(self.epsilon_end, self.epsilon * self.epsilon_decay)

        return loss.item()

    def update_target_network(self):
        """
        Update target model by copying weights from the main model.
        """
        self.target_model.load_state_dict(self.model.state_dict())

    def save_model(self, path='dqn_model.pth'):
        """
        Saves the current model weights to disk. Creates a timestamped folder
        under ./models/ by default.
        """
        os.makedirs('./models', exist_ok=True)
        now = datetime.datetime.now()
        dt = now.strftime("%Y-%m-%d_%H-%M-%S") + f"-{int(now.microsecond / 1000):03d}"
        folder = f'./models/{dt}/'

        try:
            os.makedirs(folder, exist_ok=True)
            filepath = os.path.join(folder, path)
            torch.save(self.model.state_dict(), filepath)
            print(f"Model saved to {filepath}")
        except OSError as e:
            print(f"Error saving model to {folder}: {e}")
            # Fall back to saving directly as path
            torch.save(self.model.state_dict(), path)
            print(f"Model saved to {path}")
