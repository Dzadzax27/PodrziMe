using System;
using System.Collections.Generic;

namespace PodrziMe.Services;

public partial class Kategorija
{
    public int KategorijaId { get; set; }

    public string NazivKategorije { get; set; } = null!;

    public int? PodKategorijaId { get; set; }

    public virtual ICollection<Kandidat> Kandidats { get; set; } = new List<Kandidat>();

    public virtual PodKategorija? PodKategorija { get; set; }
}
