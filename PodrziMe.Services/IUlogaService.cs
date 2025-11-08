using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public interface IUlogaService : IService<Model.Uloga, Model.SearchObjects.NazivSearchObject>
    { }
}
