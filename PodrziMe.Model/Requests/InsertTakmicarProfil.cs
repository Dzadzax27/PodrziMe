using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertTakmicarProfilRequest
    {

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public DateOnly DatumRodjenja { get; set; }

        public int KorisnikId { get; set; }

        public int? TakmicarProfilId { get; set; }
    }

}
