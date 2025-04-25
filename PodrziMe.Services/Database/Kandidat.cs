using System;
using System.Collections.Generic;

namespace PodrziMe;

public partial class Kandidat
{
    public int KandidatId { get; set; }

    public string ImePrezime { get; set; } = null!;

    public string? Email { get; set; }

    public DateOnly DatumRodjenja { get; set; }

    public string? Omeni { get; set; }

    public string? Uspjesi { get; set; }

    public string? Link { get; set; }

    public int? BrojTelefona { get; set; }

    public int? ZeljenaDonacija { get; set; }

    public int? KategorijaId { get; set; }

    public virtual ICollection<Donacija> Donacijas { get; set; } = new List<Donacija>();

    public virtual Kategorija? Kategorija { get; set; }

    public virtual ICollection<UspjesnaPrica> UspjesnaPricas { get; set; } = new List<UspjesnaPrica>();
}
