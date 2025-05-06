using Microsoft.AspNetCore.Mvc;
using PodrziMe.Model;
using PodrziMe.Model.Requests;
using PodrziMe.Services;
using WebApplication1.Controllers;

namespace PodrziMe.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PodKategorijaController
    {
        private readonly IPodKategorijaService _podkategorijaService;
        public PodKategorijaController(ILogger<WeatherForecastController> logger, IPodKategorijaService podkategorijaService)
        {
            _podkategorijaService = podkategorijaService;
        }

        [HttpGet("{id}")]
        public async Task<Model.PodKategorija> GetById(int id)
        {
            return await _podkategorijaService.GetById(id);
        }

        [HttpGet]
        public async Task<PagedResult<Model.PodKategorija>> Get([FromQuery] Model.SearchObjects.NazivSearchObject request)
        {
            return await _podkategorijaService.Get(request);
        }

    }
}
