using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Services
{
    public class DTOKandidatDonacijaObavijest
    {
        public string KandidatIme { get; set; }
        public string KandidatPrezime { get; set; }
        public string toEmail { get; set; }
        public int Donacija { get; set; }
    }
}
