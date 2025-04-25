using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using PodrziMe;
using PodrziMe.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<ITakmicariService,TakmicariService>();
builder.Services.AddTransient<IKategorijaService, KategorijaService>();
builder.Services.AddTransient<IPodKategorijaService, PodKategorijaService>();
builder.Services.AddTransient<IDonacijaService, DonacijaService>();
builder.Services.AddTransient<IDonorService, DonorService>();
builder.Services.AddTransient<IUspjesnaPrica, UspjesnaPricaService>();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();


var connectionString = builder.Configuration.GetConnectionString("ePodrziMeConnection");
builder.Services.AddDbContext<PodrziMeContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(ITakmicariService));

var app = builder.Build();


// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
