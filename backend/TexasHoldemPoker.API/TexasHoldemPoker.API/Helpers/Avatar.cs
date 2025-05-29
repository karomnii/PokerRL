namespace TexasHoldemPoker.API.Helpers;

public class Avatar
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public Avatar(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public string GetFullAvatarUrl(string avatarPath)
    {
        if (string.IsNullOrEmpty(avatarPath))
            return GetDefaultAvatarUrl();

        if (avatarPath.StartsWith("http://") || avatarPath.StartsWith("https://"))
            return avatarPath;

        var request = _httpContextAccessor.HttpContext?.Request;
        if (request != null)
        {
            var baseUrl = $"{request.Scheme}://{request.Host}";
            return $"{baseUrl}{avatarPath}";
        }

        return avatarPath;
    }

    public string GetDefaultAvatarUrl()
    {
        var request = _httpContextAccessor.HttpContext?.Request;
        if (request != null)
        {
            var baseUrl = $"{request.Scheme}://{request.Host}";
            return $"{baseUrl}/images/avatars/default.png";
        }

        return "/images/avatars/default.png";
    }
}