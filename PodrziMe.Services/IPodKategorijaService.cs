using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public interface IPodKategorijaService
    {
        IList<Model.PodKategorija> GetList();
        Model.PodKategorija Insert(InsertPodKategorijaRequest request);
        Model.PodKategorija Update(int id, InsertPodKategorijaRequest request);
    }
}
