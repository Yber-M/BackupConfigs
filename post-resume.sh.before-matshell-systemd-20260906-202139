#!/bin/bash
sleep 2
if ! pgrep -f "ags run" >/dev/null; then
  hyprctl dispatch exec "ags run"
fi
