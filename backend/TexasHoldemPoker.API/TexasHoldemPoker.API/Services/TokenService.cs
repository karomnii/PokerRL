using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
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
        private readonly string _configuration;

        public TokenService(IConfiguration config,
            IHttpClientFactory httpFactory,
            ILogger<TokenService> logger)
        {
            _key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(
                config["TokenKey"] ?? throw new InvalidOperationException("TokenKey not configured")));
            
            _httpFactory = httpFactory;
            _logger = logger;
            _googleClientId = config["Authentication:Google:ClientId"];
            _configuration = config["Authentication:Facebook:AppSecret"];
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
                var handler = new JwtSecurityTokenHandler();
                var jsonToken = handler.ReadJwtToken(idToken);
                var tokenAudience = jsonToken.Claims.FirstOrDefault(c => c.Type == "aud")?.Value;
        
                _logger.LogInformation($"Token audience: {tokenAudience}");
                _logger.LogInformation($"Configured ClientId: {_googleClientId}");
                
                var settings = new GoogleJsonWebSignature.ValidationSettings
                {
                    Audience = new[] { _googleClientId }
                };
                
                if (!string.IsNullOrEmpty(tokenAudience) && tokenAudience != _googleClientId)
                {
                    _logger.LogWarning($"Token audience ({tokenAudience}) doesn't match configured ClientId ({_googleClientId})");
                    
                    settings.Audience = new[] { tokenAudience, _googleClientId };
                }

                var payload = await GoogleJsonWebSignature.ValidateAsync(idToken, settings);

                _logger.LogInformation($"Google token validated successfully for user: {payload.Email}");

                return new SocialUserInfo
                {
                    Email = payload.Email,
                    Name = payload.Name
                };
            }
            catch (InvalidJwtException ex)
            {
                _logger.LogError(ex, $"Invalid Google id_token. Details: {ex.Message}");
                return null;
            }
        }
        private async Task<SocialUserInfo?> ValidateFacebookAsync(string accessToken)
        {
            var appSecret = _configuration;
            if (string.IsNullOrEmpty(appSecret))
                throw new ArgumentNullException("Facebook AppSecret not configured");

            var appSecretProof = GenerateAppSecretProof(accessToken, appSecret);
            var client = _httpFactory.CreateClient(nameof(FacebookUserInfo));
            client.Timeout = TimeSpan.FromSeconds(5);

            var url = $"https://graph.facebook.com/me?fields=email,name&access_token={accessToken}&appsecret_proof={appSecretProof}";
            var resp = await client.GetAsync(url);

            if (!resp.IsSuccessStatusCode) return null;

            var json = await resp.Content.ReadAsStringAsync();
            var fb = JsonConvert.DeserializeObject<FacebookUserInfo>(json);
            
            if (string.IsNullOrWhiteSpace(fb?.Email))
            {
                _logger.LogError("Facebook nie zwrócił adresu email dla użytkownika");
                return null; 
            }

            return new SocialUserInfo { Email = fb.Email, Name = fb.Name };
        }
        private string GenerateAppSecretProof(string accessToken, string appSecret)
        {
            using (var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(appSecret)))
            {
                var hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(accessToken));
                var sb = new StringBuilder();
                foreach (var b in hash)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

    }

}
