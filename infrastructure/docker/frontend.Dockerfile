# syntax=docker/dockerfile:1

FROM node:24-alpine AS build
WORKDIR /src

COPY src/frontend/package*.json ./
RUN npm ci
COPY src/frontend/ ./
RUN npm run build -- --configuration production

FROM nginx:alpine AS runtime
COPY infrastructure/docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/dist/frontend/browser /usr/share/nginx/html
EXPOSE 80

HEALTHCHECK --interval=15s --timeout=5s --retries=5 \
  CMD wget --no-verbose --tries=1 --spider http://127.0.0.1/health || exit 1
