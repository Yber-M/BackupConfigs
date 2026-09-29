#!/usr/bin/env bash

STATE="/tmp/hypr-gamemode"
APPLY="$HOME/.config/hypr/scripts/apply-visual-mode.sh"

if [[ -f "$STATE" ]]; then
    rm -f "$STATE"
    "$APPLY"
    notify-send "GameMode OFF"
else
    touch "$STATE"
    "$APPLY"
    notify-send "GameMode ON" "Animaciones OFF + modo sólido"
fi
