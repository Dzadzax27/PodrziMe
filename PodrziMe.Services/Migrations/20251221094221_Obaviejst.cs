using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PodrziMe.Services.Migrations
{
    /// <inheritdoc />
    public partial class Obaviejst : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "hasBeenSeen",
                table: "Obavijest",
                type: "bit",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "Obavijest",
                keyColumn: "Id",
                keyValue: 1,
                column: "hasBeenSeen",
                value: null);

            migrationBuilder.UpdateData(
                table: "Obavijest",
                keyColumn: "Id",
                keyValue: 2,
                column: "hasBeenSeen",
                value: null);

            migrationBuilder.UpdateData(
                table: "Obavijest",
                keyColumn: "Id",
                keyValue: 3,
                column: "hasBeenSeen",
                value: null);

            migrationBuilder.UpdateData(
                table: "Obavijest",
                keyColumn: "Id",
                keyValue: 4,
                column: "hasBeenSeen",
                value: null);

            migrationBuilder.UpdateData(
                table: "Obavijest",
                keyColumn: "Id",
                keyValue: 5,
                column: "hasBeenSeen",
                value: null);

            migrationBuilder.UpdateData(
                table: "Obavijest",
                keyColumn: "Id",
                keyValue: 6,
                column: "hasBeenSeen",
                value: null);

            migrationBuilder.UpdateData(
                table: "Obavijest",
                keyColumn: "Id",
                keyValue: 7,
                column: "hasBeenSeen",
                value: null);

            migrationBuilder.UpdateData(
                table: "Obavijest",
                keyColumn: "Id",
                keyValue: 8,
                column: "hasBeenSeen",
                value: null);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "hasBeenSeen",
                table: "Obavijest");
        }
    }
}
