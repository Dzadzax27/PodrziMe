using System;
using System.Collections.Generic;

namespace PodrziMe.Services;

public partial class Donor
{
    public int DonorId { get; set; }

    public string ImePrezime { get; set; } = null!;

    public string? Zanimanje { get; set; }

    public int? UkupnoDonacija { get; set; }

    public DateOnly? DatumRodjenja { get; set; }

    public virtual ICollection<Donacija> Donacijas { get; set; } = new List<Donacija>();
}
