using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertKategorijaRequest
    {
        public string NazivKategorije { get; set; } = null!;

        public int? PodKategorijaId { get; set; }
    }
}
