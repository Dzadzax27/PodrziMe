using AutoMapper;
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
    public class KomentarService : BaseCRUDService<Model.Komentar, Database.Komentar, KomentarSearchObject, InsertKomentarRequest, UpdateKomentarRequest>, IKomentarService
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }
        public KomentarService(PodrziMeContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
            _dbContext = dbContext;
            Mapper = mapper;
        }

       

        public override IQueryable<Database.Komentar> AddInclude(IQueryable<Database.Komentar> query, KomentarSearchObject? search = null)
        {
            if (search?.isUspjesnaPricaIncluded == true)
            {
                query = query.Include(x => x.UspjesnaPrica);
            }
            if (search?.isKorisnikIncluded == true)
            {
                query = query.Include(x => x.Korisnik);
            }
            return base.AddInclude(query, search);
        }
    }
}
