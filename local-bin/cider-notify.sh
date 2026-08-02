#!/bin/bash
CACHE_DIR="$HOME/.cache/cider-notify"
mkdir -p "$CACHE_DIR"

playerctl -p cider --follow metadata --format $'{{title}}\t{{artist}}\t{{mpris:artUrl}}' 2>/dev/null | \
while IFS=$'\t' read -r title artist arturl; do
  [ -z "$title" ] && continue

  img_path="$CACHE_DIR/current.jpg"
  if [ -n "$arturl" ]; then
    curl -sL -o "$img_path" "$arturl" 2>/dev/null
  fi

  if [ -s "$img_path" ]; then
    notify-send -a "Apple Music" -i "$img_path" "$title" "$artist"
  else
    notify-send -a "Apple Music" -i "audio-x-generic" "$title" "$artist"
  fi
done
