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
    public class DonorContoller
    {
        private readonly IDonorService donorService;
        public DonorContoller(ILogger<WeatherForecastController> logger, IDonorService donorService)
        {
            this.donorService = donorService;
        }

        [HttpGet("{id}")]
        public async Task<Model.Donor> GetById(int id)
        {
            return await donorService.GetById(id);
        }

        [HttpGet]
        public async Task<PagedResult<Model.Donor>> Get([FromQuery] Model.SearchObjects.DonorSearchObject request)
        {
            return await donorService.Get(request);
        }

        [HttpPost]
        public async Task<Model.Donor> Insert(InsertDonorRequest request)
        {
            return await donorService.Insert(request);
        }
        [HttpPut("{id}")]
        public Task<Model.Donor> Update(int id,UpdateDonorRequest request)
        {
            return donorService.Update(id,request);
        }
    }
}
