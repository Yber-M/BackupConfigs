#!/bin/bash

# Waybar/HyDE estable
sleep 2

if ! pgrep -x waybar >/dev/null; then
    hyde-shell reload &
fi

# Apps
sleep 2

pgrep -x copyq >/dev/null || copyq &
pgrep -x ferdium >/dev/null || ferdium &
pgrep -x vesktop >/dev/null || vesktop &
pgrep -x Cider >/dev/null || cider &
