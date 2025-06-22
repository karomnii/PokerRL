using Microsoft.ML.OnnxRuntime.Tensors;
using Microsoft.ML.OnnxRuntime;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Helpers;
using TexasHoldemPoker.API.Repositories;
using TexasHoldemPoker.API.Services;

public class AiAgentService : IAiAgentService, IDisposable
{
    private readonly Dictionary<string, InferenceSession> _sessions;
    private readonly ILogger<AiAgentService> _logger;
    private readonly IServiceProvider _serviceProvider;
    private bool _disposed = false;
    private readonly Random random = new Random();

    public AiAgentService(ILogger<AiAgentService> logger, IServiceProvider serviceProvider)
    {
        _logger = logger;
        _serviceProvider = serviceProvider;
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

        using var scope = _serviceProvider.CreateScope();
        var modelRepository = scope.ServiceProvider.GetRequiredService<IModelRepository>();

        var allModels = modelRepository.GetAllAsync().GetAwaiter().GetResult();

        var modelConfigs = new Dictionary<string, string>();

        foreach (var model in allModels)
        {
            modelConfigs.Add(model.ModelId.ToString(), model.Path ?? "");
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

    private async Task<T> ExecuteWithScope<T>(Func<IServiceProvider, Task<T>> operation)
    {
        using var scope = _serviceProvider.CreateScope();
        return await operation(scope.ServiceProvider);
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

            var inputTensor = new DenseTensor<float>(features, new[] { 1, features.Length });

            var inputs = new List<NamedOnnxValue>
            {
                NamedOnnxValue.CreateFromTensor("input", inputTensor)
            };

            using var results = session.Run(inputs);

            var outputTensor = results.First().AsTensor<float>();

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
        float[] features;
        if (modelId == "1")
            features = GameAgentTranslator.ExtractGameFeaturesOld(gameState);
        else if (modelId == "2" || modelId == "3")
            features = GameAgentTranslator.ExtractGameFeatures(gameState);
        else
            return new MoveDto
            {
                ActionType = "Fold",
                Amount = 0
            };

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