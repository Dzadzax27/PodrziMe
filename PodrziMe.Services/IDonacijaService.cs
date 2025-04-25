using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PodrziMe.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public interface IDonacijaService
    {
        IList<Model.Donacija> GetList();
        Model.Donacija Insert(InsertDonacijeRequest request);
        Model.Donacija Update(int id, InsertDonacijeRequest request);
    }
}
