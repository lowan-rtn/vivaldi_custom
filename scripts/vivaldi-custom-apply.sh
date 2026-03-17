#!/usr/bin/env bash
set -euo pipefail

TARGET_USER="${1:-${SUDO_USER:-${USER:-}}}"

if [[ -z "$TARGET_USER" ]]; then
  echo "Usage: $0 <user>" >&2
  exit 1
fi

TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
if [[ -z "$TARGET_HOME" || ! -d "$TARGET_HOME" ]]; then
  echo "Home not found for user: $TARGET_USER" >&2
  exit 1
fi

ROOT_DIR="${ROOT_DIR:-/usr/share/vivaldi-custom}"
CSS_SRC="$ROOT_DIR/vivaldi-css"
APP_SRC="$ROOT_DIR/applications"
ICON_SRC="$ROOT_DIR/icons"

install -d \
  "$TARGET_HOME/.config/vivaldi-css" \
  "$TARGET_HOME/.local/share/applications" \
  "$TARGET_HOME/.local/share/icons/custom" \
  "$TARGET_HOME/.local/share/icons/hicolor/scalable/apps" \
  "$TARGET_HOME/.local/share/icons/WhiteSur/apps/scalable"

cp -a "$CSS_SRC/." "$TARGET_HOME/.config/vivaldi-css/"
cp -a "$APP_SRC/." "$TARGET_HOME/.local/share/applications/"
cp -a "$ICON_SRC/custom/." "$TARGET_HOME/.local/share/icons/custom/"
cp -a "$ICON_SRC/hicolor/scalable/apps/." "$TARGET_HOME/.local/share/icons/hicolor/scalable/apps/"
cp -a "$ICON_SRC/WhiteSur/apps/scalable/." "$TARGET_HOME/.local/share/icons/WhiteSur/apps/scalable/"

chown -R "$TARGET_USER:$TARGET_USER" \
  "$TARGET_HOME/.config/vivaldi-css" \
  "$TARGET_HOME/.local/share/applications" \
  "$TARGET_HOME/.local/share/icons/custom" \
  "$TARGET_HOME/.local/share/icons/hicolor" \
  "$TARGET_HOME/.local/share/icons/WhiteSur"

runuser -u "$TARGET_USER" -- update-desktop-database "$TARGET_HOME/.local/share/applications" >/dev/null 2>&1 || true
runuser -u "$TARGET_USER" -- kbuildsycoca6 >/dev/null 2>&1 || true

echo "Applied Vivaldi custom bundle for $TARGET_USER"
