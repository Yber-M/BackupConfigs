#!/usr/bin/env bash

STATE="/tmp/hypr-gamemode"

if [ -f "$STATE" ]; then
    # OFF → volver normal
    hyprctl keyword animations:enabled 1
    hyprctl keyword decoration:blur:enabled true
    hyprctl keyword decoration:active_opacity 0.95
    hyprctl keyword decoration:inactive_opacity 0.90

    notify-send "GameMode OFF"
    rm "$STATE"
else
    # ON → sólido + rendimiento
    hyprctl keyword animations:enabled 0
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword decoration:active_opacity 1.0
    hyprctl keyword decoration:inactive_opacity 1.0

    notify-send "GameMode ON"
    touch "$STATE"
fi
