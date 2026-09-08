# Unraid deployment

Knowledge is designed around the Unraid `appdata` convention for persistent application state.

## Recommended host layout

```text
/mnt/user/appdata/knowledge/
├── postgres/
├── redis/
├── meilisearch/
├── content/
├── imports/
└── backups/
```

Large knowledge datasets should **not** be stored inside Docker's writable container layer.

## Deployment

1. Create `/mnt/user/appdata/knowledge` on the Unraid array or preferred cache/pool.
2. Copy `.env.example` to `.env` outside version control.
3. Set strong passwords/secrets in `.env`.
4. Adjust `KNOWLEDGE_APPDATA` if the appdata root is different.
5. Review CPU/RAM/storage requirements before enabling large datasets.
6. Deploy with Docker Compose through the Unraid Compose Manager or equivalent Compose tooling.
7. Expose only the frontend/reverse-proxy entry point to the LAN.
8. Keep PostgreSQL, Redis and Meilisearch on the internal Docker network.
9. Prefer a reverse proxy for HTTPS and external access.

## Important Unraid rules

- Persist state under `/mnt/user/appdata/knowledge`.
- Do not bind application data to a temporary container path.
- Do not expose PostgreSQL, Redis or Meilisearch directly to the LAN unless there is a specific administrative requirement.
- Back up `appdata/knowledge` according to the backup strategy before importing large datasets.
- Keep downloaded datasets separate from application configuration.
- Use dedicated storage pools/cache where appropriate for database/search performance.

## First deployment

Start with the smallest stack and validate health checks before importing any content:

```bash
docker compose config
docker compose up -d --build
docker compose ps
```

Then verify the frontend endpoint and the API health endpoint from inside the Docker network.
