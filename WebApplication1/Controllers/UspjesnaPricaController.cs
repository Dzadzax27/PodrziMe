using Microsoft.AspNetCore.Mvc;
using PodrziMe.Model.Requests;
using PodrziMe.Services;
using WebApplication1.Controllers;

namespace PodrziMe.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UspjesnaPricaController : ControllerBase
    {
        private readonly IUspjesnaPrica _uspjesnaPricaService;
        public UspjesnaPricaController(ILogger<WeatherForecastController> logger, IUspjesnaPrica uspjesnaPrica)
        {
            _uspjesnaPricaService = uspjesnaPrica;
        }

        [HttpGet]
        public IList<Model.UspjesnaPrica> GetList()
        {
            return _uspjesnaPricaService.GetList();
        }

        [HttpPost]
        public Model.UspjesnaPrica Insert(InsertUspjesnaPricaRequest request)
        {
            return _uspjesnaPricaService.Insert(request);
        }

        [HttpPut("{id}")]
        public Model.UspjesnaPrica Update(int id, InsertUspjesnaPricaRequest request)
        {
            return _uspjesnaPricaService.Update(id, request);
        }
    }
}
