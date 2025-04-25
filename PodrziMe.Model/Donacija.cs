using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model
{
    public class Donacija
    {
        public int DonacijaId { get; set; }

        public int KandidatId { get; set; }

        public DateOnly? DatumDonacije { get; set; }

        public int IznosDonacije { get; set; }

        public int? DonorId { get; set; }

        public virtual Donor? Donor { get; set; }

        public virtual Kandidat Kandidat { get; set; } = null!;
    }
}
