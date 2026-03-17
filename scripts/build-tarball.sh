#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$ROOT/dist"
ARCHIVE="$OUT_DIR/vivaldi_custom.tar.gz"

mkdir -p "$OUT_DIR"
tar -C "$ROOT" -czf "$ARCHIVE" package scripts/install-local.sh README.md LICENSE

echo "Archive created: $ARCHIVE"
