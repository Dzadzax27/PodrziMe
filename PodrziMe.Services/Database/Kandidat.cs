using System;
using System.Collections.Generic;

namespace PodrziMe.Services.Database;

public partial class Kandidat
{
    public int KandidatId { get; set; }

    public string? Email { get; set; }

    public DateOnly DatumRodjenja { get; set; }

    public string? Omeni { get; set; }

    public string? Uspjesi { get; set; }

    public string? Link { get; set; }

    public int? BrojTelefona { get; set; }

    public int? ZeljenaDonacija { get; set; }

    public int? KategorijaId { get; set; }

    public string? Ime { get; set; }

    public string? Prezime { get; set; }

    public byte[]? SlikaThumb { get; set; }

    public byte[]? Slika { get; set; }

    public bool? Odobren { get; set; }

    public int? TakmicarProfilId { get; set; }

    public virtual ICollection<Donacija> Donacijas { get; set; } = new List<Donacija>();

    public virtual Kategorija? Kategorija { get; set; }

    public virtual ICollection<Obavijest> Obavijests { get; set; } = new List<Obavijest>();

    public virtual TakmicarProfil? TakmicarProfil { get; set; }

    public virtual ICollection<UspjesnaPrica> UspjesnaPricas { get; set; } = new List<UspjesnaPrica>();
}
