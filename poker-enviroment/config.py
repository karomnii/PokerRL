class Config:
    # DQN Agent parameters
    LEARNING_RATE = 0.001
    GAMMA = 0.99  # Discount factor
    EPSILON_START = 1.0
    EPSILON_END = 0.01
    EPSILON_DECAY = 0.995
    HIDDEN_DIM = 128
    TARGET_UPDATE = 10
    
    # Training parameters
    BATCH_SIZE = 32
    BUFFER_SIZE = 10000
    EPISODES = 1000
    SAVE_FREQUENCY = 100
    
    # Environment parameters
    STARTING_CHIPS = 1000
    SMALL_BLIND = 10
    BIG_BLIND = 20
    
    # Evaluation parameters
    EVAL_GAMES = 2000
    EVAL_EPSILON = 0.05
