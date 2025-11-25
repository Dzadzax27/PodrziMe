using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.SearchObjects
{
    public class KomentarSearchObject : BaseSearchObject
    {
        public bool isUspjesnaPricaIncluded { get; set; }
        public bool isKorisnikIncluded { get; set; }
    }
}
