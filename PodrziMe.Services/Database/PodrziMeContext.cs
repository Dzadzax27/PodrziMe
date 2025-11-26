using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;


namespace PodrziMe.Services.Database;

public partial class PodrziMeContext : DbContext
{
    public PodrziMeContext()
    {
    }

    public PodrziMeContext(DbContextOptions<PodrziMeContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Donacija> Donacijas { get; set; }

    public virtual DbSet<Donor> Donors { get; set; }

    public virtual DbSet<Kandidat> Kandidats { get; set; }

    public virtual DbSet<Kategorija> Kategorijas { get; set; }

    public virtual DbSet<Komentar> Komentars { get; set; }

    public virtual DbSet<Korisnik> Korisniks { get; set; }

    public virtual DbSet<Obavijest> Obavijests { get; set; }

    public virtual DbSet<PodKategorija> PodKategorijas { get; set; }

    public virtual DbSet<TakmicarProfil> TakmicarProfils { get; set; }

    public virtual DbSet<Uloga> Ulogas { get; set; }

    public virtual DbSet<UspjesnaPrica> UspjesnaPricas { get; set; }

//    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
//        => optionsBuilder.UseSqlServer("Server=localhost;Database=PodrziMe;Trusted_Connection=True;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {

        modelBuilder.Entity<Donacija>(entity =>
        {
            entity.HasKey(e => e.DonacijaId).HasName("PK__Donacija__9C1ECCB4383B4F42");

            entity.ToTable("Donacija");

            entity.HasIndex(e => e.DonorId, "IX_Donacija_DonorId");

            entity.HasIndex(e => e.KandidatId, "IX_Donacija_KandidatId");

            entity.HasOne(d => d.Donor).WithMany(p => p.Donacijas)
                .HasForeignKey(d => d.DonorId)
                .HasConstraintName("FK_Donor");

            entity.HasOne(d => d.Kandidat).WithMany(p => p.Donacijas)
                .HasForeignKey(d => d.KandidatId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_KandidatDonacija");
        });

        modelBuilder.Entity<Donor>(entity =>
        {
            entity.HasKey(e => e.DonorId).HasName("PK__Donor__052E3F7881996CD1");

            entity.ToTable("Donor");

            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.Ime).HasMaxLength(100);
            entity.Property(e => e.Prezime).HasMaxLength(100);
            entity.Property(e => e.Zanimanje).HasMaxLength(255);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Donors)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK_Donor_Korisnik");
        });

        modelBuilder.Entity<Kandidat>(entity =>
        {
            entity.HasKey(e => e.KandidatId).HasName("PK__Kandidat__5F7D602BB9E73872");

            entity.ToTable("Kandidat");

            entity.HasIndex(e => e.KategorijaId, "IX_Kandidat_KategorijaId");

            entity.Property(e => e.Email).HasMaxLength(255);
            entity.Property(e => e.Ime).HasMaxLength(50);
            entity.Property(e => e.Link).HasMaxLength(255);
            entity.Property(e => e.Prezime).HasMaxLength(50);

            entity.HasOne(d => d.Kategorija).WithMany(p => p.Kandidats)
                .HasForeignKey(d => d.KategorijaId)
                .HasConstraintName("FK_Kategorija");

            entity.HasOne(d => d.TakmicarProfil).WithMany(p => p.Kandidats)
                .HasForeignKey(d => d.TakmicarProfilId)
                .HasConstraintName("FK_Kandidat_TakmicarProfil");
        });

        modelBuilder.Entity<Kategorija>(entity =>
        {
            entity.HasKey(e => e.KategorijaId).HasName("PK__Kategori__6C3B8FEE0BC1D5A7");

            entity.ToTable("Kategorija");

            entity.HasIndex(e => e.PodKategorijaId, "IX_Kategorija_PodKategorijaId");

            entity.Property(e => e.NazivKategorije).HasMaxLength(255);

            entity.HasOne(d => d.PodKategorija).WithMany(p => p.Kategorijas)
                .HasForeignKey(d => d.PodKategorijaId)
                .HasConstraintName("FK_PodKategorija");
        });

