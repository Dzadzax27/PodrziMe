using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.SearchObjects
{
    public class KorisnikSearchObject : BaseSearchObject
    {
        public string? KorisnickoIme { get; set; } = null!;
        public string? FTS { get; set; }
        public bool? isShowingUlogas { get; set; }
    }
}
