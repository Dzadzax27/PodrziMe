using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PodrziMe.Model;

namespace PodrziMe.Services
{
    public interface IKategorijaService : IService<Model.Kategorija,Model.SearchObjects.KategorijaSearchObject>
    { }
}
