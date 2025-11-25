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

    public virtual ICollection<Donor> Donors { get; set; } = new List<Donor>();

    public virtual ICollection<Komentar> Komentars { get; set; } = new List<Komentar>();

    public virtual ICollection<TakmicarProfil> TakmicarProfils { get; set; } = new List<TakmicarProfil>();

    public virtual Uloga? Uloga { get; set; }
}
