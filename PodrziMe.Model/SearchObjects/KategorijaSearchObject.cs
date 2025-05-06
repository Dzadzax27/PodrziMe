using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.SearchObjects
{
    public class KategorijaSearchObject : BaseSearchObject
    {
        public string? Ime { get; set; }
        public string? FTS { get; set; }
        public bool? isPodKategorijaIncluded { get; set; }
    }
}
