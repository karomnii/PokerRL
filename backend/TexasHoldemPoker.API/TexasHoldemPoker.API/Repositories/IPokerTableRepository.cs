using Microsoft.EntityFrameworkCore.Metadata.Internal;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public interface IPokerTableRepository
    {
        Task<IEnumerable<PokerTable>> GetAllAsync();
        Task<IEnumerable<TableDto>> GetAllTableDTOsAsync();
    }
}