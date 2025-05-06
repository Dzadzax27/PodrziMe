using System;
using System.Collections.Generic;

namespace PodrziMe.Services.Database;

public partial class UspjesnaPrica
{
    public int UspjesnaPricaId { get; set; }

    public string NaslovPrice { get; set; } = null!;

    public string Prica { get; set; } = null!;

    public int? UkupnaDonacija { get; set; }

    public int? KandidatId { get; set; }

    public virtual Kandidat? Kandidat { get; set; }
}
