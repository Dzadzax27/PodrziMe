using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PodrziMe.Model.Requests;
using PodrziMe.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public interface IDonacijaService : IService<Model.Donacija,Model.SearchObjects.DonacijaSearchObject>,
        ICRUDService<Model.Donacija,DonacijaSearchObject, InsertDonacijeRequest, InsertDonacijeRequest>
    {
    }
}
