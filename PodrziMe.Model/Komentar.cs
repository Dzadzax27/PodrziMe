using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model
{
    public partial class Komentar
    {
        public int KomentarId { get; set; }

        public int? KorisnikId { get; set; }

        public int UspjesnaPricaId { get; set; }

        public string Komentar1 { get; set; } = null!;

        public virtual Korisnik? Korisnik { get; set; }

        public virtual UspjesnaPrica UspjesnaPrica { get; set; } = null!;
    }
}
