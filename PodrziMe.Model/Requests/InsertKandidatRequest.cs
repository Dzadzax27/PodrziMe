using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertKandidatRequest
    {
        [Required]
        public string Ime { get; set; } = null!;
        [Required]
        public string Prezime { get; set; } = null!;
        [Required]

        public string Email { get; set; }
        [Required]
        public DateOnly DatumRodjenja { get; set; }
        [Required]
        public string? Omeni { get; set; }

        public string? Uspjesi { get; set; }

        public string? Link { get; set; }
        [Required]
        public int? BrojTelefona { get; set; }

        public int? ZeljenaDonacija { get; set; }

        public int? KategorijaId { get; set; }
        public byte[]? SlikaThumb { get; set; }
        public byte[]? Slika { get; set; }

    }
}
