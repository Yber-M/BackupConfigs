#!/usr/bin/env bash

CONFIG="$HOME/.config/waybar/config.jsonc"

# Esperar a que HyDE regenere config
sleep 3

# Si ya existe custom/cava no hacer nada
grep -q '"custom/cava"' "$CONFIG" && exit 0

python - <<'PY'
from pathlib import Path

p = Path.home() / ".config/waybar/config.jsonc"
s = p.read_text()

# Insertar módulo en center
s = s.replace(
'''"hyprland/workspaces",
            "hyprland/window"''',
'''"hyprland/workspaces",
            "custom/cava",
            "hyprland/window"'''
)

# Insertar definición del módulo
insert = '''
    "custom/cava": {
        "exec": "/home/yb-m/.config/waybar/scripts/cava.sh",
        "format": "{}",
        "return-type": "json",
        "tooltip": false,
        "restart-interval": 1,
        "on-click": "/home/yb-m/.config/eww/scripts/toggle-media.sh"
    },
'''

s = s.replace(
'''    "modules-right": [''',
insert + '''
    "modules-right": ['''
)

p.write_text(s)
PY
