using Microsoft.AspNetCore.Mvc;
using PodrziMe.Model.Requests;
using PodrziMe.Model.SearchObjects;
using PodrziMe.Model;
using PodrziMe.Services;
using WebApplication1.Controllers;
using Microsoft.AspNetCore.Authorization;

namespace PodrziMe.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisnikConrtoller
    {
        private readonly IKorisnikService _takmicariService;
        private readonly ILogger<WeatherForecastController> _logger;
        public KorisnikConrtoller(ILogger<WeatherForecastController> logger, IKorisnikService korisnik)
        {
            _logger = logger;
            _takmicariService = korisnik;
        }

        [HttpGet("{id}")]
        public async Task<Model.Korisnik> GetById([FromQuery] int id)
        {
            return await _takmicariService.GetById(id);
        }
        [HttpGet()]
        public async Task<PagedResult<Model.Korisnik>> Get([FromQuery] KorisnikSearchObject? search = null)
        {
            return await _takmicariService.Get(search);
        }

        [HttpPost]
        [AllowAnonymous]
        public Task<Model.Korisnik> Insert(InsertKorisnikRequest request)
        {
            return _takmicariService.Insert(request);
        }
        [HttpPut("{id}")]
        public Task<Model.Korisnik> Update(int id, UpdateKorisnikRequest request)
        {
            return _takmicariService.Update(id, request);
        }
    }
}
