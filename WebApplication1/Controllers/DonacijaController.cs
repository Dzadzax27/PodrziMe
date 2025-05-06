using Microsoft.AspNetCore.Mvc;
using PodrziMe.Model;
using PodrziMe.Model.Requests;
using PodrziMe.Services;
using WebApplication1.Controllers;

namespace PodrziMe.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class DonacijaController
    {
        private readonly IDonacijaService donacijeService;
        public DonacijaController(ILogger<WeatherForecastController> logger, IDonacijaService donacijeService)
        {
            this.donacijeService = donacijeService;
        }

        [HttpGet("{id}")]
        public async Task<Model.Donacija> GetById(int id)
        {
            return await donacijeService.GetById(id);
        }

        [HttpGet]
        public async Task<PagedResult<Model.Donacija>> Get([FromQuery] Model.SearchObjects.DonacijaSearchObject request)
        {
            return await donacijeService.Get(request);
        }

        [HttpPost]
        public async Task<Model.Donacija> Insert(InsertDonacijeRequest request)
        {
            return await donacijeService.Insert(request);
        }

       
        [HttpPut("{id}")]
        public async Task<Model.Donacija> Update(int id,InsertDonacijeRequest request)
        {
            return await donacijeService.Update(id,request);
        }
    }

}
