using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertKategorijaRequest
    {
        [Required]
        public string NazivKategorije { get; set; } = null!;
        [Required]
        public int? PodKategorijaId { get; set; }
    }
}
