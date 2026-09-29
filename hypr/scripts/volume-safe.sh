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
