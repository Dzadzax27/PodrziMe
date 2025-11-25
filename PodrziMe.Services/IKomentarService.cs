using PodrziMe.Model.Requests;
using PodrziMe.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public interface IKomentarService :  ICRUDService<Model.Komentar, KomentarSearchObject, InsertKomentarRequest, UpdateKomentarRequest>
    { }
}
