using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication.Facebook;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Options;
using Stripe;
using TexasHoldemPoker.API.Helpers;
using TexasHoldemPoker.API.Models;
using TexasHoldemPoker.API.Repositories;
using TexasHoldemPoker.API.Services;
using TokenService = TexasHoldemPoker.API.Services.TokenService;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container
        builder.Services.AddControllers();
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();

        // Add database context
        builder.Services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

        // Add repositories
        builder.Services.AddScoped<IUserRepository, UserRepository>();
        builder.Services.AddScoped<IGameRepository, GameRepository>();
        builder.Services.AddScoped<IGamePlayerRepository, GamePlayerRepository>();
        builder.Services.AddScoped<ICardRepository, CardRepository>();
        builder.Services.AddScoped<IMoveRepository, MoveRepository>();
        builder.Services.AddScoped<IShopRepository, ShopRepository>();
        builder.Services.AddScoped<IPurchaseRepository, PurchaseRepository>();
        builder.Services.AddScoped<IChipTransactionRepository, ChipTransactionRepository>();
        builder.Services.AddScoped<ILeaderboardRepository, LeaderboardRepository>();
        builder.Services.AddScoped<IGameRoundRepository, GameRoundRepository>();
        builder.Services.AddScoped<IGameRoundWinnerRepository, GameRoundWinnerRepository>();
        builder.Services.AddScoped<IModelRepository, ModelRepository>();
        builder.Services.AddScoped<IUserModelRepository, UserModelRepository>();

        // Add services
        builder.Services.AddScoped<IPokerGameService, PokerGameService>();
        builder.Services.AddScoped<ITokenService, TokenService>();
        builder.Services.AddScoped<IPasswordHasher<User>, PasswordHasher<User>>();
        builder.Services.AddScoped<IAiAgentService, AiAgentService>();
        builder.Services.AddHttpContextAccessor();
        builder.Services.AddScoped<ProfileAvatarHelper>();

        // stripe 

        builder.Services.Configure<StripeSettings>(builder.Configuration.GetSection("Stripe"));
        Stripe.StripeConfiguration.ApiKey = builder.Configuration["Stripe:SecretKey"];
        builder.Services.AddScoped<StripePaymentService>();
        
        // socials
        
        builder.Services.AddHttpClient();  
        
        // Add authentication
        builder.Services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(
                        builder.Configuration["TokenKey"])),
                    ValidateIssuer = false,
                    ValidateAudience = false
                };
            });
        //.AddGoogle(googleOptions =>
        //{
        //    googleOptions.ClientId = builder.Configuration["Authentication:Google:ClientId"];
        //    googleOptions.ClientSecret = builder.Configuration["Authentication:Google:ClientSecret"];
        //})
        //.AddFacebook(facebookOptions =>
        //{
        //    facebookOptions.ClientId = builder.Configuration["Authentication:Facebook:AppId"];
        //    facebookOptions.ClientSecret = builder.Configuration["Authentication:Facebook:AppSecret"];
        //});
        
        
        // Add JSON options
        builder.Services.AddControllers().AddJsonOptions(options =>
        {
            options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
        });


        // Add CORS
        builder.Services.AddCors(options =>
        {
            options.AddPolicy("CorsPolicy", policy =>
            {
                policy.AllowAnyHeader()
                    .AllowAnyMethod()
                    .WithOrigins("http://localhost:3000") // Replace with your Flutter web app URL
                    .AllowCredentials();
            });
        });
        // swagger 
        builder.Services.AddSwaggerGen(c =>
        {
            c.SwaggerDoc("v1", new OpenApiInfo
            {
                Title = "Texas Hold'em Poker API",
                Version = "v1",
                Description = "API for Texas Hold'em Poker game",
                Contact = new OpenApiContact
                {
                    Name = "Your Name",
                    Email = "your.email@example.com"
                }
            });

            // Opcjonalnie: dodanie autoryzacji JWT do Swaggera
            c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
            {
                Description = "Enter 'Bearer {token}'",
                Name = "Authorization",
                In = ParameterLocation.Header,
                Type = SecuritySchemeType.Http,
                Scheme = "bearer"
            });

            c.AddSecurityRequirement(new OpenApiSecurityRequirement
            {
                {
                    new OpenApiSecurityScheme
                    {
                        Reference = new OpenApiReference
                        {
                            Type = ReferenceType.SecurityScheme,
                            Id = "Bearer"
                        }
                    },
                    new string[] {}
                }
            });
        });
        
        var app = builder.Build();
        
        app.UseStaticFiles(new StaticFileOptions
        {
            FileProvider = new PhysicalFileProvider(
                Path.Combine(builder.Environment.ContentRootPath, "wwwroot")),
            RequestPath = ""
        });
        
        // Configure the HTTP request pipeline
        // if (app.Environment.IsDevelopment())
        // {
            app.UseSwagger();
            app.UseSwaggerUI();
        // }

        app.UseHttpsRedirection();
        app.UseCors("CorsPolicy");

        app.UseAuthentication();
        app.UseAuthorization();

        app.MapControllers();

        app.Run();
    }
}