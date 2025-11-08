using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PodrziMe.Model.Requests;
using PodrziMe.Model.SearchObjects;
using PodrziMe.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public class KorisnikService :BaseCRUDService<Model.Korisnik,Database.Korisnik,KorisnikSearchObject,InsertKorisnikRequest,UpdateKorisnikRequest>, IKorisnikService
    {
        PodrziMeContext _context;
        IMapper _mapper;
        public KorisnikService(PodrziMeContext context, IMapper mapper) : base(context, mapper)
        {
            _context= context;
            _mapper = mapper;
        }

        public override IQueryable<Database.Korisnik> AddFilter(KorisnikSearchObject? search, IQueryable<Database.Korisnik> query)
        {
            if (!string.IsNullOrWhiteSpace(search?.KorisnickoIme))
            {
                query = query.Where(x => x.KorisnickoIme.StartsWith(search.KorisnickoIme));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.KorisnickoIme.Contains(search.FTS));
            }

            return base.AddFilter(search, query);
        }

        public override void BeforeInsert(InsertKorisnikRequest request, Database.Korisnik entity)
        {
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
            }

            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Lozinka);
            base.BeforeInsert(request, entity);
        }
        public static string GenerateSalt()
        {
            var byteArray = RNGCryptoServiceProvider.GetBytes(16);


            return Convert.ToBase64String(byteArray);
        }
        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public override void BeforeUpdate(UpdateKorisnikRequest request, Database.Korisnik entity)
        {
            base.BeforeUpdate(request, entity);

            

            if (request.Lozinka != null)
            {
                if (request.Lozinka != request.LozinkaPotvrda)
                {
                    throw new Exception("Lozinka i LozinkaPotvrda moraju biti iste");
                }

                entity.LozinkaSalt = GenerateSalt();
                entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Lozinka);
            }
        }
        public async Task<Model.Korisnik> Login(string username, string password)
        {
            var entity = await _context.Korisniks.FirstOrDefaultAsync(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                
                return null;
            }

            return _mapper.Map<Model.Korisnik>(entity);
        }

        public override IQueryable<Database.Korisnik> AddInclude(IQueryable<Database.Korisnik> query,   KorisnikSearchObject? search = null)
        {
            if (search?.isShowingUlogas == true)
            {
                query = query.Include(x => x.Uloga);
            }
            return base.AddInclude(query, search);
        }
    }

}
