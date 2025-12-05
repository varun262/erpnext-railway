# Lightweight image for bench + ERPNext (dev)
FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /app

# Install minimal system deps and Node 18
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl build-essential wget git ca-certificates gnupg \
    libxrender1 libxext6 libx11-6 \
    && rm -rf /var/lib/apt/lists/*

# Node 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Redis (we'll try to start a local instance if possible)
RUN apt-get update && apt-get install -y redis-server || true || rm -rf /var/lib/apt/lists/*

# Install bench (pip)
RUN pip install --no-cache-dir frappe-bench

# Copy scripts
COPY setup.sh /app/setup.sh
COPY start.sh /app/start.sh
COPY requirements.txt /app/requirements.txt
RUN chmod +x /app/setup.sh /app/start.sh

# Run setup at build time (creates site & app code but skips heavy asset build)
RUN /app/setup.sh

EXPOSE 8000
CMD ["/app/start.sh"]
