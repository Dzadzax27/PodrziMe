using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.SearchObjects
{
    public class UspjesnaPricaSearchObject : BaseSearchObject
    {
        public string? Ime { get; set; }
        public string? FTS { get; set; }
        public bool? isUspjesnaPrica { get; set; }
    }
}
