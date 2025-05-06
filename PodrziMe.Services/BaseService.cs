using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PodrziMe.Model;
using PodrziMe.Model.SearchObjects;
using PodrziMe.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public class BaseService<T, TDb, TSearch> :  IService<T, TSearch> where TDb : class where T : class where TSearch : BaseSearchObject 
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }
        public BaseService(PodrziMeContext context, IMapper mapper)
        {
            _dbContext = context;
            Mapper = mapper;
        }

        public virtual async Task<PagedResult<T>> Get(TSearch? search = null)
        {
            var query = _dbContext.Set<TDb>().AsQueryable();

            PagedResult<T> result = new PagedResult<T>();

            query = AddInclude(query, search);

            query = AddFilter(search, query);

            result.Count = await query.CountAsync();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Take(search.PageSize.Value).Skip(search.Page.Value * search.PageSize.Value);
            }

            var list = await query.ToListAsync();


            var tmp = Mapper.Map<List<T>>(list);
            result.Result = tmp;
            return result;
        }

        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual IQueryable<TDb> AddFilter(TSearch? search, IQueryable<TDb> query)
        {
            return query;
        }

        

        public virtual async Task<T> GetById(int id)
        {
            var entity = await _dbContext.Set<TDb>().FindAsync(id);

            return Mapper.Map<T>(entity);
        }
    }
}
