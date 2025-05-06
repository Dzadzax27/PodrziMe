using System;
using System.Collections.Generic;

namespace PodrziMe.Services.Database;

public partial class Donacija
{
    public int DonacijaId { get; set; }

    public int KandidatId { get; set; }

    public DateOnly? DatumDonacije { get; set; }

    public int IznosDonacije { get; set; }

    public int? DonorId { get; set; }

    public virtual Donor? Donor { get; set; }

    public virtual Kandidat Kandidat { get; set; } = null!;
}
