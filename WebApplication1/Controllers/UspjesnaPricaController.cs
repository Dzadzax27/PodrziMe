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
    public class UspjesnaPricaController : ControllerBase
    {
        private readonly IUspjesnaPrica _uspjesnaPricaService;
        public UspjesnaPricaController(ILogger<WeatherForecastController> logger, IUspjesnaPrica uspjesnaPrica)
        {
            _uspjesnaPricaService = uspjesnaPrica;
        }

        [HttpGet("{id}")]
        [AllowAnonymous]
        public async Task<Model.UspjesnaPrica> GetById(int id)
        {
            return await _uspjesnaPricaService.GetById(id);
        }

        [HttpGet]
        [AllowAnonymous]
        public async Task<PagedResult<Model.UspjesnaPrica>> Get([FromQuery] Model.SearchObjects.UspjesnaPricaSearchObject request)
        {
            return await _uspjesnaPricaService.Get(request);
        }

        [HttpPost]
        public Task<Model.UspjesnaPrica> Insert(InsertUspjesnaPricaRequest request)
        {
            return _uspjesnaPricaService.Insert(request);
        }

        [HttpPut("{id}")]
        public Task<Model.UspjesnaPrica> Update(int id, UpdateUspjesnaPricaRequest request)
        {
            return _uspjesnaPricaService.Update(id, request);
        }
    }
}
