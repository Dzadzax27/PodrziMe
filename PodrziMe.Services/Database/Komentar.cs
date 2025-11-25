using System;
using System.Collections.Generic;

namespace PodrziMe.Services.Database;

public partial class Komentar
{
    public int KomentarId { get; set; }

    public int? KorisnikId { get; set; }

    public int UspjesnaPricaId { get; set; }

    public string Komentar1 { get; set; } = null!;

    public virtual Korisnik? Korisnik { get; set; }

    public virtual UspjesnaPrica UspjesnaPrica { get; set; } = null!;
}
