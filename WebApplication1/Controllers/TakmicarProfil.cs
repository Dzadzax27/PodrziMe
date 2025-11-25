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
    public class TakmicarProfil
    {
        private readonly ITakmicarProfilService _takmicarProfile;
        public TakmicarProfil(ILogger<WeatherForecastController> logger, ITakmicarProfilService takmicarProfile)
        {
            this._takmicarProfile = takmicarProfile;
        }

        [HttpGet("{id}")]
        public async Task<Model.TakmicarProfil> GetById(int id)
        {
            return await _takmicarProfile.GetById(id);
        }

        [HttpGet]
        public async Task<PagedResult<Model.TakmicarProfil>> Get([FromQuery] Model.SearchObjects.NazivSearchObject request)
        {
            return await _takmicarProfile.Get(request);
        }

        [HttpPost]
        [AllowAnonymous]
        public async Task<Model.TakmicarProfil> Insert(InsertTakmicarProfilRequest request)
        {
            return  await _takmicarProfile.Insert(request);
        }
        [HttpPut("{id}")]
        public Task<Model.TakmicarProfil> Update(int id, UpdateTakmicarProfilRequest request)
        {
            return _takmicarProfile.Update(id, request);
        }
    }
}