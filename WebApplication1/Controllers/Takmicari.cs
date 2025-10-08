using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PodrziMe.Model;
using PodrziMe.Model.Requests;
using PodrziMe.Model.SearchObjects;
using PodrziMe.Services;
using WebApplication1.Controllers;

namespace PodrziMe.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class TakmicariController : ControllerBase
    {
        private readonly ITakmicariService _takmicariService;
        private readonly ILogger<WeatherForecastController> _logger;
        public TakmicariController(ILogger<WeatherForecastController> logger, ITakmicariService takmicari)
        {
            _logger = logger;
            _takmicariService = takmicari;
        }

        [HttpGet("{id}")]
        public async Task<Model.Kandidat> GetById([FromQuery] int id)
        {
            return await _takmicariService.GetById(id);
        }
        [HttpGet()]
        public async Task<PagedResult<Model.Kandidat>> Get([FromQuery] KandidatiSearchObject? search = null)
        {
            return await _takmicariService.Get(search);
        }
        [Authorize(Roles = "admin")]
        [HttpPost]
        public Task<Model.Kandidat> Insert(InsertKandidatRequest request)
        {
            return _takmicariService.Insert(request);
        }
        [HttpPut("{id}")]
        public Task<Model.Kandidat> Update(int id, UpdateKandidatRequest request)
        {
            return _takmicariService.Update(id, request);
        }
    }
}
