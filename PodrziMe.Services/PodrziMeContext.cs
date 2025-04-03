using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace PodrziMe.Services;

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

    public virtual DbSet<PodKategorija> PodKategorijas { get; set; }

    public virtual DbSet<UspjesnaPrica> UspjesnaPricas { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=DESKTOP-KHDS0TD\\SQLEXPRESS;Initial Catalog=PodrziMe;User ID=sa;Password=MyNewPassword;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Donacija>(entity =>
        {
            entity.HasKey(e => e.DonacijaId).HasName("PK__Donacija__9C1ECCB43009DFB3");

            entity.ToTable("Donacija");

            entity.Property(e => e.DonacijaId).ValueGeneratedNever();

            entity.HasOne(d => d.Donor).WithMany(p => p.Donacijas)
                .HasForeignKey(d => d.DonorId)
                .HasConstraintName("FK_DonorDonacija");

            entity.HasOne(d => d.Kandidat).WithMany(p => p.Donacijas)
                .HasForeignKey(d => d.KandidatId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_KandidatDonacija");
        });

        modelBuilder.Entity<Donor>(entity =>
        {
            entity.HasKey(e => e.DonorId).HasName("PK__Donor__052E3F78AE07BEC2");

            entity.ToTable("Donor");

            entity.Property(e => e.DonorId).ValueGeneratedNever();
            entity.Property(e => e.ImePrezime).HasColumnType("text");
            entity.Property(e => e.Zanimanje).HasColumnType("text");
        });

        modelBuilder.Entity<Kandidat>(entity =>
        {
            entity.HasKey(e => e.KandidatId).HasName("PK__Kandidat__5F7D602BE76B3489");

            entity.ToTable("Kandidat");

            entity.Property(e => e.KandidatId).ValueGeneratedNever();
            entity.Property(e => e.Email).HasColumnType("text");
            entity.Property(e => e.ImePrezime).HasColumnType("text");
            entity.Property(e => e.Link).HasColumnType("text");
            entity.Property(e => e.Omeni)
                .HasColumnType("text")
                .HasColumnName("OMeni");
            entity.Property(e => e.Uspjesi).HasColumnType("text");

            entity.HasOne(d => d.Kategorija).WithMany(p => p.Kandidats)
                .HasForeignKey(d => d.KategorijaId)
                .HasConstraintName("FK__Kandidat__Katego__5EBF139D");
        });

        modelBuilder.Entity<Kategorija>(entity =>
        {
            entity.HasKey(e => e.KategorijaId).HasName("PK__Kategori__6C3B8FEEFD1D310A");

            entity.ToTable("Kategorija");

            entity.Property(e => e.KategorijaId).ValueGeneratedNever();
            entity.Property(e => e.NazivKategorije).HasColumnType("text");

            entity.HasOne(d => d.PodKategorija).WithMany(p => p.Kategorijas)
                .HasForeignKey(d => d.PodKategorijaId)
                .HasConstraintName("FK__Kategorij__PodKa__619B8048");
        });

        modelBuilder.Entity<PodKategorija>(entity =>
        {
            entity.HasKey(e => e.PodKategorijaId).HasName("PK__PodKateg__D8D5C125545632FB");

            entity.ToTable("PodKategorija");

            entity.Property(e => e.PodKategorijaId).ValueGeneratedNever();
            entity.Property(e => e.NazivPodKategorije).HasColumnType("text");
        });

        modelBuilder.Entity<UspjesnaPrica>(entity =>
        {
            entity.HasKey(e => e.UspjesnaPricaId).HasName("PK__Uspjesna__D62E59A581969F67");

            entity.ToTable("UspjesnaPrica");

            entity.Property(e => e.UspjesnaPricaId).ValueGeneratedNever();
            entity.Property(e => e.NaslovPrice).HasColumnType("text");
            entity.Property(e => e.Prica).HasColumnType("text");

            entity.HasOne(d => d.Kandidat).WithMany(p => p.UspjesnaPricas)
                .HasForeignKey(d => d.KandidatId)
                .HasConstraintName("FK_KandidatUspjesanPrica");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
