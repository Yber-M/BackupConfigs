#!/bin/bash

LOCK="/tmp/hypr-autostart.lock"

exec 9>"$LOCK"
flock -n 9 || exit 0

sleep 7

~/.config/hypr/scripts/patch-waybar-cava.sh

killall -SIGUSR2 waybar 2>/dev/null

sleep 2
pgrep -x copyq >/dev/null || copyq &
pgrep -x ferdium >/dev/null || ferdium &
pgrep -fi "discord" >/dev/null || discord &
pgrep -x cider >/dev/null || cider &
