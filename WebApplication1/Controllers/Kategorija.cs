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
    public class KategorijaController : ControllerBase
    {
        private readonly IKategorijaService _kategorijaService;
        public KategorijaController(ILogger<WeatherForecastController> logger, IKategorijaService kategorijaService)
        {
            _kategorijaService = kategorijaService;
        }

        [HttpGet("{id}")]
        public async Task<Model.Kategorija> GetById(int id)
        {
            return await _kategorijaService.GetById(id);
        }

        [HttpGet]
        public async Task<PagedResult<Model.Kategorija>> Get([FromQuery] Model.SearchObjects.KategorijaSearchObject request)
        {
            return await _kategorijaService.Get(request);
        }
    }
}
