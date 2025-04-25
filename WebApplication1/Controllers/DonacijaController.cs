using Microsoft.AspNetCore.Mvc;
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

        [HttpGet]
        public IList<Model.Donacija> GetList()
        {
            return donacijeService.GetList();
        }

        [HttpPost]
        public Model.Donacija Insert(InsertDonacijeRequest request)
        {
            return donacijeService.Insert(request);
        }

        [HttpPut("{id}")]
        public Model.Donacija Update(InsertDonacijeRequest request)
        {
            return donacijeService.Insert(request);
        }
    }

}
