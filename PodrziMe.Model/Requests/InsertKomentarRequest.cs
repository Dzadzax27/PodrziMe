using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertKomentarRequest
    {
        public int? KorisnikId { get; set; }

        public int UspjesnaPricaId { get; set; }

        public string Komentar1 { get; set; } = null!;
    }
}
