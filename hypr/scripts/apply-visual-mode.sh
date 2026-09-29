#!/usr/bin/env bash

ACRYLIC_STATE="/tmp/hypr-acrylic-solid"
GAME_STATE="/tmp/hypr-gamemode"

set_all_props() {
    local value="$1"
    local addr

    while IFS= read -r addr; do
        [[ -n "$addr" ]] || continue

        hyprctl dispatch \
          "hl.dsp.window.set_prop({ prop = \"force_rgbx\", value = \"$value\", window = \"address:$addr\" })" \
          >/dev/null 2>&1 || true

        hyprctl dispatch \
          "hl.dsp.window.set_prop({ prop = \"opaque\", value = \"$value\", window = \"address:$addr\" })" \
          >/dev/null 2>&1 || true
    done < <(hyprctl clients -j | jq -r '.[].address')
}

# El reload elimina reglas temporales creadas por eval
# y recupera el estado base definido en hyprland.lua.
hyprctl reload >/dev/null
sleep 0.2

# Eliminar overrides anteriores sobre ventanas ya abiertas.
set_all_props 0

if [[ -f "$ACRYLIC_STATE" || -f "$GAME_STATE" ]]; then
    # Regla para ventanas que se abran mientras esté activo el modo sólido.
    hyprctl eval '
        hl.window_rule({
            name = "runtime-solid-all",
            match = { class = ".*" },
            force_rgbx = true,
            opaque = true,
        })
    ' >/dev/null

    # Ventanas que ya están abiertas.
    set_all_props 1

    # Sin transparencia ni blur del compositor.
    hyprctl eval '
        hl.config({
            decoration = {
                active_opacity = 1.0,
                inactive_opacity = 1.0,
                blur = {
                    enabled = false,
                },
            },
        })
    ' >/dev/null
else
    # Estado acrílico normal.
    hyprctl eval '
        hl.config({
            decoration = {
                active_opacity = 0.95,
                inactive_opacity = 0.88,
                blur = {
                    enabled = true,
                },
            },
        })
    ' >/dev/null
fi

if [[ -f "$GAME_STATE" ]]; then
    hyprctl eval '
        hl.config({
            animations = {
                enabled = false,
            },
        })
    ' >/dev/null
else
    hyprctl eval '
        hl.config({
            animations = {
                enabled = true,
            },
        })
    ' >/dev/null
fi
