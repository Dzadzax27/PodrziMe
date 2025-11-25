using PodrziMe.Model.Requests;
using PodrziMe.Model.SearchObjects;
using PodrziMe.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public interface IKorisnikService :ICRUDService<Model.Korisnik,KorisnikSearchObject,InsertKorisnikRequest,UpdateKorisnikProfil>
    {
        public Task<Model.Korisnik> Login(string username, string password);
    }
}
