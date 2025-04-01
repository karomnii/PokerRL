import torch
import torch.nn as nn
import torch.nn.functional as F
import random
from typing import Optional, Tuple
from game.poker_game import Action
from agents.iagent import IAgent
import datetime
import os


# Główna architektura sieci neuronowej DQN (Deep Q-Network)
class DQN(nn.Module):
    def __init__(self, input_dim=104, output_dim=3):
        super(DQN, self).__init__()
        # Warstwa wejściowa o wymiarze wejścia równym liczbie kart (52) dla ręki i kart wspólnych (łącznie 104)
        self.fc1 = nn.Linear(input_dim, 128)
        self.fc2 = nn.Linear(128, 64)
        # Warstwa wyjściowa - odpowiada liczbie możliwych akcji: RAISE, CALL, FOLD
        self.fc3 = nn.Linear(64, output_dim)
        
    def forward(self, x):
        # Funkcje aktywacji ReLU pomiędzy warstwami w celu nieliniowości
        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        return self.fc3(x)  # Surowe wartości Q (logity) dla każdej akcji

# Agent DQN stosujący uczenie przez wzmocnienie w środowisku pokerowym
class DQNAgent(IAgent):
    def __init__(self, player_id=0, gamma=0.99, epsilon_start=1.0, epsilon_end=0.01, epsilon_decay=0.995):
        super().__init__()
        self.player_id = player_id
        self.model = DQN()  # Główna sieć Q
        self.target_model = DQN()  # Sieć celu - stabilizuje uczenie
        self.target_model.load_state_dict(self.model.state_dict())  # Początkowe skopiowanie wag
        self.optimizer = torch.optim.Adam(self.model.parameters(), lr=0.001)  # Optymalizator Adam
        self.gamma = gamma  # Współczynnik dyskontowy - znaczenie przyszłych nagród
        self.epsilon = epsilon_start  # Początkowe prawdopodobieństwo eksploracji
        self.epsilon_end = epsilon_end  # Minimalna eksploracja
        self.epsilon_decay = epsilon_decay  # Tempo redukcji epsilon
        self.replay_buffer = []  # Bufor doświadczeń dla uczenia
        self.batch_size = 64  # Rozmiar mini-batcha
        self.loss_history = [] # Dane funkcji straty

    # Przekształca obserwację z gry na wektor wejściowy dla sieci (one-hot encoding kart)
    def _preprocess_observation(self, observation):
        hand = observation['hand']
        community = observation['community_cards']
        
        hand_vector = torch.zeros(52)
        for card in hand:
            if 0 <= card < 52:
                hand_vector[card] = 1.0  # Kodowanie jednej karty jako 1 w wektorze
        
        community_vector = torch.zeros(52)
        for card in community:
            if 0 <= card < 52:
                community_vector[card] = 1.0
        
        return torch.cat([hand_vector, community_vector])  # Wektor 104-elementowy

    # Wybór akcji na podstawie polityki ε-greedy
    def act(self, observation: dict) -> Tuple[Action, Optional[int]]:
        state = self._preprocess_observation(observation)
        
        if random.random() < self.epsilon:
            # Eksploracja: losowy wybór akcji
            action = random.choice([Action.RAISE, Action.CALL, Action.FOLD])
        else:
            # Eksploatacja: wybór najlepszej akcji wg Q sieci
            with torch.no_grad():
                q_values = self.model(state)
                action_idx = torch.argmax(q_values).item()
                action = [Action.RAISE, Action.CALL, Action.FOLD][action_idx]
        
        # Obsługa wysokości podbicia jeśli wybrano akcję RAISE
        amount = None
        if action == Action.RAISE:
            call_amount = observation['call_amount']
            min_raise = call_amount + 1
            max_raise = observation['chips']
            
            if max_raise >= min_raise:
                amount = random.randint(min_raise, max_raise)
            else:
                # Jeśli nie można podbić, podejmij CALL lub FOLD w zależności od dostępnych żetonów
                if observation['chips'] >= call_amount:
                    action = Action.CALL
                else:
                    action = Action.FOLD
        
        return action, amount

    # Mapuje akcje (enum) na indeksy do sieci neuronowej
    def _action_to_index(self, action: Action) -> int:
        return [Action.RAISE, Action.CALL, Action.FOLD].index(action)

    # Uaktualnia model DQN na podstawie mini-batcha próbek z replay buffer
    def update_model(self) -> int:
        if len(self.replay_buffer) < self.batch_size:
            return  # Nie aktualizuj jeśli zbyt mało danych
        
        batch = random.sample(self.replay_buffer, self.batch_size)
        states, actions, rewards, next_states, dones = zip(*batch)
        
        states = torch.stack(states)
        actions = torch.tensor([self._action_to_index(a) for a in actions], dtype=torch.long)
        rewards = torch.tensor(rewards, dtype=torch.float32)
        next_states = torch.stack([s if s is not None else torch.zeros_like(states[0]) for s in next_states])
        dones = torch.tensor(dones, dtype=torch.float32)
        
        # Obliczenie obecnych Q-wartości dla wybranych akcji
        current_q = self.model(states).gather(1, actions.unsqueeze(1))
        # Obliczenie maksymalnych przyszłych Q-wartości
        next_q = self.target_model(next_states).max(1)[0].detach()
        # Obliczenie docelowych wartości Q
        target_q = rewards + (1 - dones) * self.gamma * next_q
        
        # Funkcja straty: błąd średniokwadratowy pomiędzy aktualnymi a docelowymi Q
        loss = F.mse_loss(current_q.squeeze(), target_q)
        self.loss_history.append(loss.item())
        
        self.optimizer.zero_grad()
        loss.backward()
        self.optimizer.step()
        
        # Aktualizacja współczynnika eksploracji
        self.epsilon = max(self.epsilon_end, self.epsilon * self.epsilon_decay)
        return loss.item()

    # Aktualizuje sieć celu - okresowe kopiowanie wag z głównej sieci
    def update_target_network(self):
        self.target_model.load_state_dict(self.model.state_dict())

    # Zapisuje model na dysku z dokładnością do milisekundy
    def save_model(self, path='dqn_model.pth'):
        os.makedirs('./models', exist_ok=True)
        
        # Generowanie unikalnej nazwy katalogu z timestampem
        now = datetime.datetime.now()
        dt = now.strftime("%Y-%m-%d_%H-%M-%S") + f"-{int(now.microsecond / 1000):03d}"
        folder = f'./models/{dt}/'
        
        try:
            os.makedirs(folder)
            torch.save(self.model.state_dict(), os.path.join(folder, path))
            print(f"Model saved to {os.path.join(folder, path)}")
        except OSError as e:
            print(f"Error saving model: {e}")
            torch.save(self.model.state_dict(), path)
            print(f"Model saved to {path}")
