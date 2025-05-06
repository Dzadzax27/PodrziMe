using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PodrziMe.Model;
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
    public class TakmicariService : BaseCRUDService<Model.Kandidat, Database.Kandidat, Model.SearchObjects.KandidatiSearchObject, InsertKandidatRequest, UpdateKandidatRequest>, ITakmicariService
    {

        public TakmicariService(PodrziMeContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {}

        public override IQueryable<Database.Kandidat> AddFilter(KandidatiSearchObject? search, IQueryable<Database.Kandidat> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                query = query.Where(x => x.Ime.StartsWith(search.Ime));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.Ime.Contains(search.FTS));
            }

            return base.AddFilter(search, query);
        }

        public override IQueryable<Database.Kandidat> AddInclude(IQueryable<Database.Kandidat> query, KandidatiSearchObject? search = null)
        {
            if (search?.isKategorijaIncluded == true)
            {
                query = query.Include(x => x.Kategorija);
            }
            return base.AddInclude(query, search);
        }
    }
}
