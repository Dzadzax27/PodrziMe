using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PodrziMe.Model;
using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public class TakmicariService : ITakmicariService
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }

        public TakmicariService(PodrziMeContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            Mapper = mapper;
        }
        public IList<Model.Kandidat> GetList()
        {
            var kandidati = _dbContext.Kandidats.ToList();
            var result = new List<Model.Kandidat>();
            result = Mapper.Map(kandidati, result);

            return result;
        }

        public Model.Kandidat Insert(InsertKandidatRequest request)
        {
            var kandidat = new Kandidat();
            var result = Mapper.Map(request, kandidat);

            _dbContext.Kandidats.Add(result);
            _dbContext.SaveChanges();

            return Mapper.Map<Model.Kandidat>(result);
        }

        public Model.Kandidat Update(int id, InsertKandidatRequest request)
        {
            var entity = _dbContext.Kandidats.Find(id);

            Mapper.Map(request, entity);

            _dbContext.SaveChanges();

            return Mapper.Map<Model.Kandidat>(entity);
        }
    }
}
