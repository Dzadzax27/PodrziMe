using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public interface IDonorService
    {
        IList<Model.Donor> GetList();
        Model.Donor Insert(InsertDonorRequest request);
        Model.Donor Update(int id, InsertDonorRequest request);

    }
}
