#!/usr/bin/env bash

ACTION="$1"
STEP=5

case "$ACTION" in
  i)
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ ${STEP}%+
    ;;
  d)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ ${STEP}%-
    ;;
  m)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    ;;
esac

VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f", $2 * 100}')
SINK=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | grep -oP 'node.description = "\K[^"]+' | head -1)

#notify-send -a "HyDE Notify" -r 8 -t 900 "${VOL}%" "$SINK"
