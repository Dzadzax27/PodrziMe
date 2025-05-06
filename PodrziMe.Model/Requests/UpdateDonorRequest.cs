using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class UpdateDonorRequest
    {
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;

        public string? Zanimanje { get; set; }
    }
}
