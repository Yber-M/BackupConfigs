#!/bin/bash

# Esperar entorno Hyprland
sleep 2

# Solo recargar HyDE si no existe waybar
if ! pgrep -x waybar >/dev/null; then
    hyde-shell reload &
fi

# Esperar que HyDE regenere config y levante waybar
sleep 5

# Parchear cava
~/.config/hypr/scripts/patch-waybar-cava.sh

# Esperar parche
sleep 1

# Si waybar murió por el patch, levantar UNA sola
if ! pgrep -x waybar >/dev/null; then
    waybar >/tmp/waybar.log 2>&1 &
fi

# Apps
sleep 2

pgrep -x copyq >/dev/null || copyq &
pgrep -x ferdium >/dev/null || ferdium &
pgrep -x vesktop >/dev/null || vesktop &
pgrep -x Cider >/dev/null || cider &
