using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PodrziMe.Services.Migrations.MyDb
{
    /// <inheritdoc />
    public partial class AddKorisnik : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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

            migrationBuilder.CreateIndex(
                name: "IX_Korisnik_UlogaId",
                table: "Korisnik",
                column: "UlogaId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Korisnik");

            migrationBuilder.DropTable(
                name: "Uloga");
        }
    }
}
