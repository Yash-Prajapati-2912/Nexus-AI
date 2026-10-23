# Nexus AI Backend

Production-grade NestJS backend foundation for the Nexus AI Student Life Operating System.

---

## Quick Start Setup (For Developers)

Follow these steps to set up and run the backend server locally.

### 1. Prerequisites
Ensure you have the following installed on your system:
* [Node.js (v20+)](https://nodejs.org/)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
* Package Manager: `pnpm` (recommended) or `npm`

---

### 2. Environment Configuration
Copy the configuration template to create your local `.env` file:
```bash
cp .env.example .env
```
Open the `.env` file. The defaults are preconfigured for local development. 
> **Note on Port Conflicts**: If you already have another PostgreSQL database running locally on the default port `5432`, edit `.env` and `.env.development` to change `DATABASE_PORT=5432` to `5433` (or any free port).

---

### 3. Spin Up the Database
Start the containerized PostgreSQL database service using Docker Compose:
```bash
docker compose -f docker-compose.dev.yml up -d postgres
```

---

### 4. Install Dependencies
Install all package dependencies:
```bash
pnpm install
# OR: npm install
```

---

### 5. Apply Migrations & Seed Data
Create the database tables and populate them with the initial development data:
```bash
# Run migrations to create schema
pnpm run migration:run

# Seed default mock data
pnpm run seed
```

---

### 6. Start the Server
Run the NestJS application in watch mode (auto-reloads on file changes):
```bash
pnpm run start:dev
```

Once running successfully, you can access the following:
* **API Documentation (Swagger)**: [http://localhost:3000/api/docs](http://localhost:3000/api/docs)
* **System Health Endpoint**: [http://localhost:3000/api/v1/health](http://localhost:3000/api/v1/health)
* **API Base URL**: `http://localhost:3000/api/v1`

---

## Database Commands Cheat Sheet

* **Generate new migration**: `npx ts-node -r tsconfig-paths/register ./node_modules/typeorm/cli.js migration:generate -d ./src/database/data-source.ts ./src/database/migrations/[MigrationName]`
* **Run pending migrations**: `pnpm run migration:run`
* **Revert latest migration**: `pnpm run migration:revert`
* **Re-run seeder**: `pnpm run seed`
