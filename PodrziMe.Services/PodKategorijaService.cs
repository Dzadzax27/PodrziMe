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
    public class PodKategorijaService : BaseService<Model.PodKategorija, PodKategorija, Model.SearchObjects.NazivSearchObject>, IPodKategorijaService
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }

        public PodKategorijaService(PodrziMeContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
            _dbContext = dbContext;
            Mapper = mapper;
        }
        public override IQueryable<PodKategorija> AddFilter(NazivSearchObject? search, IQueryable<PodKategorija> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                query = query.Where(x => x.NazivPodKategorije.StartsWith(search.Ime));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.NazivPodKategorije.Contains(search.FTS));
            }

            return base.AddFilter(search, query);
        }
    }
}
