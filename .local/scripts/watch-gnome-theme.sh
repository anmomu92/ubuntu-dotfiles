#!/bin/bash

# Run the updater once at the start
~/.local/scripts/update-gnome-terminal-theme.sh

# Monitor all D-Bus messages and filter manually
dbus-monitor --session |
while read -r line; do
    if echo "$line" | grep -q "org.gnome.desktop.interface" && echo "$line" | grep -q "color-scheme"; then
        echo "[INFO] System theme change detected. Updating terminal..."
        ~/.local/scripts/update-gnome-terminal-theme.sh
    fi
done

