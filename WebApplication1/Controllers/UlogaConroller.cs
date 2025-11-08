using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PodrziMe.Model;
using PodrziMe.Model.Requests;
using PodrziMe.Services;
using WebApplication1.Controllers;

namespace PodrziMe.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class UlogaConroller
    {
        private readonly IUlogaService _ulogaService;
        public UlogaConroller(ILogger<WeatherForecastController> logger, IUlogaService ulogaService)
        {
            _ulogaService = ulogaService;
        }

        [HttpGet]
        [AllowAnonymous]
        public async Task<PagedResult<Model.Uloga>> Get([FromQuery] Model.SearchObjects.NazivSearchObject request)
        {
            return await _ulogaService.Get(request);
        }

    }
}
