# 1️⃣ Base stage sa .NET 8 runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

# 2️⃣ Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore "PodrziMe.Subscriber/PodrziMe.Subscriber.csproj"

# 3️⃣ Publish stage
FROM build AS publish
RUN dotnet publish "PodrziMe.Subscriber/PodrziMe.Subscriber.csproj" -c Release -o /app

# 4️⃣ Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app .

# Preuzmi wait-for-it.sh
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh .
RUN chmod +x wait-for-it.sh

# Koristi wait-for-it da čeka RabbitMQ prije starta
ENTRYPOINT ["./wait-for-it.sh", "podrzime-rabbitmq:5672", "--", "dotnet", "PodrziMe.Subscriber.dll"]
