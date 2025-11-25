using AutoMapper;
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
    public class TakmicarProfilService : BaseCRUDService<Model.TakmicarProfil, Database.TakmicarProfil, Model.SearchObjects.NazivSearchObject, InsertTakmicarProfilRequest, UpdateTakmicarProfilRequest>, ITakmicarProfilService
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }
        public TakmicarProfilService(PodrziMeContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
            _dbContext = dbContext;
            Mapper = mapper;
        }


        public override IQueryable<TakmicarProfil> AddFilter(NazivSearchObject? search, IQueryable<TakmicarProfil> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                query = query.Where(x => x.Ime.StartsWith(search.Ime));
            }

            return base.AddFilter(search, query);
        }

    }
}
