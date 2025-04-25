using Microsoft.AspNetCore.Mvc;
using PodrziMe.Model.Requests;
using PodrziMe.Services;
using WebApplication1.Controllers;

namespace PodrziMe.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class DonorContoller
    {
        private readonly IDonorService donorService;
        public DonorContoller(ILogger<WeatherForecastController> logger, IDonorService donorService)
        {
            this.donorService = donorService;
        }

        [HttpGet]
        public IList<Model.Donor> GetList()
        {
            return donorService.GetList();
        }

        [HttpPost]
        public Model.Donor Insert(InsertDonorRequest request)
        {
            return donorService.Insert(request);
        }
        [HttpPut("{id}")]
        public Model.Donor Update(InsertDonorRequest request)
        {
            return donorService.Insert(request);
        }
    }
}
