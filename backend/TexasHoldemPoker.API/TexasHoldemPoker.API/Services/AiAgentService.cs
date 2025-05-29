using Microsoft.ML.OnnxRuntime.Tensors;
using Microsoft.ML.OnnxRuntime;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Helpers;

namespace TexasHoldemPoker.API.Services
{
    public class AiAgentService : IAiAgentService, IDisposable
    {
        private readonly InferenceSession _session;
        private readonly ILogger<AiAgentService> _logger;
        private bool _disposed = false;

        public AiAgentService(ILogger<AiAgentService> logger)
        {
            _logger = logger;

            // Load the ONNX model
            var modelPath = Path.Combine(Directory.GetCurrentDirectory(), "agents", "dqn_model.onnx");

            if (!File.Exists(modelPath))
            {
                throw new FileNotFoundException($"ONNX model not found at: {modelPath}");
            }

            var sessionOptions = new Microsoft.ML.OnnxRuntime.SessionOptions();
            sessionOptions.LogSeverityLevel = OrtLoggingLevel.ORT_LOGGING_LEVEL_INFO;

            _session = new InferenceSession(modelPath, sessionOptions);

            _logger.LogInformation($"ONNX model loaded successfully from: {modelPath}");
        }

        public async Task<float[]> PredictActionAsync(float[] features)
        {
            try
            {
                // Create input tensor
                var inputTensor = new DenseTensor<float>(features, new[] { 1, features.Length });

                // Create input for the model
                var inputs = new List<NamedOnnxValue>
                {
                    NamedOnnxValue.CreateFromTensor("input", inputTensor)
                };

                // Run inference
                using var results = _session.Run(inputs);

                // Get output tensor
                var outputTensor = results.First().AsTensor<float>();

                // Convert to array
                var output = new float[outputTensor.Length];
                outputTensor.ToArray().CopyTo(output, 0);

                return output;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during model inference");
                throw;
            }
        }

        public async Task<MoveDto> GetBestActionAsync(GameStateDto gameState)
        {
            var features = GameAgentTranslator.ExtractGameFeatures(gameState);

            var output = await PredictActionAsync(features);

            var actionIndex = GameAgentTranslator.GetBestActionIndex(output);

            return GameAgentTranslator.ConvertActionIndexToPokerAction(actionIndex, gameState);
        }

        public void Dispose()
        {
            _session?.Dispose();
        }
    }
}
