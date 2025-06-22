using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using System.Threading.Tasks;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Models;
using TexasHoldemPoker.API.Repositories;
using TexasHoldemPoker.API.Services;

namespace TexasHoldemPoker.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class GamesController : ControllerBase
    {
        private readonly IPokerGameService _gameService;
        private readonly IGameRepository _gameRepository;
        private readonly IPokerTableRepository _pokerTableRepository;
        private readonly IAiAgentService _aiAgentService;

        public GamesController(IPokerGameService gameService, IGameRepository gameRepository, IPokerTableRepository pokerTableRepository, IAiAgentService aiAgentService)
        {
            _gameService = gameService;
            _gameRepository = gameRepository;
            _pokerTableRepository = pokerTableRepository;
            _aiAgentService = aiAgentService;
            
            _gameService.InitializeAgentsPlayingInGames().GetAwaiter().GetResult();
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ActiveGameDto>>> GetActiveGames()
        {
            var games = await _gameRepository.GetActiveGamesAsync();

            var gameDtos = games.Select(game => new ActiveGameDto
            {
                GameId = game.GameId,
                TableName = game.Table.Name,
                TableDifficulty = game.Table.DifficultyLevel ?? "Unknown"
            });

            return Ok(gameDtos);
        }

        [HttpGet("/tables")]
        public async Task<ActionResult<IEnumerable<TableDto>>> GetTables()
        {
            var pokerTableDTOs = await _pokerTableRepository.GetAllTableDTOsAsync();

            return Ok(pokerTableDTOs);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<GameStateDto>> GetGame(int id)
        {
            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value);
            var gameStateDto = await _gameService.GetGameStateAsync(id, userId);

            if (gameStateDto == null)
                return NotFound();

            return Ok(gameStateDto);
        }

        [HttpGet("{id}/public")]
        [AllowAnonymous]
        public async Task<ActionResult<GameStateDto>> GetGamePublic(int id)
        {
            var userId = 0; // 0 means public state only
            var gameStateDto = await _gameService.GetGameStateAsync(id, userId);

            if (gameStateDto == null)
                return NotFound();

            return Ok(gameStateDto);
        }

        [HttpPost]
        public async Task<ActionResult<ActiveGameDto>> CreateGame(CreateGameDto createDto)
        {
            var game = await _gameService.CreateGameAsync(createDto.TableId);

            if (game == null)
                return BadRequest("Failed to create game");

            game = await _gameRepository.GetByIdAsync(game.GameId);

            var gameDto = new ActiveGameDto
            {
                GameId = game.GameId,
                TableName = game.Table?.Name ?? "Unknown",
                TableDifficulty = game.Table?.DifficultyLevel ?? "Unknown"
            };
            return CreatedAtAction(nameof(GetGame), new { id = game.GameId }, gameDto);
        }

        [HttpPost("{id}/join")]
        public async Task<ActionResult> JoinGame(int id, JoinGameDto joinDto)
        {
            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value);
            var result = await _gameService.JoinGameAsync(id, userId, joinDto.SeatPosition, joinDto.BuyInAmount);

            if (!result)
                return BadRequest("Failed to join game");

            return NoContent();
        }

        [HttpPost("{id}/leave")]
        public async Task<ActionResult> LeaveGame(int id)
        {
            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value);

            var game = await _gameRepository.GetByIdAsync(id);
            if (game == null)
                return NotFound(new { message = "Game not found" });

            var gamePlayer = game.GamePlayers.FirstOrDefault(p => p.UserId == userId);
            if (gamePlayer == null)
                return BadRequest(new { message = "Player not in this game" });

            var result = await _gameService.LeaveGameAsync(id, userId);

            if (!result)
                return BadRequest(new { message = "Failed to leave game" });

            return Ok(new
            {
                message = $"Player {userId} successfully removed from game",
                refundedChips = gamePlayer.CurrentChips
            });
        }

        [HttpPost("{id}/start")]
        public async Task<ActionResult> StartGame(int id)
        {
            var result = await _gameService.StartGameAsync(id);

            if (!result)
                return BadRequest("Failed to start game");

            return NoContent();
        }

        [HttpPost("{id}/move")]
        public async Task<ActionResult> MakeMove(int id, MakeMoveDto moveDto)
        {
            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value);
            var result = await _gameService.PlaceBetAsync(id, userId, moveDto.ActionType, moveDto.Amount);

            if (!result)
                return BadRequest("Invalid move or not your turn");

            return NoContent();
        }

        [HttpPost("{id}/hint")]
        public async Task<ActionResult<IEnumerable<HintDto>>> GetHint(int id)
        {
            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value);
            var result = await _gameService.GetGameHints(id,userId);

            if (result == null || !result.Any())
                return NotFound("No hints available for this game or it is not your turn");

            return Ok(result);
        }

        // Admin endpoints for testing/debugging
        [HttpGet("{id}/{userId}")]
        public async Task<ActionResult<GameStateDto>> GetGameWithUserId(int id, int userId)
        {
            var gameStateDto = await _gameService.GetGameStateAsync(id, userId);

            if (gameStateDto == null)
                return NotFound();

            return Ok(gameStateDto);
        }

        [HttpPost("{id}/join/{userId}")]
        public async Task<ActionResult> JoinGameWithUserId(int id, JoinGameDto joinDto, int userId)
        {
            var result = await _gameService.JoinGameAsync(id, userId, joinDto.SeatPosition, joinDto.BuyInAmount);

            if (!result)
                return BadRequest("Failed to join game");

            return NoContent();
        }

        [HttpPost("{id}/move/{userId}")]
        public async Task<ActionResult> MakeMoveWithUserId(int id, MakeMoveDto moveDto, int userId)
        {
            var result = await _gameService.PlaceBetAsync(id, userId, moveDto.ActionType, moveDto.Amount);

            if (!result)
                return BadRequest("Invalid move or not your turn");

            return NoContent();
        }

        [HttpPost("{id}/hint/{userId}")]
        public async Task<ActionResult<IEnumerable<HintDto>>> GetHint(int id, int userId)
        {
            var result = await _gameService.GetGameHints(id, userId);

            if (result == null || !result.Any())
                return NotFound("No hints available for this game or it is not your turn");

            return Ok(result);
        }

        [HttpPost("{id}/leave/{userId}")]
        public async Task<ActionResult> LeaveGameWithUserId(int id, int userId)
        {
            var game = await _gameRepository.GetByIdAsync(id);
            if (game == null)
                return NotFound(new { message = "Game not found" });

            var gamePlayer = game.GamePlayers.FirstOrDefault(p => p.UserId == userId);
            if (gamePlayer == null)
                return BadRequest(new { message = "Player not in this game" });

            var result = await _gameService.LeaveGameAsync(id, userId);

            if (!result)
                return BadRequest(new { message = "Failed to leave game" });

            return Ok(new
            {
                message = $"Player {userId} successfully removed from game",
                refundedChips = gamePlayer.CurrentChips
            });
        }

        [HttpGet("{id}/ai-agents")]
        public async Task<ActionResult<IEnumerable<AgentDto>>> GetAiAgents(int id)
        {
            var agents = await _gameService.GetAvailableAgentsAsync(id);
            return Ok(agents);
        }

        [HttpPost("{id}/add/{agentId}")]
        public async Task<ActionResult> AddAiAgentToGame(int id, JoinGameDto joinDto, int agentId)
        {
            var result = await _gameService.AddModelToGameAsync(id, agentId, joinDto.SeatPosition, joinDto.BuyInAmount);

            if (!result)
                return BadRequest("Failed to join game");

            return NoContent();
        }
    }
}