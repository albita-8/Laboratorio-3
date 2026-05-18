# Frontend
FROM node:24-alpine AS build-frontend
WORKDIR /usr/app
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build

# Backend
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS build-backend
WORKDIR /usr/app
COPY backend/*.csproj ./
RUN dotnet restore
COPY backend/ ./
RUN dotnet publish -c Release -o out

# Imagen final
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /usr/app
COPY --from=build-backend /usr/app/out ./
COPY --from=build-frontend /usr/app/dist ./wwwroot
CMD ["dotnet", "MangaApi.dll"]
