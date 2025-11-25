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
    public class Komentar
    {
        private readonly IKomentarService _komentarService;
        public Komentar(ILogger<WeatherForecastController> logger, IKomentarService komentar)
        {
            this._komentarService = komentar;
        }

        [HttpGet("{id}")]
        [AllowAnonymous]
        public async Task<Model.Komentar> GetById(int id)
        {
            return await _komentarService.GetById(id);
        }

        [HttpGet]
        [AllowAnonymous]
        public async Task<PagedResult<Model.Komentar>> Get([FromQuery] Model.SearchObjects.KomentarSearchObject request)
        {
            return await _komentarService.Get(request);
        }

        [HttpPost]
        [AllowAnonymous]
        public async Task<Model.Komentar> Insert(InsertKomentarRequest request, [FromServices] MessageService messageService)
        {
            var response = await _komentarService.Insert(request);

            return response;    
        }
        [HttpPut("{id}")]
        public Task<Model.Komentar> Update(int id, UpdateKomentarRequest request)
        {
            return _komentarService.Update(id, request);
        }
    }
}