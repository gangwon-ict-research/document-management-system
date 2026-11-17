#!/bin/bash
# Build OpenKM.war inside Docker and copy it to ./dist
set -euo pipefail

cd "$(dirname "$0")"

GIT_SHA=$(git rev-parse --short=7 HEAD 2>/dev/null || echo unknown)
DEST=${DEST:-dist}

DOCKER_BUILDKIT=1 docker build \
  --target artifact \
  --build-arg GIT_SHA="${GIT_SHA}" \
  --output type=local,dest="${DEST}" \
  "$@" .

echo "Built: ${DEST}/OpenKM.war (${GIT_SHA})"
