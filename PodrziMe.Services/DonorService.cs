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
    public class DonorService : BaseCRUDService<Model.Donor, Database.Donor, Model.SearchObjects.DonorSearchObject, InsertDonorRequest, UpdateDonorRequest>, IDonorService
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }
        public DonorService(PodrziMeContext dbContext, IMapper mapper) :base(dbContext, mapper)
        {
            _dbContext = dbContext;
            Mapper = mapper;
        }

        public override IQueryable<Donor> AddFilter(DonorSearchObject? search, IQueryable<Donor> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                query = query.Where(x =>
                    x.Ime.Contains(search.Ime) || x.Prezime.Contains(search.Ime)
                );
            }


            return base.AddFilter(search, query);
        }

    }
}
