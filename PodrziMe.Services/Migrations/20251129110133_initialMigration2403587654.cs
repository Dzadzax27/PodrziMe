using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace PodrziMe.Services.Migrations
{
    /// <inheritdoc />
    public partial class initialMigration2403587654 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Donacija",
                columns: new[] { "DonacijaId", "DatumDonacije", "DonorId", "IznosDonacije", "KandidatId" },
                values: new object[,]
                {
                    { 13, new DateOnly(2025, 10, 15), 1, 450, 8 },
                    { 14, new DateOnly(2025, 11, 20), 3, 700, 8 },
                    { 15, new DateOnly(2025, 9, 30), 2, 520, 9 },
                    { 16, new DateOnly(2025, 12, 5), 4, 650, 9 },
                    { 17, new DateOnly(2025, 8, 18), 4, 480, 10 },
                    { 18, new DateOnly(2025, 11, 28), 2, 900, 10 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Donacija",
                keyColumn: "DonacijaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Donacija",
                keyColumn: "DonacijaId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Donacija",
                keyColumn: "DonacijaId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Donacija",
                keyColumn: "DonacijaId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Donacija",
                keyColumn: "DonacijaId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "Donacija",
                keyColumn: "DonacijaId",
                keyValue: 18);
        }
    }
}
