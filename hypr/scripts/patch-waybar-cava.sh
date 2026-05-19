#!/usr/bin/env bash

CONFIG="$HOME/.config/waybar/config.jsonc"

sleep 3

python - <<'PY'
from pathlib import Path

p = Path.home() / ".config/waybar/config.jsonc"
s = p.read_text()

# Center: agregar cava
if '"custom/cava"' not in s:
    s = s.replace(
'''"hyprland/workspaces",
            "hyprland/window"''',
'''"hyprland/workspaces",
            "custom/cava",
            "hyprland/window"'''
    )

    s = s.replace(
'''    "modules-right": [''',
'''    "custom/cava": {
        "exec": "/home/yb-m/.config/waybar/scripts/cava.sh",
        "format": "{}",
        "return-type": "json",
        "tooltip": false,
        "restart-interval": 1,
        "on-click": "/home/yb-m/.config/eww/scripts/toggle-media.sh"
    },
    "modules-right": ['''
    )

# Left: reemplazar cpu/memory por custom
s = s.replace(
'''        "modules": [
            "cpu",
            "memory"
        ]''',
'''        "modules": [
            "custom/cpu",
            "custom/ram",
            "custom/disk"
        ]'''
)

# Insertar módulos custom CPU/RAM/DISK
if '"custom/cpu": {' not in s:
    s = s.replace(
'''    "modules-left": [''',
'''    "custom/cpu": {
        "exec": "top -bn1 | grep 'Cpu(s)' | awk '{print int($2)}'",
        "interval": 2,
        "format": "󰍛 {}%"
    },
    "custom/ram": {
        "exec": "free -h | awk '/Mem:/ {print $3}'",
        "interval": 3,
        "format": "󰘚 {}"
    },
    "custom/disk": {
        "exec": "df -h / | awk 'NR==2 {print $3\\"/\\"$2}'",
        "interval": 30,
        "format": "󰋊 {}"
    },
    "modules-left": ['''
    )

p.write_text(s)
PY
