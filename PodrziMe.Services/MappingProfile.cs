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
            CreateMap<UpdateKorisnikProfil, Korisnik>();
            CreateMap<UpdateKandidatRequest, Kandidat>();
            CreateMap<UpdateKorisnikProfil, TakmicarProfil>();
            CreateMap<InsertTakmicarProfilRequest, TakmicarProfil>();
            CreateMap<TakmicarProfil, Model.TakmicarProfil>();
            CreateMap<Komentar, Model.Komentar>();
            CreateMap<InsertKomentarRequest, Komentar>();
            CreateMap<UpdateKomentarRequest, Komentar>();
            CreateMap<Obavijest, Model.Obavijest>();
            CreateMap<InsertObavijestRequest, Obavijest>();
        }
    }
}
