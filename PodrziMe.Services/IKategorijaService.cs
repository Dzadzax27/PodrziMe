using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PodrziMe.Model;

namespace PodrziMe.Services
{
    public interface IKategorijaService 
    {
        IList<Model.Kategorija> GetList();
        Model.Kategorija Insert(InsertKategorijaRequest request);
        Model.Kategorija Update(int id, InsertKategorijaRequest request);
    }
}
