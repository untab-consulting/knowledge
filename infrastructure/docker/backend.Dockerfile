# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/sdk:10.0-alpine AS build
WORKDIR /src

COPY src/backend/Knowledge.Api/Knowledge.Api.csproj ./Knowledge.Api/
RUN dotnet restore ./Knowledge.Api/Knowledge.Api.csproj

COPY src/backend/Knowledge.Api/ ./Knowledge.Api/
RUN dotnet publish ./Knowledge.Api/Knowledge.Api.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0-alpine AS runtime
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080

RUN apk add --no-cache wget \
    && addgroup -S knowledge \
    && adduser -S knowledge -G knowledge

COPY --from=build /app/publish ./
RUN mkdir -p /app/data/content /app/data/imports /app/data/backups \
    && chown -R knowledge:knowledge /app

USER knowledge
EXPOSE 8080
ENTRYPOINT ["dotnet", "Knowledge.Api.dll"]