        modelBuilder.Entity<Komentar>(entity =>
        {
            entity.HasKey(e => e.KomentarId).HasName("PK__Komentar__C0C3049CAD6F3E08");

            entity.ToTable("Komentar");

            entity.Property(e => e.Komentar1)
                .HasColumnType("text")
                .HasColumnName("Komentar");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Komentars)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK_Komentar_Korisnik");

            entity.HasOne(d => d.UspjesnaPrica).WithMany(p => p.Komentars)
                .HasForeignKey(d => d.UspjesnaPricaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Komentar_UspjesnaPrica");
        });

        modelBuilder.Entity<Korisnik>(entity =>
        {
            entity.HasKey(e => e.KorisnikId).HasName("PK__Korisnik__80B06D4132BAFC0E");

            entity.ToTable("Korisnik");

            entity.HasIndex(e => e.UlogaId, "IX_Korisnik_UlogaId");

            entity.HasIndex(e => e.KorisnickoIme, "UQ_Korisnik_KorisnickoIme").IsUnique();

            entity.Property(e => e.Email).HasMaxLength(255);
            entity.Property(e => e.KorisnickoIme).HasMaxLength(100);
            entity.Property(e => e.LozinkaHash).HasMaxLength(200);
            entity.Property(e => e.LozinkaSalt).HasMaxLength(200);
            entity.Property(e => e.Telefon).HasMaxLength(50);

            entity.HasOne(d => d.Uloga).WithMany(p => p.Korisniks)
                .HasForeignKey(d => d.UlogaId)
                .HasConstraintName("FK__Korisnik__UlogaI__6383C8BA");
        });

        modelBuilder.Entity<Obavijest>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Obavijes__3214EC079C03D296");

            entity.ToTable("Obavijest");

