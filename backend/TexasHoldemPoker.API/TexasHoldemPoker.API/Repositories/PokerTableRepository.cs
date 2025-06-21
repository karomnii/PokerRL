using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using TexasHoldemPoker.API.DTOs;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories
{
    public class PokerTableRepository : IPokerTableRepository
    {
        private readonly ApplicationDbContext _context;

        public PokerTableRepository(ApplicationDbContext context)
        {
            _context = context;
        }
        public async Task<IEnumerable<PokerTable>> GetAllAsync()
        {
            return await _context.PokerTables
                .ToListAsync();
        }

        public async Task<IEnumerable<TableDto>> GetAllTableDTOsAsync()
        {
            return await _context.PokerTables
                .Select(table => new TableDto
                {
                    TableId = table.TableId,
                    Name = table.Name,
                    DifficultyLevel = table.DifficultyLevel,
                    MaxPlayers = table.MaxPlayers,
                    MinBuyIn = table.MinBuyIn,
                    MaxBuyIn = table.MaxBuyIn,
                    SmallBlind = table.SmallBlind,
                    BigBlind = table.BigBlind
                })
                .ToListAsync();
        }
    }
}