using AutoMapper;
using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PodrziMe.Model;
using PodrziMe.Model.SearchObjects;
using Microsoft.EntityFrameworkCore;
using PodrziMe.Services.Database;

namespace PodrziMe.Services
{
    public class KategorijaService : BaseService<Model.Kategorija,Database.Kategorija, KategorijaSearchObject>, IKategorijaService
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }
        public KategorijaService(PodrziMeContext dbContext, IMapper mapper) : base(dbContext,mapper) {
            _dbContext = dbContext;
            Mapper = mapper;
        }

        public override IQueryable<Database.Kategorija> AddFilter(KategorijaSearchObject? search, IQueryable<Database.Kategorija> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                query = query.Where(x => x.NazivKategorije.StartsWith(search.Ime));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.NazivKategorije.Contains(search.FTS));
            }

            return base.AddFilter(search, query);
        }

        public override IQueryable<Database.Kategorija> AddInclude(IQueryable<Database.Kategorija> query, KategorijaSearchObject? search = null)
        {
            if (search?.isPodKategorijaIncluded == true)
            {
                query = query.Include(x => x.PodKategorija);
            }
            return base.AddInclude(query, search);
        }
    }
}
