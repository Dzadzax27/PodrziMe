using PodrziMe.Model;
using System;
using System.Collections.Generic;

namespace PodrziMe.Model;

public class UspjesnaPrica
{
    public int UspjesnaPricaId { get; set; }

    public string NaslovPrice { get; set; } = null!;

    public string Prica { get; set; } = null!;

    public int? UkupnaDonacija { get; set; }

    public int? KandidatId { get; set; }

    public virtual Kandidat? Kandidat { get; set; }
    public byte[]? Slika { get; set; }

}
