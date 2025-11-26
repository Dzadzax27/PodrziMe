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

// 3) Kreiraj RabbitMQ bus s retry logikom
IBus bus = null;
int busRetries = 10;
for (int i = 0; i < busRetries; i++)
{
    try
    {
        bus = RabbitHutch.CreateBus("host=podrzime-rabbitmq;username=guest;password=guest");
        Console.WriteLine("Connected to RabbitMQ.");
        break;
    }
    catch
    {
        Console.WriteLine($"RabbitMQ not ready ({i + 1}/{busRetries}). Retrying in 3s...");
        Thread.Sleep(3000);
    }
}

if (bus == null)
{
    Console.WriteLine("Failed to connect to RabbitMQ. Exiting.");
    return;
}

// 4) Retry loop za subscribe (sprečava TaskCanceledException)
int subscribeRetries = 10;
for (int i = 0; i < subscribeRetries; i++)
{
    try
    {
        // Simple string subscription
        bus.PubSub.Subscribe<string>("hello_sub", msg =>
        {
            Console.WriteLine("Received: " + msg);
        });

        // DTO subscription s email logikom
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

                await emailService.SendNewTakmicarEmail(toEmail, ime, prezime, iznos);
                Console.WriteLine("Email uspješno poslan!");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Greška pri slanju emaila: {ex.Message}");
            }
        });

        Console.WriteLine("Subscribed successfully.");
        break; // Ako subscribe prođe, izlazi iz loop-a
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Subscribe failed ({i + 1}/{subscribeRetries}), retrying in 3s: {ex.Message}");
        Thread.Sleep(3000);

    }
}

Console.WriteLine("Subscriber aktivan. Pritiskom na CTRL+C izlazite.");
await Task.Delay(-1);
