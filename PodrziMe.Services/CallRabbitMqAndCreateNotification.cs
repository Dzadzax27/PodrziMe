using EasyNetQ;
using Microsoft.EntityFrameworkCore;
using PodrziMe.Model;
using PodrziMe.Model.Requests;
using PodrziMe.Services;
using PodrziMe.Services.Database;
using Obavijest = PodrziMe.Model.Obavijest;

public class CallRabbitMqAndCreateNotification
{
    private readonly PodrziMeContext _context;
    private readonly IBus _bus;
    private IObavijestService _obavijestService;

    public CallRabbitMqAndCreateNotification(PodrziMeContext context,IObavijestService obavijestService)
    {
        _context = context;
        _bus = RabbitHutch.CreateBus("host=podrzime-rabbitmq;username=guest;password=guest");
        _obavijestService = obavijestService;
    }

    public async Task SendNotificationAndCreateInDatabase(PodrziMe.Model.Donacija response)
    {
        // 1) Kreiramo sadrzaj poruke

        // 2) Upis u bazu (Obavijest)
       
        var donor = await _context.Donors
                        .FirstOrDefaultAsync(x => x.DonorId == response.DonorId);
        var korisnik = await _context.Korisniks.FirstOrDefaultAsync(x => x.KorisnikId == donor.KorisnikId);

        var emailToSend = korisnik?.Email;

        var kandidat = await _context.Kandidats.FirstOrDefaultAsync(x => x.KandidatId == response.KandidatId);

        if (kandidat == null)
            throw new Exception("Kandidat not found!");


        string messageText = $"Donirano je {response.IznosDonacije} KM za kandidata {kandidat.Ime} {kandidat.Prezime}";

        // 3) Kreiranje obavijesti u bazi
        var obavijest = new InsertObavijestRequest
        {
            KandidatId = kandidat.KandidatId,
            Sadrzaj = messageText,
            DatumKreiranja = DateTime.Now
        };

        await _obavijestService.Insert(obavijest);

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