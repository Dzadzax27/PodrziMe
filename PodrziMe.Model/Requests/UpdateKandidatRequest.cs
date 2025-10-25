using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class UpdateKandidatRequest
    {
        public string? Ime { get; set; } = null!;
        public string? Prezime { get; set; } = null!;
        public string? Email { get; set; }
        public string? Omeni { get; set; }
        public string? Uspjesi { get; set; }
        public string? Link { get; set; }
        public int? BrojTelefona { get; set; }
        public int? ZeljenaDonacija { get; set; }
        public byte[]? SlikaThumb { get; set; }
        public byte[]? Slika { get; set; }
        public bool? Odobren { get; set; }
    }
}
