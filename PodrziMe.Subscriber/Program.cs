using EasyNetQ;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using PodrziMe.Model;
using PodrziMe.Services;

Console.WriteLine("Subscriber started. Listening for messages...");

// 1) Učitaj konfiguraciju iz JSON
var configuration = new ConfigurationBuilder()
    .SetBasePath(AppContext.BaseDirectory)
    .AddJsonFile("appsettings.json", optional: false)
    .Build();

// 2) Kreiraj EmailService samo jednom
var emailSettings = configuration.GetSection("EmailSettings").Get<EmailSettings>();
var options = Options.Create(emailSettings);

var emailService = new EmailService(options);

// 3) Kreiraj RabbitMQ bus
using var bus = RabbitHutch.CreateBus("host=localhost");

// 4) Subscribe na queue
bus.PubSub.Subscribe<DTOKandidatDonacijaObavijest>("donacija_notification_queue", async msg =>
{
    Console.WriteLine($"Primljena donacija za: {msg.toEmail}, Iznos: {msg.Donacija} KM");

    try
    {
        Console.WriteLine("Loaded Email Settings:");
        Console.WriteLine($"FromEmail: {options.Value.FromEmail}");
        Console.WriteLine($"Password: {options.Value.AppPassword}");
        Console.WriteLine($"SmtpServer: {options.Value.SmtpHost}");
        Console.WriteLine($"Port: {options.Value.SmtpPort}");

        string ime = msg.KandidatIme;
        string prezime = msg.KandidatPrezime;
        string toEmail = msg.toEmail;
        decimal iznos = msg.Donacija;

        // Slanje personalizovanog emaila
        await emailService.SendNewTakmicarEmail(toEmail, ime, prezime, iznos);

        Console.WriteLine("Email uspješno poslan!");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Greška pri slanju emaila: {ex.Message}");
    }
});

// 5) Drži aplikaciju aktivnom
Console.WriteLine("Subscriber aktivan. Pritiskom na CTRL+C izlazite.");
await Task.Delay(-1);
