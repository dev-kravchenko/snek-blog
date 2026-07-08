#!/usr/bin/env bash
set -euo pipefail

# Hugo version to install; override via HUGO_VERSION env var in Render.
# Stack v4 requires >= 0.157.0 extended.
HUGO_VERSION="${HUGO_VERSION:-0.164.0}"

# Render invokes the build command from the project root — remember it.
PROJECT_DIR="$PWD"

echo "Installing Hugo ${HUGO_VERSION}..."

mkdir -p "${HOME}/bin"
WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

cd "$WORKDIR"

ARCHIVE="hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz"
URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${ARCHIVE}"

wget -q "$URL" || { echo "ERROR: download failed: $URL" >&2; exit 1; }

tar -xzf "$ARCHIVE"

install -m 755 hugo "${HOME}/bin/hugo"
export PATH="${HOME}/bin:${PATH}"

echo "Using $(hugo version)"

cd "$PROJECT_DIR"

hugo --gc --minify
