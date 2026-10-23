#!/bin/sh
set -e

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups"
BACKUP_FILE="${BACKUP_DIR}/nexus_db_backup_${TIMESTAMP}.sql"

mkdir -p ${BACKUP_DIR}

echo "[Database Backup] Starting PostgreSQL dump to ${BACKUP_FILE}..."
pg_dump -h ${DB_HOST:-postgres} -U ${DB_USERNAME:-nexus} ${DB_DATABASE:-nexus_ai_prod} > ${BACKUP_FILE}
echo "[Database Backup] Backup complete!"
