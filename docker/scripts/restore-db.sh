#!/bin/sh
set -e

if [ -z "$1" ]; then
  echo "Usage: ./restore-db.sh <path_to_backup_sql>"
  exit 1
fi

RESTORE_FILE="$1"
echo "[Database Restore] Restoring database from ${RESTORE_FILE}..."
psql -h ${DB_HOST:-postgres} -U ${DB_USERNAME:-nexus} -d ${DB_DATABASE:-nexus_ai_prod} < ${RESTORE_FILE}
echo "[Database Restore] Restoration complete!"
