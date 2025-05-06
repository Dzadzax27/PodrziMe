using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
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
    public class DonacijaService : 
        BaseCRUDService<Model.Donacija,Donacija, Model.SearchObjects.DonacijaSearchObject, InsertDonacijeRequest, InsertDonacijeRequest>, IDonacijaService 
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }

        public DonacijaService(PodrziMeContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
            _dbContext = dbContext;
            Mapper = mapper;
        }
        public IList<Model.Donacija> GetList()
        {
            var donacije = _dbContext.Donacijas.ToList();
            var result = new List<Model.Donacija>();
            result = Mapper.Map(donacije, result);

            return result;
        }

        public override IQueryable<Donacija> AddInclude(IQueryable<Donacija> query, DonacijaSearchObject? search = null)
        {
            if (search?.isDonorIncluded == true)
            {
                query = query.Include(x => x.Donor);
            }
            if (search?.isKandidatIncluded == true)
            {
                query = query.Include(x => x.Kandidat);
            }
            return base.AddInclude(query, search);
        }
    }
}
