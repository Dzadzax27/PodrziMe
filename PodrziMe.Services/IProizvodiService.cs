using PodrziMe.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public interface ITakmicariService
    {
        IList<Takmicari> Get();
    }
}
