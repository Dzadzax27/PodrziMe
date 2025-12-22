using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class UpdateObavijest
    {
        public string? Sadrzaj { get; set; } = null!;

        public DateTime? DatumKreiranja { get; set; }

        public int? KandidatId { get; set; }

        public bool? hasBeenSeen { get; set; }
    }
}
