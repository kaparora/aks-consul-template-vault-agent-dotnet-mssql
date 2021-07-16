# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY projectapi/*.csproj ./
RUN dotnet restore

# copy everything else and build app
COPY projectapi/. ./
RUN dotnet publish -c Release -o out

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
RUN ls
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "projectapi.dll"]