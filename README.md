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

## Current status

**Phase: V1 — Base architecture initialized**

The repository now contains the initial application and infrastructure skeleton. The project is not yet feature-complete: the current goal is to validate and stabilize the base stack before implementing the first real content modules.

### Already implemented

- [x] Repository structure initialized
- [x] Docker Compose foundation
- [x] PostgreSQL service
- [x] Redis service
- [x] Meilisearch service
- [x] ASP.NET Core API skeleton
- [x] Angular frontend skeleton
- [x] Nginx frontend container
- [x] API health endpoint
- [x] Docker health checks
- [x] Internal Docker network
- [x] Persistent storage strategy for Unraid
- [x] `.env.example` configuration template
- [x] `.gitignore` / `.dockerignore`
- [x] Non-root API container user
- [x] Unraid deployment documentation skeleton

### Immediate next steps

1. Validate the Docker Compose configuration.
2. Build all containers successfully.
3. Start the complete stack locally.
4. Verify PostgreSQL, Redis and Meilisearch connectivity.
5. Verify API health checks.
6. Verify Angular → Nginx → API communication.
7. Deploy the same stack on Unraid.
8. Validate persistent volumes and permissions.
9. Finalize the ASP.NET Core backend architecture.
10. Finalize the Angular application architecture.

The next functional milestone is **V1 backend implementation**.

---

## Architecture

The initial architecture is intentionally modular:

