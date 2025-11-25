using EasyNetQ;
using Microsoft.EntityFrameworkCore;
using PodrziMe.Model;
using PodrziMe.Services;
using PodrziMe.Services.Database;
using Obavijest = PodrziMe.Model.Obavijest;

public class CallRabbitMqAndCreateNotification
{
    private readonly PodrziMeContext _context;
    private readonly IBus _bus;

    public CallRabbitMqAndCreateNotification(PodrziMeContext context)
    {
        _context = context;
        _bus = RabbitHutch.CreateBus("host=localhost");
    }

    public async Task SendNotificationAndCreateInDatabase(PodrziMe.Model.Donacija response)
    {
        // 1) Kreiramo sadrzaj poruke
        string messageText = $"Donirano je {response.IznosDonacije} KM";

        // 2) Upis u bazu (Obavijest)
       
        var donor = await _context.Donors
                        .FirstOrDefaultAsync(x => x.DonorId == response.DonorId);
        var korisnik = await _context.Korisniks.FirstOrDefaultAsync(x => x.KorisnikId == donor.KorisnikId);

        var emailToSend = korisnik?.Email;

        var kandidat = await _context.Kandidats.FirstOrDefaultAsync(x => x.KandidatId == response.KandidatId);

        var kandidatName = kandidat.Ime;
        var kandidatPrezime = kandidat.Prezime;

        var obavijestZaEmaileService = new DTOKandidatDonacijaObavijest
        {
            KandidatIme = kandidatName,
            KandidatPrezime = kandidatPrezime,
            toEmail = emailToSend,
            Donacija = response.IznosDonacije,
        };

        // 3) Slanje preko RabbitMQ
        await _bus.PubSub.PublishAsync(obavijestZaEmaileService);

        Console.WriteLine("Message sent to RabbitMQ!");
    }
}