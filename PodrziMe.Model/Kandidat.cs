using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PodrziMe.Model
{
    public class Kandidat
    {
        public int KandidatId { get; set; }

        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;

        public string? Email { get; set; }

        public DateOnly DatumRodjenja { get; set; }

        public string? Omeni { get; set; }

        public string? Uspjesi { get; set; }

        public string? Link { get; set; }

        public int? BrojTelefona { get; set; }

        public int? ZeljenaDonacija { get; set; }

        public int? KategorijaId { get; set; }

        public virtual Kategorija? Kategorija { get; set; }
        public bool? Odobren { get; set; }
        public byte[]? SlikaThumb { get; set; }
        public byte[]? Slika { get; set; }
        public int? TakmicarProfilId { get; set; }
        public virtual TakmicarProfil? TakmicarProfil { get; set; }

        public virtual ICollection<TakmicarProfil> TakmicarProfils { get; set; } = new List<TakmicarProfil>();

    }
}
