using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class UpdateKorisnikRequest
    {
        public string? Telefon { get; set; }

        public string? Lozinka { get; set; }
        public string? LozinkaPotvrda { get; set; }
        public string? KorisnickoIme { get; set; } = null!;

        public bool? Status { get; set; }
        public string? Email { get; set; }

        public bool? odobren { get; set; }

    }
}
