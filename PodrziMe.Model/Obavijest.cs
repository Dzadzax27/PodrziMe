using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model
{
    public class Obavijest
    {
        public int Id { get; set; }

        public string Sadrzaj { get; set; } = null!;

        public DateTime DatumKreiranja { get; set; }

        public int KandidatId { get; set; }

        public virtual Kandidat Kandidat { get; set; } = null!;
    }
}
