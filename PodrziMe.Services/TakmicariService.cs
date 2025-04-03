using PodrziMe.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public class TakmicariService : ITakmicariService
    {
        List<Takmicari> takmicari = new List<Takmicari>()
        {
            new Takmicari()
            {
                TakmicarId =1,
                ImePrezime = "Sadzida Dziho"
            }
        };
        public IList<Takmicari> Get()
        {
            return takmicari;
        }
    }
}
