using EasyNetQ;
using EasyNetQ.DI;
using EasyNetQ.Serialization.NewtonsoftJson;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using PodrziMe.Model;
using PodrziMe.Model.Requests;
using PodrziMe.Services;
using WebApplication1.Controllers;

namespace PodrziMe.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class Obavijest
    {
        private readonly IObavijestService _obavijestService;
        public Obavijest(ILogger<WeatherForecastController> logger, IObavijestService obavijest)
        {
            this._obavijestService = obavijest;
        }

        [HttpGet("{id}")]
        [AllowAnonymous]
        public async Task<Model.Obavijest> GetById(int id)
        {
            return await _obavijestService.GetById(id);
        }

        [HttpGet]
        [AllowAnonymous]
        public async Task<PagedResult<Model.Obavijest>> Get([FromQuery] Model.SearchObjects.ObavijestSearchObject request)
        {
            return await _obavijestService.Get(request);
        }

        [HttpPost]
        [AllowAnonymous]
        public async Task<Model.Obavijest> Insert(InsertObavijestRequest request)
        {
            var response = await _obavijestService.Insert(request);

            return response;
        }

        [HttpDelete("{id}")]
        public Task<bool> Delete(int id)
        {
            return _obavijestService.Delete(id);
        }
    }
}