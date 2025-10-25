using System;
using System.Collections.Generic;

namespace PodrziMe.Services.Database;

public partial class Uloga
{
    public int UlogaId { get; set; }

    public string NazivUloge { get; set; } = null!;

    public virtual ICollection<Korisnik> Korisniks { get; set; } = new List<Korisnik>();
}
