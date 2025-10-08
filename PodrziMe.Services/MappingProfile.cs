using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using PodrziMe.Model.Requests;
using PodrziMe.Services.Database;

namespace PodrziMe.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile() {
            CreateMap<Kandidat ,Model.Kandidat>();
            CreateMap<Kategorija, Model.Kategorija>();
            CreateMap<InsertKandidatRequest, Kandidat>();
            CreateMap<PodKategorija, Model.PodKategorija>();
            CreateMap<InsertPodKategorijaRequest, PodKategorija>();
            CreateMap<InsertKategorijaRequest,Kategorija>();
            CreateMap<InsertDonacijeRequest, Donacija>();
            CreateMap<Donacija, Model.Donacija>();
            CreateMap<Donor, Model.Donor>();
            CreateMap<InsertDonorRequest, Donor>();
            CreateMap<UspjesnaPrica, Model.UspjesnaPrica>();
            CreateMap<InsertUspjesnaPricaRequest, UspjesnaPrica>();
            CreateMap<UpdateDonorRequest, Donor>();
            CreateMap<Korisnik, Model.Korisnik>();
            CreateMap<Uloga, Model.Uloga>();
            CreateMap<InsertKorisnikRequest, Korisnik>();
        }
    }
}
