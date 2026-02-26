#!/bin/bash
set -e

IMAGE="$1"
SERVICES="$2"

echo "=== Deploy triggered ==="
echo "Image: ${IMAGE}"
echo "Services: ${SERVICES}"

echo "=== Pulling new image ==="
docker pull "${IMAGE}"

echo "=== Restarting services ==="
cd /app
for service in ${SERVICES}; do
  echo "Restarting ${service}..."
  docker compose up -d --no-deps --force-recreate "${service}"
done

echo "=== Cleanup old images ==="
docker image prune -f

echo "=== Done ==="
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
