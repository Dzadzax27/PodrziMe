using System;
using System.Collections.Generic;

namespace PodrziMe.Services.Database;

public partial class Obavijest
{
    public int Id { get; set; }

    public string Sadrzaj { get; set; } = null!;

    public DateTime DatumKreiranja { get; set; }

    public int KandidatId { get; set; }

    public virtual Kandidat Kandidat { get; set; } = null!;
}
