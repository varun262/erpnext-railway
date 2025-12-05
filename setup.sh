#!/bin/bash
set -e

# Install system dependencies
apt-get update
apt-get install -y curl redis-server python3-dev build-essential

# Install NodeJS 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Install bench
pip install frappe-bench

# Create bench directory
bench init --frappe-branch version-14 erpnext-dev

cd erpnext-dev

# Get ERPNext
bench get-app erpnext --branch version-14

# Create site with SQLite
bench new-site demo.localhost --db-type=sqlite --admin-password=admin

bench --site demo.localhost install-app erpnext
