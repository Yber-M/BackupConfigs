#!/usr/bin/env bash
WP_DIR="$HOME/.local/share/Steam/steamapps/workshop/content/431960"
FPS=60

pkill -f linux-wallpaperengine
sleep 1

mapfile -t IDS < <(find "$WP_DIR" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | shuf -n 2)

linux-wallpaperengine --fps "$FPS" \
  --screen-root eDP-1     --clamp border --scaling fill --bg "${IDS[0]}" \
  --screen-root HDMI-A-1  --clamp border --scaling fill --bg "${IDS[1]}"
