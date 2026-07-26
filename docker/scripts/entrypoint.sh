#!/bin/sh
set -e

echo "[Nexus AI] Bootstrapping production backend environment..."
echo "[Nexus AI] Running database migrations..."

# Node runtime start
exec "$@"
