#!/usr/bin/env bash
set -euo pipefail

# quick helper to retry network ops
retry() {
  n=0
  until [ $n -ge 3 ]
  do
    "$@" && break
    n=$((n+1))
    echo "Retry $n for: $*"
    sleep 2
  done
}

# init bench (skip heavy assets)
bench init --frappe-branch version-14 --skip-assets erpnext-dev

cd erpnext-dev

# fetch ERPNext app
bench get-app erpnext --branch version-14

# create site with SQLite and default admin
bench new-site demo.localhost --db-type=sqlite --admin-password=admin --no-mariadb-socket

# install app
bench --site demo.localhost install-app erpnext

# don't build assets here (start.sh will do it at runtime)

