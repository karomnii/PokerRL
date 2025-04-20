using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Models;
using TexasHoldemPoker.API.Repositories;
using TexasHoldemPoker.API.Services;

namespace TexasHoldemPoker.API.Controllers
{
    [AllowAnonymous]
    [ApiController]
    [Route("api/[controller]")]
    //[Authorize]
    public class GamesController : ControllerBase
    {
        private readonly IPokerGameService _gameService;
        private readonly IGameRepository _gameRepository;

        public GamesController(
            IPokerGameService gameService,
            IGameRepository gameRepository)
        {
            _gameService = gameService;
            _gameRepository = gameRepository;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Game>>> GetActiveGames()
        {
            var games = await _gameRepository.GetActiveGamesAsync();
            return Ok(games);
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
        public async Task<ActionResult<GameStateDto>> GetGamePublic(int id)
        {
            var userId = 0; // 0 means public state only
            var gameStateDto = await _gameService.GetGameStateAsync(id, userId);

            if (gameStateDto == null)
                return NotFound();

            return Ok(gameStateDto);
        }

        [HttpPost]
        public async Task<ActionResult<Game>> CreateGame(CreateGameDto createDto)
        {
            var game = await _gameService.CreateGameAsync(createDto.TableId);
            return CreatedAtAction(nameof(GetGame), new { id = game.GameId }, game);
        }

        [HttpPost("{id}/join")]
        public async Task<ActionResult> JoinGame(int id, JoinGameDto joinDto)
        {
            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value);

            var result = await _gameService.JoinGameAsync(
                id, userId, joinDto.SeatPosition, joinDto.BuyInAmount);

            if (!result)
                return BadRequest("Failed to join game");

            return NoContent();
        }

        [HttpPost("{id}/leave")]
        public async Task<ActionResult> LeaveGame(int id)
        {
            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value);

            var result = await _gameService.LeaveGameAsync(id, userId);

            if (!result)
                return BadRequest("Failed to leave game");

            return NoContent();
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

            var result = await _gameService.PlaceBetAsync(
                id, userId, moveDto.ActionType, moveDto.Amount);

            if (!result)
                return BadRequest("Invalid move");

            return NoContent();
        }

        [HttpGet("{id}/{userId}")]
        public async Task<ActionResult<GameStateDto>> GetGameWithUserId(int id, int userId)
        {
            var gameStateDto = await _gameService.GetGameStateAsync(id, userId);

            if (gameStateDto == null)
                return NotFound();

            return Ok(gameStateDto);
        }

        [HttpPost("{id}/join/{userid}")]
        public async Task<ActionResult> JoinGameWithUserId(int id, JoinGameDto joinDto, int userId)
        {
            var result = await _gameService.JoinGameAsync(
                id, userId, joinDto.SeatPosition, joinDto.BuyInAmount);

            if (!result)
                return BadRequest("Failed to join game");

            return NoContent();
        }

        [HttpPost("{id}/move/{userid}")]
        public async Task<ActionResult> MakeMoveWithUserId(int id, MakeMoveDto moveDto, int userId)
        {
            var result = await _gameService.PlaceBetAsync(
                id, userId, moveDto.ActionType, moveDto.Amount);

            if (!result)
                return BadRequest("Invalid move");

            return NoContent();
        }

    }
}
