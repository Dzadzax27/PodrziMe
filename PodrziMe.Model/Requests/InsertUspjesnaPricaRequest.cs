using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertUspjesnaPricaRequest
    {
        public string NaslovPrice { get; set; } = null!;

        public string Prica { get; set; } = null!;

        public int? UkupnaDonacija { get; set; }

        public int? KandidatId { get; set; }
    }
}
