
#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
SOURCE="$ROOT/apps"
DEST="$ROOT/config/includes.chroot/opt/ndil/apps"
DESKTOP="$ROOT/config/includes.chroot/usr/share/applications"
FIRST_RUN="$ROOT/config/includes.chroot/usr/local/bin/ndil-first-run"

mkdir -p "$DEST" "$DESKTOP"

count=0

copy_app() {
    source_file="$1"
    target_file="$2"

    if [ ! -f "$source_file" ]; then
        echo "HATA: $source_file bulunamadı."
        exit 1
    fi

    cp "$source_file" "$DEST/$target_file"
    chmod 644 "$DEST/$target_file"
    count=$((count + 1))
}

copy_app "$SOURCE/ndil hub" "ndil_hub.py"
copy_app "$SOURCE/ndil appstore" "ndil_store.py"
copy_app "$SOURCE/ndil settings" "ndil_settings.py"
copy_app "$SOURCE/ndil updater" "ndil_updater.py"
copy_app "$SOURCE/ndil files" "ndil_files.py"
copy_app "$SOURCE/ndil widgets" "ndil_widgets.py"
copy_app "$SOURCE/ndil welcome" "ndil_welcome.py"
copy_app "$SOURCE/terminal" "ndil_terminal.py"
copy_app "$ROOT/ndil about" "ndil_about.py"

create_launcher() {
    id="$1"
    name="$2"
    script="$3"
    category="$4"

    cat > "$DESKTOP/$id.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$name
Exec=/usr/bin/python3 /opt/ndil/apps/$script
Icon=applications-system
Terminal=false
Categories=$category
StartupNotify=true
EOF
}

create_launcher ndil-hub "NDIL Hub" ndil_hub.py "System;Utility;"
create_launcher ndil-store "NDIL Store" ndil_store.py "System;PackageManager;"
create_launcher ndil-settings "NDIL Settings" ndil_settings.py "Settings;"
create_launcher ndil-updater "NDIL Updater" ndil_updater.py "System;Utility;"
create_launcher ndil-about "NDIL About" ndil_about.py "System;"
create_launcher ndil-files "NDIL Files" ndil_files.py "System;FileManager;"
create_launcher ndil-widgets "NDIL Widgets" ndil_widgets.py "Utility;"
create_launcher ndil-terminal "NDIL Terminal" ndil_terminal.py "System;TerminalEmulator;"
create_launcher ndil-welcome "NDIL Welcome" ndil_welcome.py "System;"

if [ -f "$FIRST_RUN" ]; then
    chmod 755 "$FIRST_RUN"
fi

echo "$count NDIL uygulaması hazırlandı."

