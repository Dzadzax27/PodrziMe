using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertKorisnikRequest
    {
        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public string KorisnickoIme { get; set; } = null!;

        public string Lozinka { get; set; }
        public string LozinkaPotvrda { get; set; }

        public bool? Status { get; set; }

        public int? UlogaId { get; set; }
    }
}
