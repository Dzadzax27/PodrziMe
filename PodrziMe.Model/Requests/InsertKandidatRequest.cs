using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model.Requests
{
    public class InsertKandidatRequest
    {

        public string ImePrezime { get; set; } = null!;

        public string? Email { get; set; }

        public DateOnly DatumRodjenja { get; set; }

        public string? Omeni { get; set; }

        public string? Uspjesi { get; set; }

        public string? Link { get; set; }

        public int? BrojTelefona { get; set; }

        public int? ZeljenaDonacija { get; set; }

        public int? KategorijaId { get; set; }

    }
}
