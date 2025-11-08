using System;
using System.Collections.Generic;

namespace PodrziMe.Services.Database;

public partial class TakmicarProfil
{
    public int TakmicarProfilId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public DateOnly DatumRodjenja { get; set; }

    public int KorisnikId { get; set; }

    public virtual ICollection<Kandidat> Kandidats { get; set; } = new List<Kandidat>();

    public virtual Korisnik Korisnik { get; set; } = null!;
}
