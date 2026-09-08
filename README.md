# Knowledge

> A self-hosted, offline-first knowledge platform for learning, discovering and managing a personal knowledge library.

Knowledge is designed for **Unraid/Docker** and aims to bring together Wikipedia, books, articles, maps, films, series, video games and eventually local AI/RAG in a single modular application.

The project is inspired by [Project NOMAD](https://github.com/crosstalk-solutions/project-nomad), but is intended to be broader, more modular and extensible.

---

## Vision

Knowledge should become a **personal offline knowledge server** that remains useful even when the internet is unavailable.

Core principles:

- **Local-first** — data and services run on hardware controlled by the user.
- **Offline-first** — core content remains accessible without internet access.
- **Modular** — each content domain is an independent module.
- **Searchable** — one global search across all content types.
- **Extensible** — new modules should be addable without rewriting the platform.
- **Private** — no mandatory external analytics or cloud AI.
- **Fun** — discovery, statistics and gamification make exploration engaging.

---

## Planned modules

| Module | Version | Status |
|---|---|---|
| Platform / Docker / Unraid | V1 | Planned |
| Authentication | V1 | Planned |
| Wikipedia | V1 | Planned |
| Books | V1 | Planned |
| Articles & documents | V1 | Planned |
| Global search | V1 | Planned |
| Tags & collections | V1 | Planned |
| Films & series | V2 | Planned |
| Video games | V2 | Planned |
| Gamification | V2 | Planned |
| Personal statistics | V2 | Planned |
| Surprise / discovery | V2 | Planned |
| Offline maps | V3 | Planned |
| Automatic map updates | V3 | Planned |
| Complete offline mode | V3 | Planned |
| Monitoring & observability | V3 | Planned |
| Backup & restore | V3 | Planned |
| Local AI | V4 | Planned |
| RAG | V4 | Planned |
| Knowledge Assistant | V4 | Planned |
| Semantic search | V4 | Planned |
| Recommendations | V4 | Planned |

See the [GitHub Issues](https://github.com/untab-consulting/knowledge/issues) for the implementation backlog.

---

## Target architecture

The initial architecture is intentionally modular:

```text
                         ┌─────────────────────┐
                         │   Angular Frontend  │
                         └──────────┬──────────┘
                                    │
                             HTTP / WebSocket
                                    │
                         ┌──────────▼──────────┐
                         │ ASP.NET Core Backend│
                         └──────────┬──────────┘
                                    │
              ┌─────────────────────┼─────────────────────┐
              │                     │                     │
       ┌──────▼──────┐       ┌──────▼──────┐       ┌──────▼──────┐
       │ PostgreSQL  │       │Search Engine │       │    Redis    │
       └─────────────┘       └─────────────┘       └─────────────┘
              │                     │                     │
              └─────────────────────┼─────────────────────┘
                                    │
                         ┌──────────▼──────────┐
                         │ Local Content Store │
                         └──────────┬──────────┘
                                    │
        ┌────────────┬──────────────┼──────────────┬────────────┐
        │            │              │              │            │
     Wikipedia     Books         Articles        Maps      Media/Games

                     Future: Local AI / RAG
```

### Initial technology targets

- **Frontend:** Angular
- **Backend:** ASP.NET Core / .NET
- **Database:** PostgreSQL
- **Search:** Meilisearch or OpenSearch
- **Cache / jobs:** Redis
- **Reverse proxy:** Traefik or Nginx Proxy Manager
- **Deployment:** Docker / Unraid
- **Maps:** OpenStreetMap-based datasets
- **Local AI:** Ollama, vLLM or equivalent

These are **initial targets**, not immutable decisions. Technology choices should be validated during implementation.

---

# Getting started

The project is being built incrementally. Follow the steps below **in order**.

## Step 0 — Prerequisites

Install or have access to:

- Git
- Docker
- Docker Compose
- An Unraid server for deployment/testing
- .NET SDK compatible with the selected ASP.NET Core version
- Node.js + npm
- Angular CLI
- PostgreSQL client/tools (optional but useful)

Verify the basic tools:

```bash
git --version
docker --version
docker compose version
dotnet --version
node --version
npm --version
ng version
```

---

## Step 1 — Clone the repository

```bash
git clone https://github.com/untab-consulting/knowledge.git
cd knowledge
```

---

## Step 2 — Define the repository structure

Create the initial modular structure before implementing business features.

Suggested structure:

```text
knowledge/
├── src/
│   ├── frontend/              # Angular application
│   ├── backend/               # ASP.NET Core API
│   ├── worker/                # Imports, indexing and scheduled jobs
│   └── shared/                # Shared contracts/models when necessary
├── modules/
│   ├── wikipedia/
│   ├── books/
│   ├── articles/
│   ├── movies/
│   ├── games/
│   └── maps/
├── infrastructure/
│   ├── docker/
│   ├── unraid/
│   └── proxy/
├── data/                      # Local development data only
├── docs/
├── scripts/
├── docker-compose.yml
├── .env.example
└── README.md
```

Do not commit production data, secrets, generated indexes or downloaded datasets.

---

## Step 3 — Bootstrap Docker / Unraid

Implement the base infrastructure first:

1. PostgreSQL container
2. Redis container
3. Search engine container
4. Backend container
5. Frontend container
6. Persistent volumes
7. Internal Docker networking
8. Environment/configuration management
9. Health checks

The Unraid deployment should use persistent application-data directories rather than storing large datasets inside ephemeral containers.

---

## Step 4 — Create the ASP.NET Core backend

Create the backend and establish the API foundation.

Minimum requirements:

- Configuration through environment variables
- Dependency injection
- Structured logging
- Health endpoint
- PostgreSQL connection
- Redis connection
- Search-engine abstraction
- API versioning strategy
- Error handling
- Authentication-ready architecture

Keep domain modules isolated from infrastructure concerns.

---

## Step 5 — Create the Angular frontend

Create the Angular application with a modular UI architecture.

Initial screens:

- Login
- Dashboard
- Global search
- Library/content browser
- Content details
- Settings

The frontend should communicate with the backend through a typed API layer rather than directly accessing databases or storage.

---

## Step 6 — Implement authentication

Implement authentication before adding user-specific features.

Requirements:

- User accounts
- Secure password handling or an external identity provider
- Session/token management
- Authorization model
- User-specific data isolation
- Secure configuration for secrets

Never commit credentials or tokens to Git.

---

## Step 7 — Design the PostgreSQL data model

Define the core entities before implementing the content modules.

The model should support:

- Users
- Content items
- Content types/modules
- Metadata
- Tags
- Collections
- Favorites
- Progress/status
- Activity history
- Achievements/XP
- Synchronization state

Avoid coupling the database schema to a single content provider.

---

## Step 8 — Implement the module system

Create a stable contract for modules.

Each module should define, as appropriate:

- Metadata model
- Importer
- Storage strategy
- Search/indexing strategy
- API endpoints
- Frontend views
- Synchronization rules

Adding a new module should not require modifying unrelated modules.

---

## Step 9 — Implement local content storage

Define a predictable storage hierarchy for large datasets.

Example:

```text
/mnt/user/appdata/knowledge/
├── database/
├── search/
├── wikipedia/
├── books/
├── articles/
├── movies/
├── games/
├── maps/
├── ai/
└── backups/
```

Keep metadata in PostgreSQL while large binary/dataset content lives in dedicated persistent storage.

---

## Step 10 — Implement global search

Start with lexical search and design the abstraction so semantic/vector search can be added later.

Search should support:

- All modules
- Title/content matching
- Tags
- Content type filters
- User-specific visibility
- Ranking
- Pagination

Later V4 work will add hybrid lexical + vector search.

---

## Step 11 — Integrate Wikipedia offline

Implement the first major content importer.

Process:

1. Select the supported Wikipedia dataset/source.
2. Download it into persistent storage.
3. Validate the dataset.
4. Import/index metadata.
5. Build searchable content.
6. Expose articles through the API.
7. Render articles in Angular.
8. Track dataset version and import status.
9. Make the content available without internet access.

The importer must be resumable and must not leave the active dataset unusable after a failed update.

---

## Step 12 — Add books and articles/documents

Reuse the module/import infrastructure instead of creating one-off implementations.

For each content source:

1. Define metadata.
2. Define storage format.
3. Implement importer.
4. Validate imported data.
5. Index content.
6. Add API endpoints.
7. Add frontend views.
8. Add global search integration.

---

## Step 13 — Build the Dashboard

The dashboard should become the entry point to Knowledge.

Initial widgets:

- Recently accessed content
- Continue reading/watching
- Favorites
- Collections
- Search
- Random discovery
- Import/synchronization status

---

## Step 14 — Add tags and collections

Implement cross-module organization.

Tags and collections must work across books, articles, Wikipedia and future modules without requiring module-specific implementations.

---

# V2 — Expansion and gamification

After V1 is stable:

1. Add films and series.
2. Integrate with Jellyfin where appropriate rather than duplicating media-server functionality.
3. Add video games and platform metadata.
4. Add XP, levels and achievements.
5. Add personal statistics.
6. Add the **Surprise Me** discovery feature.
7. Extend global search to every new module.

---

# V3 — Offline platform

After V2 is stable:

1. Integrate OpenStreetMap-based offline maps.
2. Add local POI search.
3. Add automatic map dataset updates.
4. Implement atomic dataset replacement and rollback.
5. Add complete offline/PWA behavior.
6. Add monitoring and observability.
7. Implement backup and restore.
8. Test recovery from a clean installation.

The objective is that Knowledge remains genuinely useful with the external network disconnected.

---

# V4 — Local AI and intelligence

Only after the local content pipeline is stable:

1. Integrate a local LLM runtime.
2. Build the embedding/indexing pipeline.
3. Implement RAG over Knowledge content.
4. Add source citations to generated answers.
5. Add the Knowledge Assistant.
6. Add hybrid semantic search.
7. Add local recommendations.
8. Harden security before exposing the service externally.

AI must remain optional. Core Knowledge functionality must not depend on a cloud provider.

---

# Development workflow

For each feature:

1. Pick the corresponding GitHub Issue.
2. Create a dedicated branch.
3. Implement the smallest coherent change.
4. Add/update tests.
5. Update documentation when behavior changes.
6. Run the relevant checks locally.
7. Commit with a clear message.
8. Open a Pull Request.
9. Review the change.
10. Merge only when acceptance criteria are satisfied.
11. Close the corresponding issue.

Recommended branch naming:

```text
feature/<short-name>
fix/<short-name>
chore/<short-name>
docs/<short-name>
```

Recommended commit style:

```text
feat: add wikipedia importer
fix: preserve dataset on failed sync
docs: update unraid installation
chore: update docker dependencies
```

---

# Quality rules

- No secrets in Git.
- No production data in Git.
- No hard-coded host paths.
- No module-specific hacks in shared infrastructure.
- Prefer idempotent import/synchronization jobs.
- Prefer resumable long-running operations.
- Keep large datasets outside containers.
- Add health checks to infrastructure services.
- Make destructive operations explicit.
- Keep backups independently restorable.
- Test offline behavior explicitly.
- Keep external dependencies replaceable where practical.

---

# Current status

The project is currently in the **initialization / V1 architecture phase**.

The implementation backlog is tracked through GitHub Issues. The immediate priority is to establish the repository structure and infrastructure before implementing the first content modules.

**Next step:** complete **Issue #2 — `[V1] Initialiser la structure Docker/Unraid`**.

---

## License

License: **TBD**. Do not assume a license for the project until one is explicitly selected and committed to the repository.
