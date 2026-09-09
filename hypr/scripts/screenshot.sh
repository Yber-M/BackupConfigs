#!/usr/bin/env bash
# Screenshot helper: wayfreeze + grim + slurp + swappy
set -euo pipefail

DIR="$HOME/Imágenes/Screenshots"
MAX_SHOTS=30

mkdir -p "$DIR"

FILE="$DIR/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

mode="${1:-region}"

freeze_pid=""
edit_tmp=""

cursor_parked=0
orig_x=""
orig_y=""

restore_cursor() {
    if (( cursor_parked )); then
        hyprctl dispatch \
          "hl.dsp.cursor.move({ x = $orig_x, y = $orig_y })" \
          >/dev/null 2>&1 || true

        cursor_parked=0
    fi
}

stop_freeze() {
    if [[ -n "${freeze_pid:-}" ]]; then
        kill "$freeze_pid" 2>/dev/null || true
        wait "$freeze_pid" 2>/dev/null || true
        freeze_pid=""
    fi
}

cleanup() {
    restore_cursor
    stop_freeze

    if [[ -n "${edit_tmp:-}" && -f "$edit_tmp" ]]; then
        rm -f -- "$edit_tmp"
    fi
}

trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

park_cursor() {
    local orig_pos
    local active_mon
    local park_coords
    local park_x
    local park_y

    orig_pos="$(hyprctl cursorpos)"
    orig_x="${orig_pos%%,*}"
    orig_y="${orig_pos##*, }"

    active_mon="$(
        hyprctl activeworkspace -j |
        jq -r '.monitor'
    )"

    # Aparcar en la esquina superior izquierda del monitor activo.
    # El cursor volverá a su posición original antes de ejecutar slurp.
    park_coords="$(
        hyprctl monitors -j |
        jq -r --arg mon "$active_mon" '
            .[]
            | select(.name == $mon)
            | "\(.x + 20) \(.y + 20)"
        ' |
        head -n 1
    )"

    if [[ -z "$park_coords" ]]; then
        echo "No se pudo determinar una posición segura para el cursor." >&2
        return 1
    fi

    park_x="${park_coords%% *}"
    park_y="${park_coords##* }"

    hyprctl dispatch \
      "hl.dsp.cursor.move({ x = $park_x, y = $park_y })" \
      >/dev/null

    cursor_parked=1
}

start_freeze() {
    park_cursor

    # --hide-cursor queda como protección adicional.
    wayfreeze --hide-cursor >/dev/null 2>&1 &
    freeze_pid=$!

    sleep 0.2

    if ! kill -0 "$freeze_pid" 2>/dev/null; then
        restore_cursor
        echo "wayfreeze no pudo iniciar correctamente." >&2
        exit 1
    fi

    # La imagen congelada ya fue creada con el cursor aparcado.
    # Restauramos inmediatamente para seleccionar normalmente.
    restore_cursor

    sleep 0.05
}

prune_screenshots() {
    local -a shots=()
    local i

    mapfile -t shots < <(
        find "$DIR" \
          -maxdepth 1 \
          -type f \
          -name 'screenshot_*.png' \
          -printf '%f\n' |
        sort -r
    )

    if (( ${#shots[@]} <= MAX_SHOTS )); then
        return
    fi

    for ((i = MAX_SHOTS; i < ${#shots[@]}; i++)); do
        rm -f -- "$DIR/${shots[$i]}"
    done
}

case "$mode" in
 region)
   start_freeze

   geom="$(slurp </dev/null)" || exit 1

   sleep 0.08

   grim -g "$geom" "$FILE"

   stop_freeze
   ;;

 edit)
   start_freeze

   geom="$(slurp </dev/null)" || exit 1

   sleep 0.08

   edit_tmp="$(mktemp /tmp/screenshot-edit.XXXXXX.png)"

   grim -g "$geom" "$edit_tmp"

   stop_freeze

   swappy -f "$edit_tmp" -o "$FILE"
   ;;

 output)
   mon="$(hyprctl activeworkspace -j | jq -r '.monitor')"
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

if [[ -f "$FILE" ]]; then
    wl-copy < "$FILE"

    prune_screenshots

    notify-send \
      "Screenshot" \
      "Guardado en $FILE" \
      2>/dev/null || true
fi
