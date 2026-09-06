#!/usr/bin/env bash
set -euo pipefail

profile="${1:-}"

case "$profile" in
    default) profile="dynamic" ;;
    dynamic|fast|optimized) ;;
    *)
        echo "Uso: set-animation.sh {default|dynamic|fast|optimized}"
        exit 1
        ;;
esac

file="$HOME/.config/hypr/animations/$profile.lua"
active="$HOME/.config/hypr/animations/active.lua"

test -f "$file" || {
    echo "No existe: $file"
    exit 1
}

ln -sfn "$file" "$active"
hyprctl reload

echo
echo "Perfil activo:"
readlink -f "$active"

echo
echo "Config errors:"
hyprctl configerrors
