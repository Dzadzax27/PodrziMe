using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace PodrziMe.Services.Migrations
{
    /// <inheritdoc />
    public partial class UpdateSeedAndModels4 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
                name: "Donor",
                columns: table => new
                {
                    DonorId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Zanimanje = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    UkupnoDonacija = table.Column<int>(type: "int", nullable: true),
                    DatumRodjenja = table.Column<DateOnly>(type: "date", nullable: true),
                    Ime = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    Prezime = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    KorisnikId = table.Column<int>(type: "int", nullable: true),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Donor__052E3F7881996CD1", x => x.DonorId);
                    table.ForeignKey(
                        name: "FK_Donor_Korisnik",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                });

            migrationBuilder.CreateTable(
                name: "TakmicarProfil",
                columns: table => new
                {
                    TakmicarProfilId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    DatumRodjenja = table.Column<DateOnly>(type: "date", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Takmicar__E312D62A7B519C4A", x => x.TakmicarProfilId);
                    table.ForeignKey(
                        name: "FK__TakmicarP__Koris__6FE99F9F",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                });

            migrationBuilder.CreateTable(
                name: "Kandidat",
                columns: table => new
                {
                    KandidatId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Email = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    DatumRodjenja = table.Column<DateOnly>(type: "date", nullable: false),
                    Omeni = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Uspjesi = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Link = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    BrojTelefona = table.Column<int>(type: "int", nullable: true),
                    ZeljenaDonacija = table.Column<int>(type: "int", nullable: true),
                    KategorijaId = table.Column<int>(type: "int", nullable: true),
                    Ime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Prezime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    SlikaThumb = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Odobren = table.Column<bool>(type: "bit", nullable: true),
                    TakmicarProfilId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Kandidat__5F7D602BB9E73872", x => x.KandidatId);
                    table.ForeignKey(
                        name: "FK_Kandidat_TakmicarProfil",
                        column: x => x.TakmicarProfilId,
                        principalTable: "TakmicarProfil",
                        principalColumn: "TakmicarProfilId");
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
                    KandidatId = table.Column<int>(type: "int", nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true)
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

            migrationBuilder.CreateTable(
                name: "Obavijest",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "(getdate())"),
                    KandidatId = table.Column<int>(type: "int", nullable: false),
                    DonacijaId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Obavijes__3214EC079C03D296", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Obavijest_Donacija_DonacijaId",
                        column: x => x.DonacijaId,
                        principalTable: "Donacija",
                        principalColumn: "DonacijaId");
                    table.ForeignKey(
                        name: "FK_Obavijest_Kandidat",
                        column: x => x.KandidatId,
                        principalTable: "Kandidat",
                        principalColumn: "KandidatId");
                });

            migrationBuilder.CreateTable(
                name: "Komentar",
                columns: table => new
                {
                    KomentarId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: true),
                    UspjesnaPricaId = table.Column<int>(type: "int", nullable: false),
                    Komentar = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Komentar__C0C3049CAD6F3E08", x => x.KomentarId);
                    table.ForeignKey(
                        name: "FK_Komentar_Korisnik",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                    table.ForeignKey(
                        name: "FK_Komentar_UspjesnaPrica",
                        column: x => x.UspjesnaPricaId,
                        principalTable: "UspjesnaPrica",
                        principalColumn: "UspjesnaPricaId");
                });

            migrationBuilder.InsertData(
                table: "Kategorija",
                columns: new[] { "KategorijaId", "NazivKategorije", "PodKategorijaId" },
                values: new object[,]
                {
                    { 1, "Umjetnost", null },
                    { 2, "Sport", null },
                    { 3, "Edukacija", null }
                });

            migrationBuilder.InsertData(
                table: "Uloga",
                columns: new[] { "UlogaId", "NazivUloge" },
                values: new object[,]
                {
                    { 1, "Admin" },
                    { 2, "Donor" },
                    { 3, "Takmicar" }
                });

            migrationBuilder.InsertData(
                table: "UspjesnaPrica",
                columns: new[] { "UspjesnaPricaId", "KandidatId", "NaslovPrice", "Prica", "Slika", "UkupnaDonacija" },
                values: new object[,]
                {
                    { 1, null, "Uspjeh u umjetnosti", "Ana je osvojila nagradu u slikanju.", null, 50 },
                    { 2, null, "Sportaški uspjeh", "Marko je pobijedio na maratonu.", null, 75 },
                    { 3, null, "Edukacija za budućnost", "Jovana je završila kurs programiranja.", null, 120 }
                });

            migrationBuilder.InsertData(
                table: "Korisnik",
                columns: new[] { "KorisnikId", "Email", "KorisnickoIme", "LozinkaHash", "LozinkaSalt", "Status", "Telefon", "UlogaId" },
                values: new object[,]
                {
                    { 1, "sadzidadzihoburovic@gmail.com", "admin", "SJW4Y+qr4aKm78tlos2v21ZiTYo=", "xJ6xqG2Wa6vWJ3KkpUMvKQ==", null, "062345789", 1 },
                    { 2, "sadzidadzihoburovic@gmail.com", "donor1", "E1TAZVqPdEt9KxbkjfkflFtQPOo=", "lNjzTD7GTj7GW1XMbDzi5g==", null, "062134356", 2 },
                    { 3, "sadzidadzihoburovic@gmail.com", "donor2", "NPT8rZmc+yVuV2vhcrwnvr7ycuw=", "O87afcPNhyDohs0enN3s9w==", null, "063567733", 2 },
                    { 4, "sadzidadzihoburovic@gmail.com", "takmicar1", "dq7eJffewzTn7ch44lB9+okjbAY=", "POJT/jZEcYEjxeZpkfXORg==", null, "06145567", 3 }
                });

            migrationBuilder.InsertData(
                table: "Donor",
                columns: new[] { "DonorId", "DatumRodjenja", "Email", "Ime", "KorisnikId", "Prezime", "UkupnoDonacija", "Zanimanje" },
                values: new object[] { 1, null, null, "Marko", 2, "Markovic", 100, "Inzenjer" });

            migrationBuilder.InsertData(
                table: "TakmicarProfil",
                columns: new[] { "TakmicarProfilId", "DatumRodjenja", "Ime", "KorisnikId", "Prezime" },
                values: new object[] { 1, new DateOnly(1995, 5, 10), "Ana", 4, "Anic" });

            migrationBuilder.InsertData(
                table: "Kandidat",
                columns: new[] { "KandidatId", "BrojTelefona", "DatumRodjenja", "Email", "Ime", "KategorijaId", "Link", "Odobren", "Omeni", "Prezime", "Slika", "SlikaThumb", "TakmicarProfilId", "Uspjesi", "ZeljenaDonacija" },
                values: new object[] { 1, 63456644, new DateOnly(1995, 5, 10), null, "Ana", 2, null, true, "Ja sam Ana volim umjetnost takmicim se u umjestnost", "Anic", null, null, 1, "1. mjesto na literernom konkursu za rad Bosno moja", 2000 });

            migrationBuilder.CreateIndex(
                name: "IX_Donacija_DonorId",
                table: "Donacija",
                column: "DonorId");

            migrationBuilder.CreateIndex(
                name: "IX_Donacija_KandidatId",
                table: "Donacija",
                column: "KandidatId");

            migrationBuilder.CreateIndex(
                name: "IX_Donor_KorisnikId",
                table: "Donor",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Kandidat_KategorijaId",
                table: "Kandidat",
                column: "KategorijaId");

            migrationBuilder.CreateIndex(
                name: "IX_Kandidat_TakmicarProfilId",
                table: "Kandidat",
                column: "TakmicarProfilId");

            migrationBuilder.CreateIndex(
                name: "IX_Kategorija_PodKategorijaId",
                table: "Kategorija",
                column: "PodKategorijaId");

            migrationBuilder.CreateIndex(
                name: "IX_Komentar_KorisnikId",
                table: "Komentar",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Komentar_UspjesnaPricaId",
                table: "Komentar",
                column: "UspjesnaPricaId");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnik_UlogaId",
                table: "Korisnik",
                column: "UlogaId");

            migrationBuilder.CreateIndex(
                name: "UQ_Korisnik_KorisnickoIme",
                table: "Korisnik",
                column: "KorisnickoIme",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Obavijest_DonacijaId",
                table: "Obavijest",
                column: "DonacijaId");

            migrationBuilder.CreateIndex(
                name: "IX_Obavijest_KandidatId",
                table: "Obavijest",
                column: "KandidatId");

            migrationBuilder.CreateIndex(
                name: "IX_TakmicarProfil_KorisnikId",
                table: "TakmicarProfil",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_UspjesnaPrica_KandidatId",
                table: "UspjesnaPrica",
                column: "KandidatId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Komentar");

            migrationBuilder.DropTable(
                name: "Obavijest");

            migrationBuilder.DropTable(
                name: "UspjesnaPrica");

            migrationBuilder.DropTable(
                name: "Donacija");

            migrationBuilder.DropTable(
                name: "Donor");

            migrationBuilder.DropTable(
                name: "Kandidat");

            migrationBuilder.DropTable(
                name: "TakmicarProfil");

            migrationBuilder.DropTable(
                name: "Kategorija");

            migrationBuilder.DropTable(
                name: "Korisnik");

            migrationBuilder.DropTable(
                name: "PodKategorija");

            migrationBuilder.DropTable(
                name: "Uloga");
        }
    }
}
