using AutoMapper;
using Azure.Core;
using Microsoft.EntityFrameworkCore;
using PodrziMe.Model;
using PodrziMe.Model.SearchObjects;
using PodrziMe.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace PodrziMe.Services
{
    public class BaseCRUDService<T, TDb, TSearch, TInsert, TUpdate> : BaseService<T, TDb, TSearch> where TDb : class where T : class where TSearch : BaseSearchObject
    {
        PodrziMeContext _dbContext;
        public IMapper Mapper { get; set; }
        public BaseCRUDService(PodrziMeContext context, IMapper mapper) : base(context, mapper)
        {
            _dbContext = context;
            Mapper = mapper;
        }
        public virtual async Task<T> Insert(TInsert insert)
        {
            //try
            //{
                var set = _dbContext.Set<TDb>();

                TDb entity = Mapper.Map<TDb>(insert);
                BeforeInsert(insert, entity);

                set.Add(entity);

                await _dbContext.SaveChangesAsync();
                return Mapper.Map<T>(entity);
            //} catch {
            //    throw new Model.UserException("Pogresan request");
            //}
        }
        public virtual void BeforeInsert(TInsert request, TDb entity) { }

        public virtual void BeforeUpdate(TUpdate request, TDb entity) { }

        public virtual async Task<T> Update(int id, TUpdate update)
        {
            var set = _dbContext.Set<TDb>();
            var entity = await set.FindAsync(id);

            Mapper.Map(update, entity);

            await _dbContext.SaveChangesAsync();
            return Mapper.Map<T>(entity);
        }

        public virtual async Task<bool> Delete(int id)
        {
            var set = _dbContext.Set<TDb>();
            var entity = await set.FindAsync(id); 

            if (entity == null)
                return false;

            set.Remove(entity); 
            await _dbContext.SaveChangesAsync();

            return true; 
        }

    }
}
