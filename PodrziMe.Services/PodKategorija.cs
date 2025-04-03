using System;
using System.Collections.Generic;

namespace PodrziMe.Services;

public partial class PodKategorija
{
    public int PodKategorijaId { get; set; }

    public string NazivPodKategorije { get; set; } = null!;

    public virtual ICollection<Kategorija> Kategorijas { get; set; } = new List<Kategorija>();
}
