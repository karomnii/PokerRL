using Microsoft.ML.OnnxRuntime.Tensors;
using Microsoft.ML.OnnxRuntime;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Helpers;
using TexasHoldemPoker.API.Repositories;

namespace TexasHoldemPoker.API.Services
{
    public class AiAgentService : IAiAgentService, IDisposable
    {
        private readonly Dictionary<string, InferenceSession> _sessions;
        private readonly ILogger<AiAgentService> _logger;
        private bool _disposed = false;

        private readonly IGameRepository gameRepository;
        private readonly IGamePlayerRepository gamePlayerRepository;
        private readonly ICardRepository cardRepository;
        private readonly IMoveRepository moveRepository;
        private readonly IChipTransactionRepository chipTransactionRepository;
        private readonly IGameRoundRepository gameRoundRepository;
        private readonly IGameRoundWinnerRepository gameRoundWinnerRepository;
        private readonly IModelRepository modelRepository;
        private readonly Random random = new Random();

        public AiAgentService(ILogger<AiAgentService> logger)
        {
            _logger = logger;
            _sessions = new Dictionary<string, InferenceSession>();

            LoadAllModels();
        }

        private void LoadAllModels()
        {
            var agentsDirectory = Path.Combine(Directory.GetCurrentDirectory(), "agents");

            if (!Directory.Exists(agentsDirectory))
            {
                throw new DirectoryNotFoundException($"Agents directory not found at: {agentsDirectory}");
            }

            var allModels = modelRepository.GetAllAsync().GetAwaiter().GetResult();

            var modelConfigs = new Dictionary<string, string>();

            foreach (var model in allModels)
            {
                modelConfigs.Add(model.ModelId.ToString(),model.Path ?? "");
            }

            var sessionOptions = new Microsoft.ML.OnnxRuntime.SessionOptions();
            sessionOptions.LogSeverityLevel = OrtLoggingLevel.ORT_LOGGING_LEVEL_INFO;

            foreach (var config in modelConfigs)
            {
                var modelPath = Path.Combine(agentsDirectory, config.Value);

                if (File.Exists(modelPath))
                {
                    try
                    {
                        _sessions[config.Key] = new InferenceSession(modelPath, sessionOptions);
                        _logger.LogInformation($"ONNX model '{config.Key}' loaded successfully from: {modelPath}");
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, $"Failed to load model '{config.Key}' from: {modelPath}");
                    }
                }
                else
                {
                    _logger.LogWarning($"Model file not found for '{config.Key}' at: {modelPath}");
                }
            }

            if (!_sessions.Any())
            {
                throw new InvalidOperationException("No ONNX models could be loaded");
            }
        }

        public async Task<float[]> PredictActionAsync(float[] features, string modelId = "1")
        {
            if (!_sessions.ContainsKey(modelId))
            {
                _logger.LogWarning($"Model '{modelId}' not found, using default model");
                modelId = "1";
            }

            if (!_sessions.ContainsKey(modelId))
            {
                throw new InvalidOperationException($"No model available with ID: {modelId}");
            }

            try
            {
                var session = _sessions[modelId];

                // Create input tensor
                var inputTensor = new DenseTensor<float>(features, new[] { 1, features.Length });

                // Create input for the model
                var inputs = new List<NamedOnnxValue>
                {
                    NamedOnnxValue.CreateFromTensor("input", inputTensor)
                };

                // Run inference
                using var results = session.Run(inputs);

                // Get output tensor
                var outputTensor = results.First().AsTensor<float>();

                // Convert to array
                var output = new float[outputTensor.Length];
                outputTensor.ToArray().CopyTo(output, 0);

                return output;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error during model inference with model '{modelId}'");
                throw;
            }
        }

        public async Task<MoveDto> GetBestActionAsync(GameStateDto gameState, string modelId = "1")
        {
            var features = GameAgentTranslator.ExtractGameFeatures(gameState);

            var output = await PredictActionAsync(features, modelId);

            var actionIndex = GameAgentTranslator.GetBestActionIndex(output);

            return GameAgentTranslator.ConvertActionIndexToPokerAction(actionIndex, gameState);
        }

        public void Dispose()
        {
            if (!_disposed)
            {
                foreach (var session in _sessions.Values)
                {
                    session?.Dispose();
                }
                _sessions.Clear();
                _disposed = true;
            }
        }
    }
}
