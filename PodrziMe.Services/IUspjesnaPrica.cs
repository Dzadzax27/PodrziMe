using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public interface IUspjesnaPrica
    {
        IList<Model.UspjesnaPrica> GetList();
        Model.UspjesnaPrica Insert(InsertUspjesnaPricaRequest request);
        Model.UspjesnaPrica Update(int id, InsertUspjesnaPricaRequest request);
    }
}
