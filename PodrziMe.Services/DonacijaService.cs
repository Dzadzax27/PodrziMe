using AutoMapper;
using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public class DonacijaService : IDonacijaService
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }

        public DonacijaService(PodrziMeContext dbContext, IMapper mapper)
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

        public Model.Donacija Insert(InsertDonacijeRequest request)
        {
            var donacija = new Donacija();
            var result = Mapper.Map(request, donacija);

            _dbContext.Donacijas.Add(result);
            _dbContext.SaveChanges();

            return Mapper.Map<Model.Donacija>(result);
        }
        public Model.Donacija Update(int id, InsertDonacijeRequest request)
        {
            var entity = _dbContext.Donacijas.Find(id);

            Mapper.Map(request, entity);

            _dbContext.SaveChanges();

            return Mapper.Map<Model.Donacija>(entity);
        }
    }
}
