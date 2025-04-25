using Azure.Core;
using PodrziMe.Model;
using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public interface ITakmicariService
    {
        IList<Model.Kandidat> GetList();
        Model.Kandidat Insert(InsertKandidatRequest request);
        Model.Kandidat Update(int id, InsertKandidatRequest request);
    }
}
