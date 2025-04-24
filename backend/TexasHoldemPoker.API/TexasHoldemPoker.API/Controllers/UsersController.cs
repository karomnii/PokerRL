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

        public UsersController(
            IUserRepository userRepository,
            IPasswordHasher<User> passwordHasher,
            ITokenService tokenService)
        {
            _userRepository = userRepository;
            _passwordHasher = passwordHasher;
            _tokenService = tokenService;
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
                ChipsBalance = 1000, // Starting chips
                RegistrationDate = DateTime.UtcNow,
                IsActive = true
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

            // Update last login date
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

            // Update user properties
            if (!string.IsNullOrEmpty(updateDto.Email))
                user.Email = updateDto.Email;

            if (!string.IsNullOrEmpty(updateDto.AvatarImage))
                user.AvatarImage = updateDto.AvatarImage;

            await _userRepository.UpdateUserAsync(user);

            return NoContent();
        }
    }
}
