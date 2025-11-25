using MimeKit;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Options;
using PodrziMe.Model;

public class EmailService
{
    private readonly EmailSettings _emailSettings;

    public EmailService(IOptions<EmailSettings> emailSettings)
    {
        _emailSettings = emailSettings.Value;
    }

    public async Task SendNewTakmicarEmail(string toEmail, string ime, string prezime, decimal iznos)
    {
        var message = new MimeMessage();
        message.From.Add(new MailboxAddress("PodržiMe", _emailSettings.FromEmail));
        message.To.Add(MailboxAddress.Parse(toEmail));
        message.Subject = "Potvrda o uspjesnoj uplati";

        message.Body = new TextPart("plain")
        {
            Text = $"Takmičaru {ime} {prezime} ste uspjesno uplatili {iznos} KM."
        };

        using var client = new SmtpClient();
        await client.ConnectAsync(_emailSettings.SmtpHost, _emailSettings.SmtpPort, SecureSocketOptions.StartTls);
        await client.AuthenticateAsync(_emailSettings.FromEmail, _emailSettings.AppPassword);
        await client.SendAsync(message);
        await client.DisconnectAsync(true);

        Console.WriteLine($"Email poslan na {toEmail}");
    }
}
