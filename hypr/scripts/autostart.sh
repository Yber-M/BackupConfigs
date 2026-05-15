#!/bin/bash

# Waybar/HyDE estable
sleep 2

if ! pgrep -x waybar >/dev/null; then
    hyde-shell reload &
fi

# Apps
sleep 2

pgrep -x copyq >/dev/null || copyq &
pgrep -f "\.config/edge-whatsapp " >/dev/null || gtk-launch whatsapp &
pgrep -f "\.config/edge-whatsapp-business" >/dev/null || gtk-launch whatsapp-business &
pgrep -x vesktop >/dev/null || vesktop &
pgrep -x Cider >/dev/null || cider &
