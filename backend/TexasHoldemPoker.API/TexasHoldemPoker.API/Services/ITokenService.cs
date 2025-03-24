using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Services
{
    public interface ITokenService
    {
        string CreateToken(User user);
    }

}
