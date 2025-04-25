using AutoMapper;
using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public class DonorService : IDonorService
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }
        public DonorService(PodrziMeContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            Mapper = mapper;
        }

        public IList<Model.Donor> GetList()
        {
            var donor = _dbContext.Donors.ToList();
            var result = new List<Model.Donor>();
            result = Mapper.Map(donor, result);

            return result;
        }

        public Model.Donor Insert(InsertDonorRequest request)
        {
            var donor = new Donor();
            var result = Mapper.Map(request, donor);

            _dbContext.Donors.Add(result);
            _dbContext.SaveChanges();

            return Mapper.Map<Model.Donor>(result);
        }

        public Model.Donor Update(int id, InsertDonorRequest request)
        {
            var entity = _dbContext.Donors.Find(id);

            Mapper.Map(request, entity);

            _dbContext.SaveChanges();

            return Mapper.Map<Model.Donor>(entity);
        }
    }
}
