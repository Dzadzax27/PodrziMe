using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.SearchObjects
{
    public class KandidatiSearchObject : BaseSearchObject
    {
        public string? Ime { get; set; }
        public string? FTS { get; set; }
        public bool? isKategorijaIncluded { get; set; }
    }
}
