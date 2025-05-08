using TexasHoldemPoker.API.Models;
using TexasHoldemPoker.API.Repositories;
using Microsoft.AspNetCore.Mvc;
using Stripe.Checkout;

namespace TexasHoldemPoker.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PaymentsController : ControllerBase
{
    private readonly StripePaymentService _paymentService;
    private readonly ApplicationDbContext _context;
    private readonly IPurchaseRepository _purchaseRepository;

    public PaymentsController(StripePaymentService paymentService
        , ApplicationDbContext context
        , IPurchaseRepository purchaseRepository)
    {
        _paymentService = paymentService;
        _context = context;
        _purchaseRepository = purchaseRepository;
    }
    
    private async Task<bool> ProcessPurchaseAsync(int userId, ShopItem item, string paymentMethod, string transactionId = null)
    {
        var user = await _context.Users.FindAsync(userId);
        if (user == null)
            return false;

        if (item.Currency == "CHIPS")
        {
            if (user.ChipsBalance < item.Price)
                return false;

            user.ChipsBalance -= (int)item.Price;
        }

        if (item.ItemType == "Avatar")
        {
            user.AvatarType = item.Name;
        }
        
        var purchase = new Purchase
        {
            UserId = user.UserId,
            ItemId = item.ItemId,
            Price = item.Price,
            PurchaseDate = DateTime.UtcNow,
            PaymentMethod = paymentMethod,
            TransactionId = transactionId
        };

        _context.Purchases.Add(purchase);

        await _context.SaveChangesAsync();
        return true;
    }
    
    
    [HttpPost("create-checkout-session")]
    public IActionResult CreateCheckoutSession([FromBody] int itemId)
    {
        try
        {
            var item = _context.ShopItems.FirstOrDefault(i => i.ItemId == itemId && i.IsActive);

            if (item == null)
                return NotFound(new { Message = "Item not found or unavailable." });
            var userId = 12;
            if (item.Currency == "PLN")
            {
                var successUrl = $"http://localhost:5000/api/payments/success?session_id={{CHECKOUT_SESSION_ID}}&itemId={item.ItemId}";
                var cancelUrl = "http://localhost:5000/api/payments/cancel";

                var result = _paymentService.CreateCheckoutSession(item, successUrl, cancelUrl, userId);
                return Ok(result);
            }
            else if (item.Currency == "CHIPS")
            {
                var purchaseResult = ProcessPurchaseAsync(userId, item, "CHIPS").Result;
                if (!purchaseResult)
                    return BadRequest(new { Message = "Purchase failed. Check your balance or item availability." });

                return Ok(new { Message = $"{item.Name} purchased successfully!" });
            }

            return BadRequest(new { Message = "Invalid currency type." });
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error in CreateCheckoutSession: {ex.Message}");
            return StatusCode(500, new { Message = "Internal Server Error" });
        }
    }



    [HttpGet("success")]
    public async Task<IActionResult> Success(string session_id, int itemId)
    {
        try
        {
            var item = await _context.ShopItems.FindAsync(itemId);
            if (item == null)
                return NotFound(new { Message = "Item not found." });

            if (item.Currency == "PLN")
            {
                var service = new SessionService();
                var session = await service.GetAsync(session_id);

                if (session.PaymentStatus != "paid")
                    return BadRequest(new { Message = "Payment not successful." });

                var userId = int.Parse(session.Metadata["userId"]);

                var purchaseResult = await ProcessPurchaseAsync(userId, item, "Stripe", session.Id);
                if (!purchaseResult)
                    return BadRequest(new { Message = "Purchase failed. Check your balance or item availability." });

                return Ok(new { Message = $"{item.Name} purchased successfully with Stripe!" });
            }

            return BadRequest(new { Message = "Invalid currency type." });
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error in Success endpoint: {ex.Message}");
            return StatusCode(500, new { Message = "Internal Server Error" });
        }
    }


    
    [HttpGet("cancel")]
    public IActionResult Cancel() =>
         Ok(new { Message = "Payment cancelled." });
    
    
}