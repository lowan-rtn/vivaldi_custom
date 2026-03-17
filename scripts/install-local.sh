#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p \
  "$HOME/.config/vivaldi-css" \
  "$HOME/.local/share/applications" \
  "$HOME/.local/share/icons/custom" \
  "$HOME/.local/share/icons/hicolor/scalable/apps" \
  "$HOME/.local/share/icons/WhiteSur/apps/scalable"

cp -a "$ROOT/package/vivaldi-css/." "$HOME/.config/vivaldi-css/"
cp -a "$ROOT/package/applications/." "$HOME/.local/share/applications/"
cp -a "$ROOT/package/icons/custom/." "$HOME/.local/share/icons/custom/"
cp -a "$ROOT/package/icons/hicolor/scalable/apps/." "$HOME/.local/share/icons/hicolor/scalable/apps/"
cp -a "$ROOT/package/icons/WhiteSur/apps/scalable/." "$HOME/.local/share/icons/WhiteSur/apps/scalable/"

update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
kbuildsycoca6 >/dev/null 2>&1 || true

echo "Vivaldi custom bundle installed."
