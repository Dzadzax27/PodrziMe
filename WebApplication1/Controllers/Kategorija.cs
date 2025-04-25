using Microsoft.AspNetCore.Mvc;
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

        [HttpGet]
        public IList<Model.Kategorija> GetList()
        {
            return _kategorijaService.GetList();
        }

        [HttpPost]
        public Model.Kategorija Insert(InsertKategorijaRequest request)
        {
            return _kategorijaService.Insert(request);
        }

        [HttpPut("{id}")]
        public Model.Kategorija Update(int id, InsertKategorijaRequest request)
        {
            return _kategorijaService.Update(id, request);
        }

    }
}
