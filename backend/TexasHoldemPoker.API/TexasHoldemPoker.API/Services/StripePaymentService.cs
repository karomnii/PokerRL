using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.API.Repositories;

using Stripe.Checkout;

public class StripePaymentService
{
    public object CreateCheckoutSession(ShopItem item, string successUrl, string cancelUrl, int userId)
    {
        try
        {
            var options = new SessionCreateOptions
            {
                PaymentMethodTypes = new List<string> { "card", "p24" },
                LineItems = new List<SessionLineItemOptions>
                {
                    new SessionLineItemOptions
                    {
                        PriceData = new SessionLineItemPriceDataOptions
                        {
                            UnitAmount = (long)(item.Price * 100), // Cena w groszach
                            Currency = "pln",
                            ProductData = new SessionLineItemPriceDataProductDataOptions
                            {
                                Name = item.Name
                            }
                        },
                        Quantity = 1
                    }
                },
                Mode = "payment",
                SuccessUrl = successUrl,
                CancelUrl = cancelUrl,
                Metadata = new Dictionary<string, string>
                {
                    { "userId", userId.ToString() }, 
                    { "itemId", item.ItemId.ToString() }
                }
            };

            var service = new SessionService();
            var session = service.Create(options);

            return new { url = session.Url };
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error in CreateCheckoutSession: {ex.Message}");
            throw;
        }
    }

}