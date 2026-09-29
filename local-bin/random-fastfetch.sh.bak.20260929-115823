#!/bin/bash
ART_DIR="$HOME/.local/share/ascii-art/textart-clean"
CANDIDATES=(
  archery basketball3 bear camel castle4 chess2 cow cow4 dental desktop2
  dragon feathers fish flower girl guitar2 handyoga horse hummingbird
  hummingbird2 medusa mirror1_ff mouth_cyan mouth_red pattern2 pizza1
  pizza2 pomodoro taco trafficlight vburger
)
PICK="${CANDIDATES[$RANDOM % ${#CANDIDATES[@]}]}"
fastfetch --file-raw "$ART_DIR/$PICK"
