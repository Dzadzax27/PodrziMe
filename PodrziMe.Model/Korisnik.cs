using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model
{
    public class Korisnik
    {
        public int KorisnikId { get; set; }

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public string KorisnickoIme { get; set; } = null!;

        public bool? Status { get; set; }

        public int? UlogaId { get; set; }

        public virtual Uloga? Uloga { get; set; }

    }
}
