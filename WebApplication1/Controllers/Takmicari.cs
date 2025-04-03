using Microsoft.AspNetCore.Mvc;
using PodrziMe.Model;
using PodrziMe.Services;

namespace WebApplication1.Controllers
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

        [HttpGet()]
        public IEnumerable<Takmicari> Get()
        {
            return _takmicariService.Get();
        }
    }
}
