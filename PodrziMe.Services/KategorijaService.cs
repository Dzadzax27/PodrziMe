using AutoMapper;
using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PodrziMe.Model;

namespace PodrziMe.Services
{
    public class KategorijaService : IKategorijaService
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }
        public KategorijaService(PodrziMeContext dbContext, IMapper mapper) {
            _dbContext = dbContext;
            Mapper = mapper;
        }

        public IList<Model.Kategorija> GetList()
        {
            var kategorija = _dbContext.Kategorijas.ToList();
            var result = new List<Model.Kategorija>();
            result = Mapper.Map(kategorija, result);

            return result;
        }

        public Model.Kategorija Insert(InsertKategorijaRequest request)
        {
            var kategorija = new Kategorija();
            var result = Mapper.Map(request, kategorija);

            _dbContext.Kategorijas.Add(result);
            _dbContext.SaveChanges();

            return Mapper.Map<Model.Kategorija>(result);
        }

        public Model.Kategorija Update(int id, InsertKategorijaRequest request)
        {
            var entity = _dbContext.Kategorijas.Find(id);

            Mapper.Map(request, entity);

            _dbContext.SaveChanges();

            return Mapper.Map<Model.Kategorija>(entity);
        }
    }
}
