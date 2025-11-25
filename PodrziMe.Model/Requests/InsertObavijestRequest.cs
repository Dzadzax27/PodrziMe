using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertObavijestRequest
    {
        public int KorisnikId { get; set; }

        public string Sadrzaj { get; set; } = null!;

        public DateTime DatumKreiranja { get; set; }
    }
}
