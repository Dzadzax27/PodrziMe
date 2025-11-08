using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using PodrziMe;
using PodrziMe.Filters;
using PodrziMe.Services;
using PodrziMe.Services.Database;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<ITakmicariService,TakmicariService>();
builder.Services.AddTransient<IKategorijaService, KategorijaService>();
builder.Services.AddTransient<IPodKategorijaService, PodKategorijaService>();
builder.Services.AddTransient<IDonacijaService, DonacijaService>();
builder.Services.AddTransient<IDonorService, DonorService>();
builder.Services.AddTransient<IUspjesnaPrica, UspjesnaPricaService>();
builder.Services.AddTransient<IKorisnikService, KorisnikService>();
builder.Services.AddTransient<IUlogaService, UlogaService>();
builder.Services.AddTransient<ITakmicarProfilService, TakmicarProfilService>();

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilter>();
});

builder.Services.AddHttpClient();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
     {
         {
             new OpenApiSecurityScheme
             {
                 Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
             },
             new string[]{}
     } });

});


var connectionString = builder.Configuration.GetConnectionString("ePodrziMeConnection");
builder.Services.AddDbContext<PodrziMe.Services.Database.PodrziMeContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(ITakmicariService));
builder.Services.AddAuthentication("BasicAuthentication")
     .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);


var app = builder.Build();


// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
