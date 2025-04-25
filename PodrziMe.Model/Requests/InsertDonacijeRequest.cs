using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertDonacijeRequest
    {
        public int KandidatId { get; set; }
        public DateOnly? DatumDonacije { get; set; }
        public int IznosDonacije { get; set; }
        public int? DonorId { get; set; }
    }
}
