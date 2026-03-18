#!/usr/bin/env bash
set -euo pipefail

# start_frontend_nginx.sh
# Build the frontend and serve it on http://localhost:8060 using nginx (in Docker).
# The nginx config will proxy API requests (/v2/) and OAuth callback paths (/login/oauth2/) to the
# backend gateway running on localhost:8050.
#
# Usage:
#   ./scripts/start_frontend_nginx.sh [--no-docker]
#
# Requirements:
# - Node (npm) to build the frontend
# - Docker (recommended) to run nginx without touching system config
#
# Location assumptions (adjust variables below if your repo layout differs):
FRONTEND_DIR="/home/zhenac/my/lens_2026/migration/lens-migration-frontend/src"
BUILD_DIR_NAME="dist"
WORK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="$WORK_DIR/frontend-dist"
NGINX_CONF="$OUT_DIR/default.conf"
CONTAINER_NAME="lens-frontend-nginx"
HOST_GATEWAY_HOSTNAME="host.docker.internal"
HOST_GATEWAY_PORT=8050
LISTEN_PORT=8060

# Optional flag to skip Docker and only build + generate config
NO_DOCKER=false
if [ "${1:-}" = "--no-docker" ]; then
  NO_DOCKER=true
fi

echo "Working directory: $WORK_DIR"
echo "Frontend dir: $FRONTEND_DIR"

# 1) Build frontend
if [ ! -d "$FRONTEND_DIR" ]; then
  echo "ERROR: frontend directory not found: $FRONTEND_DIR"
  exit 1
fi

echo "Installing frontend dependencies (if needed) and building..."
cd "$FRONTEND_DIR"
if [ -f package-lock.json ] || [ -f package.json ]; then
  # try to install dependencies if node_modules missing
  if [ ! -d node_modules ]; then
    echo "node_modules not found, running npm install (this can take a while)"
    npm install
  fi
else
  echo "Warning: package.json not found in $FRONTEND_DIR. Skipping npm install/build." >&2
fi

# Run build; Vite default outputs to dist/
if npm run | grep -q "build" 2>/dev/null; then
  npm run build
else
  echo "npm run build not found; attempting npx vite build or copying source as-is"
  if command -v npx >/dev/null 2>&1; then
    npx vite build || true
  fi
fi

# 2) Prepare output dir
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

BUILT_DIR="$FRONTEND_DIR/$BUILD_DIR_NAME"
if [ -d "$BUILT_DIR" ]; then
  echo "Copying build output from $BUILT_DIR -> $OUT_DIR"
  cp -r "$BUILT_DIR"/* "$OUT_DIR"/
else
  echo "Warning: build output directory not found ($BUILT_DIR)."
  echo "If you are running dev server instead of building, consider using the '--no-docker' option and run dev locally."
  # Still create a minimal index.html to avoid nginx 404
  cat > "$OUT_DIR/index.html" <<'HTML'
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Lens Frontend (placeholder)</title>
  </head>
  <body>
    <h1>Frontend not built</h1>
    <p>Please run <code>npm run build</code> in the frontend directory first.</p>
  </body>
</html>
HTML
fi

# 3) Create nginx config that serves static files and proxies API/callbacks to gateway
cat > "$NGINX_CONF" <<NGINX
server {
  listen 80;
  server_name localhost;
  root /usr/share/nginx/html;
  index index.html;

  # SPA support: try files, otherwise serve index.html so client-side routing works
  location / {
    try_files \$uri \$uri/ /index.html;
  }

  # Proxy backend API requests to gateway on host
  location /v2/ {
    proxy_pass http://$HOST_GATEWAY_HOSTNAME:$HOST_GATEWAY_PORT;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header Cookie \$http_cookie;
    proxy_read_timeout 120s;
  }

  # OAuth callback endpoints that must reach gateway
  location /login/oauth2/ {
    proxy_pass http://$HOST_GATEWAY_HOSTNAME:$HOST_GATEWAY_PORT;
    proxy_set_header Host \$host;
    proxy_set_header Cookie \$http_cookie;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_read_timeout 120s;
  }

  # Optional: forward any /auth/ or other gateway paths as needed
}
NGINX

echo "Generated nginx config at $NGINX_CONF"

# 4) Start nginx - prefer Docker to avoid changing system config
if [ "$NO_DOCKER" = true ]; then
  echo "--no-docker specified; not starting nginx container. Your static files are at: $OUT_DIR"
  echo "Use your system nginx to serve $OUT_DIR and use the generated config template: $NGINX_CONF"
  exit 0
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker not found. To run nginx easily we recommend installing Docker."
  echo "You can still serve files with system nginx; see $NGINX_CONF for config and serve $OUT_DIR as document root."
  exit 1
fi

# Stop and remove existing container if present
if docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
  echo "Stopping and removing existing container $CONTAINER_NAME"
  docker rm -f "$CONTAINER_NAME" || true
fi

# Run nginx container, mapping host gateway using host-gateway feature so container can reach host:8050
echo "Starting nginx container (name: $CONTAINER_NAME) serving $OUT_DIR -> http://localhost:$LISTEN_PORT"

docker run -d --name "$CONTAINER_NAME" \
  -p $LISTEN_PORT:80 \
  --add-host=$HOST_GATEWAY_HOSTNAME:host-gateway \
  -v "$OUT_DIR":/usr/share/nginx/html:ro \
  -v "$NGINX_CONF":/etc/nginx/conf.d/default.conf:ro \
  nginx:stable

sleep 1

echo "Container started. Access frontend at: http://localhost:$LISTEN_PORT"

echo "To stop and remove the container:"
echo "  docker rm -f $CONTAINER_NAME"

echo "Notes:"
echo " - The nginx container proxy_pass uses $HOST_GATEWAY_HOSTNAME:$HOST_GATEWAY_PORT which maps to host via --add-host=host-gateway."
echo " - Ensure your gateway is running on http://localhost:$HOST_GATEWAY_PORT and that Keycloak callback URL points to http://localhost:$HOST_GATEWAY_PORT/login/oauth2/code/<client>"

echo "Done."

