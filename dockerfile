FROM python:3.10

# Install Node and Yarn
RUN apt-get update && apt-get install -y curl
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs redis-server

# PDF deps (optional)
RUN apt-get install -y libssl-dev libxrender1 libxext6 libx11-6

# Install bench
RUN pip install frappe-bench

# Create bench
RUN bench init --frappe-branch version-14 erpnext-dev

WORKDIR /erpnext-dev

# Install ERPNext
RUN bench get-app erpnext --branch version-14

# Create site with SQLite
RUN bench new-site demo.localhost --db-type=sqlite --admin-password=admin

# Install app
RUN bench --site demo.localhost install-app erpnext

EXPOSE 8000

CMD ["bench", "start"]