            entity.Property(e => e.DatumKreiranja).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.Kandidat).WithMany(p => p.Obavijests)
                .HasForeignKey(d => d.KandidatId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Obavijest_Kandidat");
        });

        modelBuilder.Entity<PodKategorija>(entity =>
        {
            entity.HasKey(e => e.PodKategorijaId).HasName("PK__PodKateg__D8D5C125B165C694");

            entity.ToTable("PodKategorija");

            entity.Property(e => e.NazivPodKategorije).HasMaxLength(255);
        });

        modelBuilder.Entity<TakmicarProfil>(entity =>
        {
            entity.HasKey(e => e.TakmicarProfilId).HasName("PK__Takmicar__E312D62A7B519C4A");

            entity.ToTable("TakmicarProfil");

            entity.Property(e => e.Ime).HasMaxLength(50);
            entity.Property(e => e.Prezime).HasMaxLength(50);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.TakmicarProfils)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TakmicarP__Koris__6FE99F9F");
        });

        modelBuilder.Entity<Uloga>(entity =>
        {
            entity.HasKey(e => e.UlogaId).HasName("PK__Uloga__DCAB23CB44AA88F0");

            entity.ToTable("Uloga");

            entity.Property(e => e.NazivUloge).HasMaxLength(100);
        });

        modelBuilder.Entity<UspjesnaPrica>(entity =>
        {
            entity.HasKey(e => e.UspjesnaPricaId).HasName("PK__Uspjesna__D62E59A5DE208AAB");

            entity.ToTable("UspjesnaPrica");

            entity.HasIndex(e => e.KandidatId, "IX_UspjesnaPrica_KandidatId");

            entity.Property(e => e.NaslovPrice).HasMaxLength(255);

            entity.HasOne(d => d.Kandidat).WithMany(p => p.UspjesnaPricas)
                .HasForeignKey(d => d.KandidatId)
                .HasConstraintName("FK_Kandidat");
        });



        // --- Seed Uloge ---
        modelBuilder.Entity<Uloga>().HasData(
            new Uloga { UlogaId = 1, NazivUloge = "Admin" },
            new Uloga { UlogaId = 2, NazivUloge = "Donor" },
            new Uloga { UlogaId = 3, NazivUloge = "Takmicar" }
        );

        // --- Seed Kategorije ---
        modelBuilder.Entity<Kategorija>().HasData(
            new Kategorija { KategorijaId = 1, NazivKategorije = "Umjetnost", PodKategorijaId = null },
            new Kategorija { KategorijaId = 2, NazivKategorije = "Sport", PodKategorijaId = null },
            new Kategorija { KategorijaId = 3, NazivKategorije = "Edukacija", PodKategorijaId = null }
        );

        // --- Seed Korisnici ---
        modelBuilder.Entity<Korisnik>().HasData(
            new Korisnik { KorisnikId = 1, KorisnickoIme = "admin", Email = "sadzidadzihoburovic@gmail.com", Telefon = "062345789",  LozinkaHash = "SJW4Y+qr4aKm78tlos2v21ZiTYo=", LozinkaSalt = "xJ6xqG2Wa6vWJ3KkpUMvKQ==", UlogaId = 1 },
            new Korisnik { KorisnikId = 2, KorisnickoIme = "donor1", Email = "sadzidadzihoburovic@gmail.com", Telefon = "062134356", LozinkaHash = "E1TAZVqPdEt9KxbkjfkflFtQPOo=", LozinkaSalt = "lNjzTD7GTj7GW1XMbDzi5g==", UlogaId = 2 },
            new Korisnik { KorisnikId = 3, KorisnickoIme = "donor2", Email = "sadzidadzihoburovic@gmail.com", Telefon = "063567733", LozinkaHash = "NPT8rZmc+yVuV2vhcrwnvr7ycuw=", LozinkaSalt = "O87afcPNhyDohs0enN3s9w==", UlogaId = 2 },
            new Korisnik { KorisnikId = 4, KorisnickoIme = "takmicar1", Email = "sadzidadzihoburovic@gmail.com", Telefon = "06145567", LozinkaHash = "dq7eJffewzTn7ch44lB9+okjbAY=", LozinkaSalt = "POJT/jZEcYEjxeZpkfXORg==", UlogaId = 3 }
        );


        // --- Seed Donor Profil ---
        modelBuilder.Entity<Donor>().HasData(
            new Donor
            {
                DonorId = 1,
                Ime = "Marko",
                Prezime = "Markovic",
                KorisnikId = 2,
                Zanimanje = "Inzenjer",
                UkupnoDonacija = 100
            }
        );

        // --- Seed Takmicar Profil ---
        modelBuilder.Entity<TakmicarProfil>().HasData(
            new TakmicarProfil
            {
                TakmicarProfilId = 1,
                Ime = "Ana",
                Prezime = "Anic",
                KorisnikId = 4,
                DatumRodjenja = new DateOnly(1995, 5, 10)
            }
        );

        modelBuilder.Entity<Kandidat>().HasData(
            new Kandidat
            {
                KandidatId = 1,
                Ime = "Ana",
                Prezime = "Anic",
                Omeni = "Ja sam Ana volim umjetnost takmicim se u umjestnost",
                Uspjesi = "1. mjesto na literernom konkursu za rad Bosno moja",
                BrojTelefona = 063456644,
                ZeljenaDonacija = 2000,
                KategorijaId = 2,
                Odobren = true,
                TakmicarProfilId = 1,
                DatumRodjenja = new DateOnly(1995, 5, 10)

            }
        );

    // --- Seed Uspjesne Price ---
    modelBuilder.Entity<UspjesnaPrica>().HasData(
            new UspjesnaPrica
            {
                UspjesnaPricaId = 1,
                NaslovPrice = "Uspjeh u umjetnosti",
                Prica = "Ana je osvojila nagradu u slikanju.",
                UkupnaDonacija = 50
            },
            new UspjesnaPrica
            {
                UspjesnaPricaId = 2,
                NaslovPrice = "Sportaški uspjeh",
                Prica = "Marko je pobijedio na maratonu.",
                UkupnaDonacija = 75
            },
            new UspjesnaPrica
            {
                UspjesnaPricaId = 3,
                NaslovPrice = "Edukacija za budućnost",
                Prica = "Jovana je završila kurs programiranja.",
                UkupnaDonacija = 120
            }
        );
        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);

    
}
