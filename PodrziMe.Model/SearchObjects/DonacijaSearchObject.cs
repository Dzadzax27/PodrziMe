using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.SearchObjects
{
    public class DonacijaSearchObject : BaseSearchObject
    {
        public bool? isDonorIncluded { get; set; }
        public bool? isKandidatIncluded { get; set; }
    }
}
