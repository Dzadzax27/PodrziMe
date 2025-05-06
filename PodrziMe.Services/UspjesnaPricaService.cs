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
    public class UspjesnaPricaService : BaseCRUDService<Model.UspjesnaPrica, UspjesnaPrica, Model.SearchObjects.UspjesnaPricaSearchObject, InsertUspjesnaPricaRequest, UpdateUspjesnaPricaRequest>, IUspjesnaPrica
    {
        public UspjesnaPricaService(PodrziMeContext dbContext, IMapper mapper) :base(dbContext, mapper)
        {
        }

        public override IQueryable<UspjesnaPrica> AddFilter(UspjesnaPricaSearchObject? search, IQueryable<UspjesnaPrica> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                query = query.Where(x => x.NaslovPrice.StartsWith(search.Ime));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.NaslovPrice.Contains(search.FTS));
            }

            return base.AddFilter(search, query);
        }

    }
}
