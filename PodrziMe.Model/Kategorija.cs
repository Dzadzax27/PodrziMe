using System;
using System.Collections.Generic;

namespace PodrziMe.Model { 
    public class Kategorija
    {
        public int KategorijaId { get; set; }

        public string NazivKategorije { get; set; } = null!;

        public int? PodKategorijaId { get; set; }

        public virtual PodKategorija? PodKategorija { get; set; }
    }
}
