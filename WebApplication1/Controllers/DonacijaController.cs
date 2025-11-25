using Azure;
using EasyNetQ;
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
    public class DonacijaController
    {
        private readonly IDonacijaService donacijeService;
        private CallRabbitMqAndCreateNotification callRabbitMqAndCreateNotification;
        public DonacijaController(ILogger<WeatherForecastController> logger, IDonacijaService donacijeService, CallRabbitMqAndCreateNotification _callRabbitMqAndCreateNotification)
        {
            this.donacijeService = donacijeService;
            callRabbitMqAndCreateNotification = _callRabbitMqAndCreateNotification;
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
            var response = await donacijeService.Insert(request);
            Console.WriteLine($"DonacijaId: {response.DonacijaId}");
            await callRabbitMqAndCreateNotification.SendNotificationAndCreateInDatabase(response);
            return response;
        }

       
        [HttpPut("{id}")]
        public async Task<Model.Donacija> Update(int id,InsertDonacijeRequest request)
        {

            var response = await donacijeService.Update(id, request);
            return response;
        }
    }

}
