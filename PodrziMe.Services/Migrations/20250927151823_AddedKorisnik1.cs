using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PodrziMe.Services.Migrations
{
    /// <inheritdoc />
    public partial class AddedKorisnik1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Donor",
                columns: table => new
                {
                    DonorId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Zanimanje = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    UkupnoDonacija = table.Column<int>(type: "int", nullable: true),
                    DatumRodjenja = table.Column<DateOnly>(type: "date", nullable: true),
                    Ime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Prezime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Donor__052E3F7881996CD1", x => x.DonorId);
                });

            migrationBuilder.CreateTable(
                name: "PodKategorija",
                columns: table => new
                {
                    PodKategorijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NazivPodKategorije = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__PodKateg__D8D5C125B165C694", x => x.PodKategorijaId);
                });

            migrationBuilder.CreateTable(
                name: "Uloga",
                columns: table => new
                {
                    UlogaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NazivUloge = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Uloga__DCAB23CB44AA88F0", x => x.UlogaId);
                });

            migrationBuilder.CreateTable(
                name: "Kategorija",
                columns: table => new
                {
                    KategorijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NazivKategorije = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    PodKategorijaId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Kategori__6C3B8FEE0BC1D5A7", x => x.KategorijaId);
                    table.ForeignKey(
                        name: "FK_PodKategorija",
                        column: x => x.PodKategorijaId,
                        principalTable: "PodKategorija",
                        principalColumn: "PodKategorijaId");
                });

            migrationBuilder.CreateTable(
                name: "Korisnik",
                columns: table => new
                {
                    KorisnikId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Email = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    Telefon = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    KorisnickoIme = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    LozinkaHash = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Status = table.Column<bool>(type: "bit", nullable: true),
                    UlogaId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnik__80B06D4132BAFC0E", x => x.KorisnikId);
                    table.ForeignKey(
                        name: "FK__Korisnik__UlogaI__6383C8BA",
                        column: x => x.UlogaId,
                        principalTable: "Uloga",
                        principalColumn: "UlogaId");
                });

            migrationBuilder.CreateTable(
                name: "Kandidat",
                columns: table => new
                {
                    KandidatId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Email = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    DatumRodjenja = table.Column<DateOnly>(type: "date", nullable: false),
                    Omeni = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    Uspjesi = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    Link = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    BrojTelefona = table.Column<int>(type: "int", nullable: true),
                    ZeljenaDonacija = table.Column<int>(type: "int", nullable: true),
                    KategorijaId = table.Column<int>(type: "int", nullable: true),
                    Ime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Prezime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Kandidat__5F7D602BB9E73872", x => x.KandidatId);
                    table.ForeignKey(
                        name: "FK_Kategorija",
                        column: x => x.KategorijaId,
                        principalTable: "Kategorija",
                        principalColumn: "KategorijaId");
                });

            migrationBuilder.CreateTable(
                name: "Donacija",
                columns: table => new
                {
                    DonacijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KandidatId = table.Column<int>(type: "int", nullable: false),
                    DatumDonacije = table.Column<DateOnly>(type: "date", nullable: true),
                    IznosDonacije = table.Column<int>(type: "int", nullable: false),
                    DonorId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Donacija__9C1ECCB4383B4F42", x => x.DonacijaId);
                    table.ForeignKey(
                        name: "FK_Donor",
                        column: x => x.DonorId,
                        principalTable: "Donor",
                        principalColumn: "DonorId");
                    table.ForeignKey(
                        name: "FK_KandidatDonacija",
                        column: x => x.KandidatId,
                        principalTable: "Kandidat",
                        principalColumn: "KandidatId");
                });

            migrationBuilder.CreateTable(
                name: "UspjesnaPrica",
                columns: table => new
                {
                    UspjesnaPricaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NaslovPrice = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Prica = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    UkupnaDonacija = table.Column<int>(type: "int", nullable: true),
                    KandidatId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Uspjesna__D62E59A5DE208AAB", x => x.UspjesnaPricaId);
                    table.ForeignKey(
                        name: "FK_Kandidat",
                        column: x => x.KandidatId,
                        principalTable: "Kandidat",
                        principalColumn: "KandidatId");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Donacija_DonorId",
                table: "Donacija",
                column: "DonorId");

            migrationBuilder.CreateIndex(
                name: "IX_Donacija_KandidatId",
                table: "Donacija",
                column: "KandidatId");

            migrationBuilder.CreateIndex(
                name: "IX_Kandidat_KategorijaId",
                table: "Kandidat",
                column: "KategorijaId");

            migrationBuilder.CreateIndex(
                name: "IX_Kategorija_PodKategorijaId",
                table: "Kategorija",
                column: "PodKategorijaId");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnik_UlogaId",
                table: "Korisnik",
                column: "UlogaId");

            migrationBuilder.CreateIndex(
                name: "IX_UspjesnaPrica_KandidatId",
                table: "UspjesnaPrica",
                column: "KandidatId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Donacija");

            migrationBuilder.DropTable(
                name: "Korisnik");

            migrationBuilder.DropTable(
                name: "UspjesnaPrica");

            migrationBuilder.DropTable(
                name: "Donor");

            migrationBuilder.DropTable(
                name: "Uloga");

            migrationBuilder.DropTable(
                name: "Kandidat");

            migrationBuilder.DropTable(
                name: "Kategorija");

            migrationBuilder.DropTable(
                name: "PodKategorija");
        }
    }
}
