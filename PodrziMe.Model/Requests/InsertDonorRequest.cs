using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertDonorRequest
    {
        public string ImePrezime { get; set; } = null!;

        public string? Zanimanje { get; set; }

        public int? UkupnoDonacija { get; set; }

        public DateOnly? DatumRodjenja { get; set; }
    }
}
