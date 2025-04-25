using Microsoft.AspNetCore.Mvc;
using PodrziMe.Model.Requests;
using PodrziMe.Services;
using WebApplication1.Controllers;

namespace PodrziMe.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TakmicariController : ControllerBase
    {
        private readonly ITakmicariService _takmicariService;
        private readonly ILogger<WeatherForecastController> _logger;
        public TakmicariController(ILogger<WeatherForecastController> logger, ITakmicariService takmicari)
        {
            _logger = logger;
            _takmicariService = takmicari;
        }

        [HttpGet]
        public IList<Model.Kandidat> GetList()
        {
            return _takmicariService.GetList();
        }

        [HttpPost]
        public Model.Kandidat Insert(InsertKandidatRequest request)
        {
            return _takmicariService.Insert(request);
        }
        [HttpPut("{id}")]
        public Model.Kandidat Update(InsertKandidatRequest request)
        {
            return _takmicariService.Insert(request);
        }
    }
}
