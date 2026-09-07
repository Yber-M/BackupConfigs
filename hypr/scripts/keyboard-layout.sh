#!/usr/bin/env bash
set -euo pipefail

hyprctl switchxkblayout all next >/dev/null

layout="$(
    hyprctl devices -j |
    jq -r '
        .keyboards[]
        | select(.main == true)
        | .active_keymap
    ' |
    head -n 1
)"

[[ -n "$layout" && "$layout" != "null" ]] || layout="Layout cambiado"

notify-send \
    -a "Teclado" \
    -r 91190 \
    -t 800 \
    -i input-keyboard-symbolic \
    "$layout"
