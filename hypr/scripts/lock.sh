#!/usr/bin/env bash
set -euo pipefail

cache="${XDG_CACHE_HOME:-$HOME/.cache}/hyde/wall.set.png"

# Intentar usar el wallpaper del monitor actualmente activo.
monitor="$(hyprctl activeworkspace -j | jq -r '.monitor')"

wp="$(
    awww query |
    awk -v mon="$monitor" '
        index($0, ": " mon ":") == 1 {
            sub(/^.*currently displaying: image: /, "")
            print
            exit
        }
    '
)"

# Fallback: primer wallpaper informado por awww.
if [[ -z "${wp:-}" || ! -f "$wp" ]]; then
    wp="$(
        awww query |
        sed -n 's/.*currently displaying: image: //p' |
        head -n1
    )"
fi

if [[ -n "${wp:-}" && -f "$wp" ]]; then
    mkdir -p "$(dirname "$cache")"
    ln -sfn "$wp" "$cache"
fi

exec hyprlock
