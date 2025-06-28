FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 32768


# This stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["WebApplication1/PodrziMe.csproj", "WebApplication1/"]
COPY ["PodrziMe.Model/PodrziMe.Model.csproj", "PodrziMe.Model/"]
COPY ["PodrziMe.Services/PodrziMe.Services.csproj", "PodrziMe.Services/"]
RUN dotnet restore "./WebApplication1/PodrziMe.csproj"
COPY . .
WORKDIR "/src/WebApplication1"
RUN dotnet build "./PodrziMe.csproj" -c $BUILD_CONFIGURATION -o /app/build

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./PodrziMe.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PodrziMe.dll"]