```text
                         ┌─────────────────────┐
                         │   Angular Frontend  │
                         └──────────┬──────────┘
                                    │
                              Nginx / HTTP
                                    │
                         ┌──────────▼──────────┐
                         │ ASP.NET Core Backend│
                         └──────────┬──────────┘
                                    │
              ┌─────────────────────┼─────────────────────┐
              │                     │                     │
       ┌──────▼──────┐       ┌──────▼──────┐       ┌──────▼──────┐
       │ PostgreSQL  │       │ Meilisearch │       │    Redis    │
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

### Initial technology stack

- **Frontend:** Angular
- **Backend:** ASP.NET Core / .NET
- **Database:** PostgreSQL
- **Search:** Meilisearch
- **Cache / jobs:** Redis
- **Web server / reverse proxy:** Nginx initially; external reverse proxy can be added for deployment
- **Deployment:** Docker / Unraid
- **Maps:** OpenStreetMap-based datasets
- **Local AI:** Ollama, vLLM or equivalent

Technology choices can be revisited as implementation requirements become concrete.

---

## Repository structure

```text
knowledge/
├── src/
│   ├── backend/
│   │   └── Knowledge.Api/
│   └── frontend/
│       └── src/
│
├── infrastructure/
│   ├── docker/
│   │   ├── backend.Dockerfile
│   │   ├── frontend.Dockerfile
│   │   └── nginx.conf
│   └── unraid/
│       └── README.md
│
├── modules/
├── docs/
├── scripts/
├── data/
├── docker-compose.yml
├── .env.example
├── .gitignore
├── .dockerignore
└── README.md
```

`modules/`, `docs/`, `scripts/` and `data/` are reserved for the next implementation stages. Production datasets must not be committed to Git.

---

## Unraid storage architecture

Knowledge follows the Unraid convention of keeping persistent application data outside the container filesystem.

Recommended host layout:

```text
/mnt/user/appdata/knowledge/
├── postgres/
├── redis/
├── meilisearch/
├── content/
├── imports/
├── maps/
├── ai/
└── backups/
```

### Rules

- Containers remain disposable.
- Persistent application state goes under `/mnt/user/appdata/knowledge/`.
- Large datasets must not live inside Docker layers.
- Host paths must be configurable; do not hard-code a personal Unraid path in application code.
- Permissions must be validated when deploying to Unraid.
- Backups must be independent from the active application containers.

The exact mapping of each directory is defined by the Compose configuration and may evolve as modules are implemented.

---

# Getting started

Follow these steps in order.

## Step 0 — Prerequisites

Required for development:

- Git
- Docker
- Docker Compose
- .NET SDK compatible with the selected backend version
- Node.js + npm
- Angular CLI

For deployment/testing:

- Unraid server
- User Shares / appdata storage available

Verify the tools:

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

## Step 2 — Configure the environment

Copy the example configuration:

```bash
cp .env.example .env
```

Edit `.env` and provide local credentials/secrets.

**Never commit `.env`.**

For Unraid, verify that the configured host paths point to the intended `/mnt/user/appdata/knowledge/...` directories.

---

## Step 3 — Validate Docker Compose

Before starting containers:

```bash
docker compose config
```

This should complete without configuration errors.

---

## Step 4 — Build and start the stack

```bash
docker compose up -d --build
```

Inspect the services:

```bash
docker compose ps
docker compose logs -f
```

All required services should become healthy.

---

## Step 5 — Validate infrastructure connectivity

Verify:

- PostgreSQL is reachable by the API.
- Redis is reachable by the API.
- Meilisearch is reachable by the API.
- The API health endpoint reports healthy dependencies.
- Nginx serves the Angular application.
- `/api` requests are correctly forwarded to ASP.NET Core.

Do not move to content import until this baseline is stable.

---

## Step 6 — Deploy on Unraid

1. Clone or deploy the repository on the server.
2. Create the required `/mnt/user/appdata/knowledge/` directories.
3. Review UID/GID and filesystem permissions.
4. Configure `.env` with production-safe values.
5. Validate the Compose configuration.
6. Start the stack.
7. Verify container health.
8. Restart the stack and confirm data persistence.
9. Test that deleting/recreating application containers does not delete persistent data.

The Unraid deployment must behave like the development deployment while keeping persistent data on the host.

---

# V1 — Core platform

The following order is the implementation sequence for V1.

### 1. Infrastructure

**Status: initialized — validation remains**

- [x] Repository skeleton
- [x] Docker Compose
- [x] PostgreSQL
- [x] Redis
- [x] Meilisearch
- [x] Backend container
- [x] Frontend container
- [x] Persistent storage mappings
- [x] Health checks
- [ ] Full local integration test
- [ ] Full Unraid deployment test

Tracked by **Issue #2 — Initialiser la structure Docker/Unraid**.

### 2. Backend

**Status: skeleton initialized — implementation remains**

Next tasks:

- [ ] Establish ASP.NET Core solution architecture
- [ ] Configuration system
- [ ] Dependency injection
- [ ] Structured logging
- [ ] Global error handling
- [ ] PostgreSQL integration
- [ ] Entity Framework Core
- [ ] Redis integration
- [ ] Meilisearch abstraction
- [ ] API versioning strategy
- [ ] Authentication-ready architecture
- [ ] Automated tests

Tracked by **Issue #3 — Mettre en place le backend ASP.NET Core**.

### 3. Frontend

**Status: skeleton initialized — implementation remains**

Next tasks:

- [ ] Angular application architecture
- [ ] Routing
- [ ] Layout/navigation
- [ ] Typed API client
- [ ] Authentication flow
- [ ] Error/loading states
- [ ] Dashboard shell
- [ ] Global search UI
- [ ] Automated tests

Tracked by **Issue #4 — Mettre en place le frontend Angular**.

### 4. Authentication

**Status: not implemented**

- [ ] User accounts
- [ ] Password/security strategy
- [ ] Token/session management
- [ ] Authorization
- [ ] User data isolation
- [ ] Secret management

Tracked by **Issue #5**.

### 5. PostgreSQL data model

**Status: not implemented**

- [ ] Core entities
- [ ] Users
- [ ] Content items
- [ ] Modules/content types
- [ ] Metadata
- [ ] Tags
- [ ] Collections
- [ ] Favorites
- [ ] Progress/status
- [ ] Activity history
- [ ] Synchronization state
- [ ] Migrations

Tracked by **Issue #6**.

### 6. Module system

**Status: not implemented**

Define stable contracts for:

- [ ] Metadata
- [ ] Importers
- [ ] Storage
- [ ] Indexing
- [ ] API
- [ ] Frontend views
- [ ] Synchronization

Tracked by **Issue #7**.

### 7. Local content storage

**Status: storage strategy defined — implementation remains**

- [ ] Finalize directory conventions
- [ ] Content storage abstraction
- [ ] Import staging area
- [ ] Atomic imports
- [ ] Dataset versioning
- [ ] Permissions
- [ ] Cleanup policies

Tracked by **Issue #8**.

### 8. Global search

**Status: Meilisearch infrastructure initialized — application integration remains**

- [ ] Search indexing abstraction
- [ ] Global indexing pipeline
- [ ] Query API
- [ ] Filters
- [ ] Ranking
- [ ] Pagination
- [ ] Cross-module search

Tracked by **Issue #9**.

### 9. Wikipedia offline

**Status: not implemented**

- [ ] Select dataset/source
- [ ] Downloader
- [ ] Validation
- [ ] Importer
- [ ] Indexer
- [ ] Version tracking
- [ ] Resumable import
- [ ] Failure-safe updates
- [ ] Angular article viewer

Tracked by **Issue #10**.

### 10. Books

**Status: not implemented**

Tracked by **Issue #11**.

### 11. Articles & documents

**Status: not implemented**

Tracked by **Issue #12**.

### 12. Dashboard

**Status: not implemented**

Tracked by **Issue #13**.

### 13. Tags & collections

**Status: not implemented**

Tracked by **Issue #14**.

### 14. Synchronization

**Status: not implemented**

- [ ] Job framework
- [ ] Scheduling
- [ ] Import state
- [ ] Progress reporting
- [ ] Retry strategy
- [ ] Failure handling
- [ ] Versioning

Tracked by **Issue #15**.

---

# V2 — Expansion and gamification

After V1 is stable:

- [ ] Films & series — **Issue #16**
- [ ] Video games — **Issue #17**
- [ ] Gamification — **Issue #18**
- [ ] Surprise Me — **Issue #19**
- [ ] Personal statistics — **Issue #20**

For films/series, prefer integrating with Jellyfin where it already provides media-server capabilities rather than duplicating them inside Knowledge.

---

# V3 — Offline platform

After V2 is stable:

- [ ] Offline maps — **Issue #21**
- [ ] Automatic map updates — **Issue #22**
- [ ] Complete offline mode — **Issue #23**
- [ ] Monitoring & observability — **Issue #24**
- [ ] Backup & restore — **Issue #25**

The objective is that Knowledge remains genuinely useful with the external network disconnected.

---

# V4 — Local AI and intelligence

After the local content pipeline is stable:

- [ ] Local AI — **Issue #26**
- [ ] RAG — **Issue #27**
- [ ] Knowledge Assistant — **Issue #28**
- [ ] Semantic search — **Issue #29**
- [ ] Recommendations — **Issue #30**
- [ ] Security hardening — **Issue #31**
- [ ] Documentation / installation — **Issue #32**

AI remains optional. Core Knowledge functionality must not depend on a cloud provider.

---

# Development workflow

For each feature:

1. Select the corresponding GitHub Issue.
2. Create a dedicated branch.
3. Implement the smallest coherent change.
4. Add or update tests.
5. Update documentation when behavior changes.
6. Run relevant checks locally.
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

## License

License: **TBD**. Do not assume a license for the project until one is explicitly selected and committed to the repository.
