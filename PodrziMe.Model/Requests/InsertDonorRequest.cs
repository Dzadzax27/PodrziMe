using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertDonorRequest
    {
        [Required]
        public string Ime { get; set; } = null!;
        [Required]
        public string Prezime { get; set; } = null!;
        [Required]
        public string? Zanimanje { get; set; }

        public int? UkupnoDonacija { get; set; }
        [Required]
        public DateOnly? DatumRodjenja { get; set; }
    }
}
