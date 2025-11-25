using AutoMapper;
using EasyNetQ;
using Microsoft.EntityFrameworkCore;
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
    public class ObavijestService : BaseCRUDService<Model.Obavijest, Database.Obavijest, ObavijestSearchObject
        , InsertObavijestRequest, UpdateKandidatRequest>, IObavijestService
    {
        PodrziMeContext _context;
        IMapper _mapper;
        public ObavijestService(PodrziMeContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public override IQueryable<Database.Obavijest> AddInclude(IQueryable<Database.Obavijest> query, ObavijestSearchObject? search = null)
        {
            if (search?.isKandidatIncluded == true)
            {
                query = query.Include(x => x.Kandidat);
            }
            return base.AddInclude(query, search);
        }
    }

}
