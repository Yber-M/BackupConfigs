#!/bin/bash
CACHE_DIR="$HOME/.cache/cider-notify"
mkdir -p "$CACHE_DIR"

playerctl -p cider --follow metadata --format '{{title}}|||{{artist}}|||{{mpris:artUrl}}' 2>/dev/null | while IFS='|||' read -r title artist arturl; do
  [ -z "$title" ] && continue

  img_path="$CACHE_DIR/current.jpg"
  if [ -n "$arturl" ]; then
    curl -s -o "$img_path" "$arturl" 2>/dev/null
  fi

  if [ -s "$img_path" ]; then
    notify-send -a "Cider" -i "$img_path" "$title" "$artist"
  else
    notify-send -a "Cider" -i "audio-x-generic" "$title" "$artist"
  fi
done
