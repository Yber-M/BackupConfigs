#!/usr/bin/env bash

if playerctl -l 2>/dev/null | grep -q "^playerctld$"; then
  PLAYER="playerctld"
else
  PLAYER=$(playerctl -l 2>/dev/null | grep -E "^chromium\.instance" | tail -n1)
  if [ -z "$PLAYER" ]; then
    PLAYER=$(playerctl -l 2>/dev/null | grep -E "cider|chromium|spotify" | head -n1)
  fi
fi

if [ -z "$PLAYER" ]; then
  PLAYER=$(playerctl -l 2>/dev/null | head -n1)
fi

if [ -z "$PLAYER" ]; then
  echo '{"title":"Sin reproducción","artist":"Abre Cider","status":"Stopped","pos":"0:00","len":"0:00","percent":"0","art":""}'
  exit 0
fi

title=$(playerctl --player="$PLAYER" metadata --format "{{title}}" 2>/dev/null)
artist=$(playerctl --player="$PLAYER" metadata --format "{{artist}}" 2>/dev/null | head -n1)
status=$(playerctl --player="$PLAYER" status 2>/dev/null)
art=$(playerctl --player="$PLAYER" metadata mpris:artUrl 2>/dev/null)

pos_us=$(playerctl --player="$PLAYER" position 2>/dev/null | awk '{printf "%.0f", $1 * 1000000}')
len_us=$(playerctl --player="$PLAYER" metadata mpris:length 2>/dev/null)

if ! [[ "$pos_us" =~ ^[0-9]+$ ]]; then
  pos_us=0
fi
if ! [[ "$len_us" =~ ^[0-9]+$ ]]; then
  len_us=0
fi
if [ "$len_us" -gt 36000000000 ]; then
  len_us=0
fi
if [ "$len_us" = "0" ]; then
  len_us_alt=$(playerctl --player="$PLAYER" metadata xesam:length 2>/dev/null)
  if [[ "$len_us_alt" =~ ^[0-9]+$ ]] && [ "$len_us_alt" -le 36000000000 ]; then
    len_us="$len_us_alt"
  fi
fi

pos_s=$((pos_us / 1000000))
len_s=$((len_us / 1000000))

format_time() {
  local total="$1"
  local min=$((total / 60))
  local sec=$((total % 60))
  printf "%d:%02d" "$min" "$sec"
}

escape_json() {
  local s="$1"
  s=${s//\\/\\\\}
  s=${s//\"/\\\"}
  printf "%s" "$s"
}

to_css_url() {
  local p="$1"
  if [[ "$p" =~ ^https?:// ]]; then
    printf "%s" "$p"
  else
    printf "file://%s" "$p"
  fi
}

marquee() {
  local text="$1"
  local width="$2"
  local len=${#text}
  if [ "$len" -le "$width" ]; then
    printf "%s" "$text"
    return
  fi

  local now_ms
  now_ms=$(date +%s%3N)
  local cycle=$((now_ms % 9000))

  if [ "$cycle" -lt 3000 ] || [ "$cycle" -ge 6000 ]; then
    printf "%s" "${text:0:width}"
    return
  fi

  local progress=$((cycle - 3000))
  local max_offset=$((len - width))
  local offset=$((progress * max_offset / 3000))
  printf "%s" "${text:offset:width}"
}

if [ "$len_s" -gt 0 ]; then
  percent=$(awk -v p="$pos_s" -v l="$len_s" 'BEGIN { printf "%.2f", (p * 100) / l }')
else
  percent=0
fi

pos=$(format_time "$pos_s")
if [ "$len_s" -gt 0 ]; then
  rem_s=$((len_s - pos_s))
  if [ "$rem_s" -lt 0 ]; then rem_s=0; fi
  len="-"$(format_time "$rem_s")
else
  len="--:--"
fi

if [ -n "$art" ]; then
  # Convertir portada si viene como file://
  art="${art#file://}"
else
  art=""
fi

if [ "$status" != "Playing" ] && [ -z "$title" ] && [ -z "$artist" ]; then
  art=""
fi

art_rot="$art"
if command -v magick >/dev/null 2>&1; then
  IM_CMD="magick"
elif command -v convert >/dev/null 2>&1; then
  IM_CMD="convert"
else
  IM_CMD=""
fi

if [ -n "$IM_CMD" ] && [ -n "$art" ] && [ "$status" = "Playing" ]; then
  state_dir="/tmp/eww-media"
  mkdir -p "$state_dir"
  rot_path="$state_dir/cover-rot-$$"

  now_ms=$(date +%s%3N)
  angle=$(awk -v t="$now_ms" 'BEGIN { a=(t*0.02)%360; printf "%.2f", a }')

  "$IM_CMD" "$art" -auto-orient -resize 140x140^ -gravity center -extent 140x140 \
    -rotate "$angle" -background none -gravity center -extent 140x140 "$rot_path" 2>/dev/null

  if [ -f "$rot_path" ]; then
    art_rot="$rot_path"
     # Limpiar las demas imagenes para evitar llenado de tmp
     find "$state_dir" -name 'cover-rot-*' -not -name "cover-rot-$$" -maxdepth 1 -delete 2>/dev/null
  fi
else
  state_dir="/tmp/eww-media"
  find "$state_dir" -name 'cover-rot-*' -maxdepth 1 -delete 2>/dev/null
fi

title_safe=$(escape_json "${title:-Sin reproducción}")
artist_safe=$(escape_json "${artist:-Desconocido}")
status_safe=$(escape_json "${status:-Stopped}")
art_safe=$(escape_json "$art")
art_rot_safe=$(escape_json "$art_rot")
art_css_safe=$(escape_json "$(to_css_url "$art")")
art_rot_css_safe=$(escape_json "$(to_css_url "$art_rot")")

title_display=$(marquee "$title_safe" 20)
artist_display=$(marquee "$artist_safe" 20)

echo "{\"title\":\"$title_safe\",\"artist\":\"$artist_safe\",\"title_display\":\"$title_display\",\"artist_display\":\"$artist_display\",\"status\":\"$status_safe\",\"pos\":\"$pos\",\"len\":\"$len\",\"percent\":\"$percent\",\"art\":\"$art_safe\",\"art_rot\":\"$art_rot_safe\",\"art_css\":\"$art_css_safe\",\"art_rot_css\":\"$art_rot_css_safe\"}"
