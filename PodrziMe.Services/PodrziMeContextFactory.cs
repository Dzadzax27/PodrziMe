using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace PodrziMe.Services.Database
{
    public class PodrziMeContextFactory : IDesignTimeDbContextFactory<PodrziMeContext>
    {
        public PodrziMeContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<PodrziMeContext>();

            optionsBuilder.UseSqlServer(
                "Server=localhost,1434;Database=PodrziMe;User ID=sa;Password=QWElkj132!;TrustServerCertificate=True");

            return new PodrziMeContext(optionsBuilder.Options);
        }
    }
}
