using Microsoft.AspNetCore.Mvc;
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

        [HttpGet]
        public IList<Model.PodKategorija> GetList()
        {
            return _podkategorijaService.GetList();
        }

        [HttpPost]
        public Model.PodKategorija Insert(InsertPodKategorijaRequest request)
        {
            return _podkategorijaService.Insert(request);
        }
        [HttpPut("{id}")]
        public Model.PodKategorija Update(InsertPodKategorijaRequest request)
        {
            return _podkategorijaService.Insert(request);
        }
    }
}
