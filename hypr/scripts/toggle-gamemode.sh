#!/usr/bin/env bash

STATE="/tmp/hypr-gamemode"

if [ -f "$STATE" ]; then
    hyprctl keyword animations:enabled 1
    hyprctl keyword decoration:blur:enabled true
    notify-send "GameMode OFF"

    rm "$STATE"
else
    hyprctl keyword animations:enabled 0
    hyprctl keyword decoration:blur:enabled false
    notify-send "GameMode ON"

    touch "$STATE"
fi
