# Nexus AI Enterprise Production Deployment Guide

## 🚀 Overview
This manual details the procedures, architecture, environment configuration, and operational runbooks for deploying and scaling the **Nexus AI Student Life Operating System** backend in enterprise production environments.

---

## 🏗 Architecture Architecture & Topology

- **Web Application Framework**: NestJS (TypeScript, Node.js 20)
- **Database Engine**: PostgreSQL 16 (Relational DB with TypeORM)
- **Caching & Event Bus**: Redis 7 & BullMQ
- **Reverse Proxy**: NGINX (HTTP/2, SSL/TLS, Gzip, Rate Limiting)
- **Observability Stack**:
  - OpenTelemetry SDK (Distributed Tracing & Metrics)
  - Prometheus (Metrics Aggregation)
  - Grafana (Visualization Dashboards)
  - Loki & Promtail (Structured Log Aggregation)
  - Jaeger (Distributed Tracing UI)

---

## 🛠 Local & Staging Deployment

To spin up the local development stack:
```bash
docker-compose -f docker-compose.yml up --build -d
```

To spin up the complete production observability stack locally:
```bash
docker-compose -f docker-compose.prod.yml up --build -d
```

---

## 🔐 Environment Variables Checklist

| Variable Name | Default / Example | Purpose |
|---|---|---|
| `NODE_ENV` | `production` | Environment mode |
| `PORT` | `3000` | Application HTTP port |
| `DB_HOST` | `postgres` | PostgreSQL database host |
| `DB_PORT` | `5432` | PostgreSQL database port |
| `DB_USERNAME` | `nexus` | DB username |
| `DB_PASSWORD` | `<secure-password>` | DB password |
| `DB_DATABASE` | `nexus_ai_prod` | DB schema name |
| `REDIS_HOST` | `redis` | Redis host |
| `REDIS_PORT` | `6379` | Redis port |
| `JWT_SECRET` | `<secure-256bit-secret>` | JWT Signing secret |
| `STORAGE_PROVIDER` | `CLOUDINARY` \| `S3` \| `LOCAL` | Media storage provider |

---

## 🔄 Zero-Downtime Deployment & Rollback Strategy

1. **Blue/Green Deployment**: Launch new container version alongside active container, verify health probes on port 3000.
2. **NGINX Reload**: Execute `nginx -s reload` to instantly switch incoming traffic to new container pool.
3. **Rollback**: If error rate spikes on Prometheus dashboard, revert NGINX upstream target to previous container build.

---

## 📊 Operations & Backup Runbook

### Automated Database Backup
```bash
docker exec -it nexus_backend_prod /usr/src/app/docker/scripts/backup-db.sh
```

### Database Restoration
```bash
docker exec -it nexus_backend_prod /usr/src/app/docker/scripts/restore-db.sh /backups/nexus_db_backup.sql
```
