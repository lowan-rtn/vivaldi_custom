#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="${VERSION:-0.1.0}"
PKG_NAME="vivaldi-custom"
STAGE="$ROOT/build/deb/${PKG_NAME}_${VERSION}_all"
OUT_DIR="$ROOT/dist"

rm -rf "$STAGE"
mkdir -p \
  "$STAGE/DEBIAN" \
  "$STAGE/usr/share/vivaldi-custom" \
  "$STAGE/usr/bin" \
  "$STAGE/etc/skel/.config/vivaldi-css" \
  "$STAGE/etc/skel/.local/share/applications" \
  "$STAGE/etc/skel/.local/share/icons/custom" \
  "$STAGE/etc/skel/.local/share/icons/hicolor/scalable/apps" \
  "$STAGE/etc/skel/.local/share/icons/WhiteSur/apps/scalable"

cp -a "$ROOT/package/vivaldi-css/." "$STAGE/usr/share/vivaldi-custom/vivaldi-css/"
cp -a "$ROOT/package/applications/." "$STAGE/usr/share/vivaldi-custom/applications/"
cp -a "$ROOT/package/icons/." "$STAGE/usr/share/vivaldi-custom/icons/"

cp -a "$ROOT/package/vivaldi-css/." "$STAGE/etc/skel/.config/vivaldi-css/"
cp -a "$ROOT/package/applications/." "$STAGE/etc/skel/.local/share/applications/"
cp -a "$ROOT/package/icons/custom/." "$STAGE/etc/skel/.local/share/icons/custom/"
cp -a "$ROOT/package/icons/hicolor/scalable/apps/." "$STAGE/etc/skel/.local/share/icons/hicolor/scalable/apps/"
cp -a "$ROOT/package/icons/WhiteSur/apps/scalable/." "$STAGE/etc/skel/.local/share/icons/WhiteSur/apps/scalable/"

install -m 0755 "$ROOT/scripts/vivaldi-custom-apply.sh" "$STAGE/usr/bin/vivaldi-custom-apply"

cat > "$STAGE/DEBIAN/control" <<EOF
Package: $PKG_NAME
Version: $VERSION
Section: web
Priority: optional
Architecture: all
Maintainer: lowan-rtn <lowan.rtn@icloud.com>
Depends: bash, coreutils, desktop-file-utils, libc-bin, passwd
Recommends: vivaldi-stable
Description: Safari-like customization bundle for Vivaldi
 Installs icons, desktop overrides and CSS mods for a macOS-like
 Vivaldi setup. The package can be installed before Vivaldi itself; once
 Vivaldi is present, run vivaldi-custom-apply for the target user.
EOF

cat > "$STAGE/DEBIAN/postinst" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

for home_dir in /home/*; do
  [[ -d "$home_dir" ]] || continue
  user_name="$(basename "$home_dir")"
  if id -u "$user_name" >/dev/null 2>&1; then
    /usr/bin/vivaldi-custom-apply "$user_name" || true
  fi
done

if ! command -v vivaldi-stable >/dev/null 2>&1; then
  echo "vivaldi-custom installed. Install vivaldi-stable, then run:"
  echo "  sudo vivaldi-custom-apply <user>"
fi
EOF

chmod 0755 "$STAGE/DEBIAN/postinst"

mkdir -p "$OUT_DIR"
dpkg-deb --root-owner-group --build "$STAGE" "$OUT_DIR/${PKG_NAME}_${VERSION}_all.deb"

echo "Built package: $OUT_DIR/${PKG_NAME}_${VERSION}_all.deb"
