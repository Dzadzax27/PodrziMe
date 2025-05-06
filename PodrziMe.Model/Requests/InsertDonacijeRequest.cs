using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertDonacijeRequest
    {
        [Required]
        public DateOnly DatumDonacije { get; set; }
        [Required]
        [Range(0,10000)]
        public int IznosDonacije { get; set; }
        public int? DonorId { get; set; }
    }
}
