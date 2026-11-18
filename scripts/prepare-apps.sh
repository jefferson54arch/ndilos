
#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

SOURCE="$ROOT/apps"
DEST="$ROOT/config/includes.chroot/opt/ndil/apps"
DESKTOP="$ROOT/config/includes.chroot/usr/share/applications"

if [ ! -d "$SOURCE" ]; then
    echo "HATA: apps klasörü bulunamadı."
    exit 1
fi

mkdir -p "$DEST" "$DESKTOP"

count=0

for file in "$SOURCE"/*.py; do
    [ -f "$file" ] || continue
    cp "$file" "$DEST/"
    count=$((count + 1))
done

if [ "$count" -eq 0 ]; then
    echo "HATA: Python uygulaması bulunamadı."
    exit 1
fi

cat > "$DESKTOP/ndil-hub.desktop" <<'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=NDIL Hub
Comment=NDIL OS Application Center
Exec=python3 /opt/ndil/apps/ndil_hub.py
Icon=applications-system
Terminal=false
Categories=System;Utility;
StartupNotify=true
EOF

# Uygulama dosyalarının izinleri
chmod 644 "$DEST"/*.py

# İlk açılış betiğinin çalıştırma izni
FIRST_RUN="$ROOT/config/includes.chroot/usr/local/bin/ndil-first-run"

if [ -f "$FIRST_RUN" ]; then
    chmod 755 "$FIRST_RUN"
fi

echo "$count NDIL uygulaması ISO için hazırlandı."
