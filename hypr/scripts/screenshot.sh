#!/usr/bin/env bash
# Screenshot helper: grim + slurp + swappy
set -euo pipefail

DIR="/home/yb-m/Descargas"
mkdir -p "$DIR"
FILE="$DIR/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

mode="${1:-region}"

freeze_pid=""
edit_tmp=""

cleanup() {
    if [[ -n "${freeze_pid:-}" ]]; then
        kill "$freeze_pid" 2>/dev/null || true
        wait "$freeze_pid" 2>/dev/null || true
        freeze_pid=""
    fi

    if [[ -n "${edit_tmp:-}" && -f "$edit_tmp" ]]; then
        rm -f "$edit_tmp"
    fi
}

trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

start_freeze() {
    hyprpicker -rz >/dev/null 2>&1 &
    freeze_pid=$!

    # Dar tiempo a hyprpicker para mostrar el frame congelado.
    sleep 0.2
}

stop_freeze() {
    if [[ -n "${freeze_pid:-}" ]]; then
        kill "$freeze_pid" 2>/dev/null || true
        wait "$freeze_pid" 2>/dev/null || true
        freeze_pid=""
    fi
}

case "$mode" in
 region)
   start_freeze

   geom="$(slurp)" || exit 1

   grim -g "$geom" "$FILE"

   stop_freeze
   ;;

 edit)
   start_freeze

   geom="$(slurp)" || exit 1

   edit_tmp="$(mktemp /tmp/screenshot-edit.XXXXXX.png)"

   grim -g "$geom" "$edit_tmp"

   # Swappy debe abrir después de descongelar la pantalla.
   stop_freeze

   swappy -f "$edit_tmp" -o "$FILE"
   ;;

 output)
   mon="$(hyprctl activeworkspace -j | jq -r .monitor)"
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
