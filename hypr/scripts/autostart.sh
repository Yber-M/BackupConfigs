#!/bin/bash

# HyDE/Waybar estable
sleep 3

if ! pgrep -x waybar >/dev/null; then
    hyde-shell reload &
fi

# Apps después
sleep 5

pgrep -x copyq >/dev/null || copyq &
sleep 1

pgrep -f "edge-whatsapp" >/dev/null || gtk-launch whatsapp &
sleep 1

pgrep -f "edge-whatsapp-business" >/dev/null || gtk-launch whatsapp-business &
sleep 1

pgrep -x vesktop >/dev/null || vesktop &
sleep 1

pgrep -x Cider >/dev/null || cider &
