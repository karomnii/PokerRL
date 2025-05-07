using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Newtonsoft.Json;
using TexasHoldemPoker.API.Models;
using Google.Apis.Auth;

namespace TexasHoldemPoker.API.Services
{
    public class TokenService : ITokenService
    {
        private readonly SymmetricSecurityKey _key;
        private readonly IHttpClientFactory _httpFactory;
        private readonly ILogger<TokenService> _logger;
        private readonly string _googleClientId;

        public TokenService(IConfiguration config,
            IHttpClientFactory httpFactory,
            ILogger<TokenService> logger)
        {
            _key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(
                config["TokenKey"] ?? throw new InvalidOperationException("TokenKey not configured")));
            
            _httpFactory = httpFactory;
            _logger = logger;
            _googleClientId = config["Authentication:Google:ClientId"];
        }

        public string CreateToken(User user)
        {
            var claims = new List<Claim>
        {
            new Claim(JwtRegisteredClaimNames.NameId, user.UserId.ToString()),
            new Claim(JwtRegisteredClaimNames.UniqueName, user.Username)
        };

            var creds = new SigningCredentials(_key, SecurityAlgorithms.HmacSha512Signature);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.Now.AddDays(7),
                SigningCredentials = creds
            };

            var tokenHandler = new JwtSecurityTokenHandler();

            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }

        public async Task<SocialUserInfo> ValidateSocialTokenAsync(string provider, string token)
        {
            switch (provider?.ToLowerInvariant())
            {
                case "facebook":
                    return await ValidateFacebookAsync(token);
                case "google":
                    return await ValidateGoogleAsync(token);
                default:
                    _logger.LogWarning("Invalid provider provided");
                    return null;
            }
        }


        private async Task<SocialUserInfo?> ValidateGoogleAsync(string idToken)
        {
            try
            {
                var payload = await GoogleJsonWebSignature.ValidateAsync(
                    idToken,
                    new GoogleJsonWebSignature.ValidationSettings
                    {
                        Audience = new[] { _googleClientId }
                    });

                return new SocialUserInfo
                {
                    Email = payload.Email,
                    Name  = payload.Name
                };
            }
            catch (InvalidJwtException ex)
            {
                _logger.LogInformation(ex, "Invalid Google id_token");
                return null;
            }
        }
        private async Task<SocialUserInfo?> ValidateFacebookAsync(string accessToken)
        {
            var client = _httpFactory.CreateClient(nameof(FacebookUserInfo));
            client.Timeout = TimeSpan.FromSeconds(5);

            var url = $"https://graph.facebook.com/me?fields=email,name&access_token={accessToken}";
            var resp = await client.GetAsync(url);

            if (!resp.IsSuccessStatusCode) return null;

            var json = await resp.Content.ReadAsStringAsync();
            var fb   = JsonConvert.DeserializeObject<FacebookUserInfo>(json);

            return new SocialUserInfo { Email = fb?.Email, Name = fb?.Name };
        }
    }

}
