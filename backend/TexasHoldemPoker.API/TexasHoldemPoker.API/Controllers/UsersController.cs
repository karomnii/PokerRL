using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Models;
using TexasHoldemPoker.API.Repositories;
using TexasHoldemPoker.API.Services;
using TexasHoldemPoker.API.Helpers;

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
        private readonly ProfileAvatarHelper _avatar;
        public UsersController(
            IUserRepository userRepository,
            IPasswordHasher<User> passwordHasher,
            ITokenService tokenService,
            ILeaderboardRepository leaderboardRepository,
            ProfileAvatarHelper avatar)
        {
            _userRepository = userRepository;
            _passwordHasher = passwordHasher;
            _tokenService = tokenService;
            _leaderboardRepository = leaderboardRepository ?? throw new ArgumentNullException(nameof(leaderboardRepository));
            _avatar = avatar;
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
                ChipsBalance = 5000,
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
        

        /* Logic of social-login 
           * Front -> POST /social-login
           * new user -> returns 202
           * Front -> POST /choose-username
           * Front -> POST /change-username for user
           * to set his own username (requires user id from sociallogin endpoint)
           * full registerd new user returns 200
        */
        
        [HttpPost("social-login")]
        public async Task<ActionResult<UserDto>> SocialLogin([FromBody] SocialLoginDto loginDto)
        {
            if (!ModelState.IsValid || string.IsNullOrWhiteSpace(loginDto.Token))
                return BadRequest("Provider and token are required.");

            var info = await _tokenService.ValidateSocialTokenAsync(loginDto.Provider, loginDto.Token);
            if (info is null) 
                return Unauthorized("Invalid social token");
            
            var user = await _userRepository.GetByEmailAsync(info.Email);
            
            if (user is null)
            {
                var randomPassword = $"SOCIAL_{Guid.NewGuid()}_{DateTime.UtcNow.Ticks}";
                user = new User
                {
                    Email = info.Email,
                    RegistrationDate = DateTime.UtcNow,
                    ChipsBalance = 5000,
                    IsActive = true,
                    AvatarImage = "/images/default.png",
                    Username = $"user_{Guid.NewGuid().ToString().Substring(0, 8)}",
                    PasswordHash = _passwordHasher.HashPassword(null, randomPassword)
                };
                await _userRepository.CreateUserAsync(user);
                
                user.LastLoginDate = DateTime.UtcNow; 
                await _userRepository.UpdateUserAsync(user);
                
                return Accepted(new
                {
                    RequiresUsername = true,
                    UserId = user.UserId,
                    Email = user.Email,
                    Message = "Account created successfully. Please choose a username."
                });
            }
            else
            {
                user.LastLoginDate = DateTime.UtcNow; 
                await _userRepository.UpdateUserAsync(user);
                
                if (string.IsNullOrWhiteSpace(user.Username))
                {
                    return Accepted(new
                    {
                        RequiresUsername = true,
                        UserId = user.UserId,
                        Email = user.Email,
                        Message = "Please choose a username to complete your profile."
                    });
                }
                
                return Ok(new UserDto
                {
                    UserId = user.UserId,
                    Username = user.Username,
                    Email = user.Email,
                    ChipsBalance = user.ChipsBalance,
                    AvatarImage = user.AvatarImage,
                    Token = _tokenService.CreateToken(user),
                });
            }
        }
        
        
        [Authorize]
        [HttpPost("change-username")]
        public async Task<ActionResult<UserDto>> ChangeUsername([FromBody] ChangeUsernameDto dto)
        {
            if (string.IsNullOrWhiteSpace(dto.Username) || dto.Username.Length < 3)
            return BadRequest("Username must be at least 3 characters.");

            if (await _userRepository.GetByUsernameAsync(dto.Username) != null)
                return BadRequest("Username is taken.");

            var user = await _userRepository.GetByIdAsync(dto.UserId);
            if (user == null)
                return NotFound();

            user.Username = dto.Username;
            await _userRepository.UpdateUserAsync(user);

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

        [HttpPut("profile/{userId}")]
        public async Task<ActionResult<UserDto>> GetProfile(int userId)
        {
            var user = await _userRepository.GetByIdAsync(userId);
            if (user == null)
                return NotFound(new { message = "User does not exist" });

            return new UserDto
            {
                UserId = user.UserId,
                Username = user.Username,
                Email = user.Email,
                ChipsBalance = user.ChipsBalance,
                AvatarImage = _avatar.GetFullAvatarUrl(user.AvatarImage),
                Token = _tokenService.CreateToken(user)
            };
        }
        
        [HttpGet("leaderboard/top")]
        public async Task<ActionResult<IEnumerable<LeaderboardView>>> GetTopPlayers([FromQuery] int count = 10)
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