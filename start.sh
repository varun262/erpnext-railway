#!/usr/bin/env bash
set -euo pipefail

cd /app/erpnext-dev

# try to start a local redis server (if installed). ignore failure.
redis-server --daemonize yes || true

# build assets at runtime (may be slow on first web request)
bench build --app erpnext || true

# start bench on port 8000 (Render provides $PORT variable)
PORT=${PORT:-8000}
bench start --port $PORT
