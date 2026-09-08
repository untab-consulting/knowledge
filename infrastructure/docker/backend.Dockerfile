# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/sdk:10.0-alpine AS build
WORKDIR /src

COPY src/backend/ ./
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0-alpine AS runtime
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080

RUN addgroup -S knowledge && adduser -S knowledge -G knowledge
COPY --from=build /app/publish ./
RUN mkdir -p /app/data/content /app/data/imports /app/data/backups \
    && chown -R knowledge:knowledge /app

USER knowledge
EXPOSE 8080
ENTRYPOINT ["dotnet", "Knowledge.Api.dll"]
