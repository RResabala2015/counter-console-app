FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /App

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore DotNet.Docker.csproj
# Build and publish a release
RUN dotnet publish -c Release --output ./publish CounterConsoleApp.sln

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build-env /App/publish ./
ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]