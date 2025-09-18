using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PodrziMe.Services.Migrations
{
    /// <inheritdoc />
    public partial class AddKorisnik : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Korisniks_Ulogas_UlogaId",
                table: "Korisniks");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Ulogas",
                table: "Ulogas");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Korisniks",
                table: "Korisniks");

            migrationBuilder.RenameTable(
                name: "Ulogas",
                newName: "Uloga");

            migrationBuilder.RenameTable(
                name: "Korisniks",
                newName: "Korisnik");

            migrationBuilder.RenameIndex(
                name: "IX_Korisniks_UlogaId",
                table: "Korisnik",
                newName: "IX_Korisnik_UlogaId");

            migrationBuilder.AlterColumn<string>(
                name: "NazivUloge",
                table: "Uloga",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<string>(
                name: "Telefon",
                table: "Korisnik",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "LozinkaSalt",
                table: "Korisnik",
                type: "nvarchar(200)",
                maxLength: 200,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<string>(
                name: "LozinkaHash",
                table: "Korisnik",
                type: "nvarchar(200)",
                maxLength: 200,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<string>(
                name: "KorisnickoIme",
                table: "Korisnik",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<string>(
                name: "Email",
                table: "Korisnik",
                type: "nvarchar(255)",
                maxLength: 255,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK__Uloga__DCAB23CB44AA88F0",
                table: "Uloga",
                column: "UlogaId");

            migrationBuilder.AddPrimaryKey(
                name: "PK__Korisnik__80B06D4132BAFC0E",
                table: "Korisnik",
                column: "KorisnikId");

            migrationBuilder.AddForeignKey(
                name: "FK__Korisnik__UlogaI__6383C8BA",
                table: "Korisnik",
                column: "UlogaId",
                principalTable: "Uloga",
                principalColumn: "UlogaId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK__Korisnik__UlogaI__6383C8BA",
                table: "Korisnik");

            migrationBuilder.DropPrimaryKey(
                name: "PK__Uloga__DCAB23CB44AA88F0",
                table: "Uloga");

            migrationBuilder.DropPrimaryKey(
                name: "PK__Korisnik__80B06D4132BAFC0E",
                table: "Korisnik");

            migrationBuilder.RenameTable(
                name: "Uloga",
                newName: "Ulogas");

            migrationBuilder.RenameTable(
                name: "Korisnik",
                newName: "Korisniks");

            migrationBuilder.RenameIndex(
                name: "IX_Korisnik_UlogaId",
                table: "Korisniks",
                newName: "IX_Korisniks_UlogaId");

            migrationBuilder.AlterColumn<string>(
                name: "NazivUloge",
                table: "Ulogas",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "Telefon",
                table: "Korisniks",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "LozinkaSalt",
                table: "Korisniks",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(200)",
                oldMaxLength: 200);

            migrationBuilder.AlterColumn<string>(
                name: "LozinkaHash",
                table: "Korisniks",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(200)",
                oldMaxLength: 200);

            migrationBuilder.AlterColumn<string>(
                name: "KorisnickoIme",
                table: "Korisniks",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "Email",
                table: "Korisniks",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(255)",
                oldMaxLength: 255,
                oldNullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_Ulogas",
                table: "Ulogas",
                column: "UlogaId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Korisniks",
                table: "Korisniks",
                column: "KorisnikId");

            migrationBuilder.AddForeignKey(
                name: "FK_Korisniks_Ulogas_UlogaId",
                table: "Korisniks",
                column: "UlogaId",
                principalTable: "Ulogas",
                principalColumn: "UlogaId");
        }
    }
}
