namespace TexasHoldemPoker.API.Models;

public class StripeSettings
{
    public string PublishableKey { get; set; }
    private string _secretKey;

    public string SecretKey
    {
        get => _secretKey;
        private set => _secretKey = value ?? throw new ArgumentNullException(nameof(SecretKey));
    }

    public StripeSettings(string secretKey, string publishableKey)
    {
        SecretKey = secretKey;
        PublishableKey = publishableKey;
    }
}