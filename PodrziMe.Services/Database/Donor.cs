using System;
using System.Collections.Generic;

namespace PodrziMe.Services.Database;

public partial class Donor
{
    public int DonorId { get; set; }

    public string? Zanimanje { get; set; }

    public int? UkupnoDonacija { get; set; }

    public DateOnly? DatumRodjenja { get; set; }

    public string? Ime { get; set; }

    public string? Prezime { get; set; }

    public string? KandidatId { get; set; }

    public virtual ICollection<Donacija> Donacijas { get; set; } = new List<Donacija>();
}
