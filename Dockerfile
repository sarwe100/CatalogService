

FROM mcr.microsoft.com/dotnet/sdk:3.0 AS build
WORKDIR /src

COPY ["Catalog.API/Catalog.API.csproj", "Catalog.API/"]
RUN dotnet restore "Catalog.API/Catalog.API.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "Catalog.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish  "Catalog.API.csproj" -c Release -o /app

# run the api
FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-alpine AS runtime
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "Catalog.API.dll"]