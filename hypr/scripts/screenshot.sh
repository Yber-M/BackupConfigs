#!/usr/bin/env bash
# Screenshot helper: grim + slurp + swappy
set -euo pipefail

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

mode="${1:-region}"

case "$mode" in
  region)
    geom=$(slurp) || exit 1
    grim -g "$geom" "$FILE"
    ;;

  edit)
    geom=$(slurp) || exit 1
    grim -g "$geom" - | swappy -f - -o "$FILE"
    ;;

  output)
    mon=$(hyprctl activeworkspace -j | jq -r .monitor)
    grim -o "$mon" "$FILE"
    ;;

  full)
    grim "$FILE"
    ;;

  *)
    echo "modo desconocido: $mode" >&2
    exit 1
    ;;
esac

# Swappy genera el archivo al cerrarse; los demás modos ya lo generan con grim.
if [[ -f "$FILE" ]]; then
    wl-copy < "$FILE"
    notify-send "Screenshot" "Guardado en $FILE" 2>/dev/null || true
fi
