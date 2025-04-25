using AutoMapper;
using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public class UspjesnaPricaService : IUspjesnaPrica
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }
        public UspjesnaPricaService(PodrziMeContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            Mapper = mapper;
        }

        public IList<Model.UspjesnaPrica> GetList()
        {
            var uspjesnaPrica = _dbContext.UspjesnaPricas.ToList();
            var result = new List<Model.UspjesnaPrica>();
            result = Mapper.Map(uspjesnaPrica, result);

            return result;
        }

        public Model.UspjesnaPrica Insert(InsertUspjesnaPricaRequest request)
        {
            var uspjesnaPrica = new UspjesnaPrica();
            var result = Mapper.Map(request, uspjesnaPrica);

            _dbContext.UspjesnaPricas.Add(result);
            _dbContext.SaveChanges();

            return Mapper.Map<Model.UspjesnaPrica>(result);
        }

        public Model.UspjesnaPrica Update(int id, InsertUspjesnaPricaRequest request)
        {
            var entity = _dbContext.UspjesnaPricas.Find(id);

            Mapper.Map(request, entity);

            _dbContext.SaveChanges();

            return Mapper.Map<Model.UspjesnaPrica>(entity);
        }
    }
}
