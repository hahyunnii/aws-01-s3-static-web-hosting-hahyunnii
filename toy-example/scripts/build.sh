#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SRC_DIR="${ROOT_DIR}/src"
DIST_DIR="${ROOT_DIR}/dist"

rm -rf "${DIST_DIR}"
mkdir -p "${DIST_DIR}"
cp -R "${SRC_DIR}/." "${DIST_DIR}/"

echo "Build completed: ${DIST_DIR}"
