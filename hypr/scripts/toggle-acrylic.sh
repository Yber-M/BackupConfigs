#!/usr/bin/env bash

STATE="/tmp/hypr-acrylic-solid"
APPLY="$HOME/.config/hypr/scripts/apply-visual-mode.sh"

if [[ -f "$STATE" ]]; then
    rm -f "$STATE"
    "$APPLY"
    notify-send "Blur ON" "Transparencia activado"
else
    touch "$STATE"
    "$APPLY"
    notify-send "Blur OFF" "Transparencia desactivado"
fi
