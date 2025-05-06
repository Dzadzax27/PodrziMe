using System;
using System.Collections.Generic;

namespace PodrziMe.Services.Database;

public partial class Korisnik
{
    public int KorisnikId { get; set; }

    public string? Email { get; set; }

    public string? Telefon { get; set; }

    public string KorisnickoIme { get; set; } = null!;

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public bool? Status { get; set; }

    public int? UlogaId { get; set; }

    public virtual Uloga? Uloga { get; set; }
}
