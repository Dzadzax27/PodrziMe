using AutoMapper;
using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public class PodKategorijaService : IPodKategorijaService
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }

        public PodKategorijaService(PodrziMeContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            Mapper = mapper;
        }
        public IList<Model.PodKategorija> GetList()
        {
            var podkategorija = _dbContext.PodKategorijas.ToList();
            var result = new List<Model.PodKategorija>();
            result = Mapper.Map(podkategorija, result);

            return result;
        }
        public Model.PodKategorija Insert(InsertPodKategorijaRequest request)
        {
            var podkategorija = new PodKategorija();
            var result = Mapper.Map(request, podkategorija);

            _dbContext.PodKategorijas.Add(result);
            _dbContext.SaveChanges();

            return Mapper.Map<Model.PodKategorija>(result);
        }
        public Model.PodKategorija Update(int id, InsertPodKategorijaRequest request)
        {
            var entity = _dbContext.PodKategorijas.Find(id);

            Mapper.Map(request, entity);

            _dbContext.SaveChanges();

            return Mapper.Map<Model.PodKategorija>(entity);
        }
    }
}
