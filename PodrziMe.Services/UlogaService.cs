using AutoMapper;
using PodrziMe.Model.SearchObjects;
using PodrziMe.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public class UlogaService : BaseService<Model.Uloga, Uloga, Model.SearchObjects.NazivSearchObject>, IUlogaService
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }

        public UlogaService(PodrziMeContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
            _dbContext = dbContext;
            Mapper = mapper;
        }
    }
}
