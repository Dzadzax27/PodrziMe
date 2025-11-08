using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

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

    public virtual DbSet<Korisnik> Korisniks { get; set; }

    public virtual DbSet<PodKategorija> PodKategorijas { get; set; }

    public virtual DbSet<TakmicarProfil> TakmicarProfils { get; set; }

    public virtual DbSet<Uloga> Ulogas { get; set; }

    public virtual DbSet<UspjesnaPrica> UspjesnaPricas { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=localhost;Database=PodrziMe;Trusted_Connection=True;TrustServerCertificate=True");

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

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
