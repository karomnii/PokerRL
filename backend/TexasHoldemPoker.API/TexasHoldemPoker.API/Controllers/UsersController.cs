using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Models;
using TexasHoldemPoker.API.Repositories;
using TexasHoldemPoker.API.Services;

namespace TexasHoldemPoker.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly IUserRepository _userRepository;
        private readonly IPasswordHasher<User> _passwordHasher;
        private readonly ITokenService _tokenService;
        private readonly ILeaderboardRepository _leaderboardRepository;
        public UsersController(
            IUserRepository userRepository,
            IPasswordHasher<User> passwordHasher,
            ITokenService tokenService,
            ILeaderboardRepository leaderboardRepository)
        {
            _userRepository = userRepository;
            _passwordHasher = passwordHasher;
            _tokenService = tokenService;
            _leaderboardRepository = leaderboardRepository ?? throw new ArgumentNullException(nameof(leaderboardRepository));
        }

        [HttpPost("register")]
        public async Task<ActionResult<UserDto>> Register(RegisterDto registerDto)
        {
            if (await _userRepository.GetByUsernameAsync(registerDto.Username) != null)
                return BadRequest("Username is taken");

            if (await _userRepository.GetByEmailAsync(registerDto.Email) != null)
                return BadRequest("Email is already registered");

            var user = new User
            {
                Username = registerDto.Username,
                Email = registerDto.Email,
                ChipsBalance = 1000,
                RegistrationDate = DateTime.UtcNow,
                IsActive = true,
                AvatarImage = "/images/default.png"
            };

            user.PasswordHash = _passwordHasher.HashPassword(user, registerDto.Password);

            await _userRepository.CreateUserAsync(user);

            return new UserDto
            {
                UserId = user.UserId,
                Username = user.Username,
                Email = user.Email,
                ChipsBalance = user.ChipsBalance,
                AvatarImage = "/images/default.png",
                Token = _tokenService.CreateToken(user)
            };
        }

        [HttpPost("login")]
        public async Task<ActionResult<UserDto>> Login(LoginDto loginDto)
        {
            var user = await _userRepository.GetByUsernameAsync(loginDto.Username);

            if (user == null)
                return Unauthorized("Invalid username");

            var result = _passwordHasher.VerifyHashedPassword(
                user, user.PasswordHash, loginDto.Password);

            if (result != PasswordVerificationResult.Success)
                return Unauthorized("Invalid password");

            user.LastLoginDate = DateTime.UtcNow;
            await _userRepository.UpdateUserAsync(user);

            return new UserDto
            {
                UserId = user.UserId,
                Username = user.Username,
                Email = user.Email,
                ChipsBalance = user.ChipsBalance,
                AvatarImage = user.AvatarImage,
                Token = _tokenService.CreateToken(user)
            };
        }
        

        /*
         *Logic of social-login 
         * Front -> POST /social-login
         * new user -> returns 202
         * Front -> POST /choose-username
         * full registerd new user returns 200
         */
        
        [HttpPost("social-login")]
        public async Task<ActionResult<UserDto>> SocialLogin([FromBody] SocialLoginDto loginDto)
        {
            if (!ModelState.IsValid || string.IsNullOrWhiteSpace(loginDto.Token))
                return BadRequest("Provider and token are required.");

            var info = await _tokenService.ValidateSocialTokenAsync(loginDto.Provider, loginDto.Token);
            if (info is null) return Unauthorized("Invalid social token");


            var user = await _userRepository.GetByEmailAsync(info.Email);
            if (user is null)
            {
                user = new User
                {
                    Email = info.Email,
                    RegistrationDate = DateTime.UtcNow,
                    ChipsBalance = 1000,
                    IsActive = true,
                    AvatarImage = "/images/default.png",
                    Username = null
                };
                await _userRepository.CreateAsync(user);
            }
            if (string.IsNullOrWhiteSpace(user.Username))
            {
                return Accepted(new
                {
                    RequiresUsername = true,
                    UserId   = user.UserId,
                    Email    = user.Email
                });
            }
            return Ok(new UserDto
            {
                UserId       = user.UserId,
                Username     = user.Username,
                Email        = user.Email,
                ChipsBalance = user.ChipsBalance,
                AvatarImage  = user.AvatarImage,
                Token        = _tokenService.CreateToken(user)
            });
        }
        
        
        [Authorize]
        [HttpPost("choose-username")]
        public async Task<ActionResult<UserDto>> ChooseUsername([FromBody] ChooseUsernameDto dto)
        {
            if (!ModelState.IsValid || string.IsNullOrWhiteSpace(dto.Username))
                return BadRequest("Username is required.");

            if (await _userRepository.GetByUsernameAsync(dto.Username) != null)
                return BadRequest("Username is taken.");

            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            var user   = await _userRepository.GetByIdAsync(userId);
            if (user == null) return NotFound();

            user.Username = dto.Username;
            await _userRepository.UpdateAsync(user);

            return Ok(new UserDto
            {
                UserId       = user.UserId,
                Username     = user.Username,
                Email        = user.Email,
                ChipsBalance = user.ChipsBalance,
                AvatarImage  = user.AvatarImage,
                Token        = _tokenService.CreateToken(user)
            });
        }
        
        [Authorize]
        [HttpGet("profile")]
        public async Task<ActionResult<UserDto>> GetProfile()
        {
            var username = User.FindFirst(ClaimTypes.Name)?.Value;
            var user = await _userRepository.GetByUsernameAsync(username);

            if (user == null)
                return NotFound();

            return new UserDto
            {
                UserId = user.UserId,
                Username = user.Username,
                Email = user.Email,
                ChipsBalance = user.ChipsBalance,
                AvatarImage = user.AvatarImage
            };
        }

        [Authorize]
        [HttpPut("profile")]
        public async Task<ActionResult> UpdateProfile(UpdateProfileDto updateDto)
        {
            var username = User.FindFirst(ClaimTypes.Name)?.Value;
            var user = await _userRepository.GetByUsernameAsync(username);

            if (user == null)
                return NotFound();

            if (!string.IsNullOrEmpty(updateDto.Email))
                user.Email = updateDto.Email;

            if (!string.IsNullOrEmpty(updateDto.AvatarImage))
                user.AvatarImage = updateDto.AvatarImage;

            await _userRepository.UpdateUserAsync(user);

            return NoContent();
        }
        
        
        [HttpGet("leaderboard/top")]
        public async Task<ActionResult<IEnumerable<LeaderboardEntry>>> GetTopPlayers([FromQuery] int count = 10)
        {
            var topPlayers = await _leaderboardRepository.GetTopPlayersSortedAsync(count);
            return Ok(topPlayers);
        }
        
        [HttpGet("leaderboard/player-info/{userId}")]
        public async Task<ActionResult<object>> GetPlayerInfo(int userId)
        {
            var playerRanking = await _leaderboardRepository.GetPlayerRankingAsync(userId);
            if (playerRanking == null)
                return NotFound(new { Message = "Player not found in the leaderboard." });
            
            var position = await _leaderboardRepository.GetPlayerRankPositionAsync(userId);
            if (position == -1)
                return NotFound(new { Message = "Player not found in the leaderboard." });

            var result = new
            {
                Position = position,
                PlayerDetails = playerRanking
            };

            return Ok(result);
        }
    }
}