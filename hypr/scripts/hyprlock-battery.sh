#!/usr/bin/env bash

for bat in /sys/class/power_supply/BAT*; do
    [[ -r "$bat/capacity" ]] || continue

    pct="$(cat "$bat/capacity" 2>/dev/null)"
    status="$(cat "$bat/status" 2>/dev/null)"

    [[ "$pct" =~ ^[0-9]+$ ]] || exit 0

    if [[ "$status" == "Charging" ]]; then
        icon=""
    elif (( pct >= 90 )); then
        icon=""
    elif (( pct >= 65 )); then
        icon=""
    elif (( pct >= 40 )); then
        icon=""
    elif (( pct >= 15 )); then
        icon=""
    else
        icon=""
    fi

    printf '%s %s%%\n' "$icon" "$pct"
    exit 0
done
