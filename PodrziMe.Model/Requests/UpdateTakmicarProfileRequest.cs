using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class UpdateTakmicarProfilRequest
    {
        public string? Ime { get; set; } = null!;

        public string? Prezime { get; set; } = null!;

        public DateOnly? DatumRodjenja { get; set; }

        public int? KorisnikId { get; set; }

        public virtual Korisnik? Korisnik { get; set; } = null!;
        public List<int>? KandidatProfilIds { get; set; }

    }
}
