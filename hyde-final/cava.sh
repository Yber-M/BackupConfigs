#!/usr/bin/env bash

cava -p ~/.config/cava/waybar-config | while read -r line; do
  bars=""
  for (( i=0; i<${#line}; i++ )); do
    n="${line:$i:1}"
    case "$n" in
      0) bars+="▁" ;;
      1) bars+="▂" ;;
      2) bars+="▃" ;;
      3) bars+="▄" ;;
      4) bars+="▅" ;;
      5) bars+="▆" ;;
      6) bars+="▇" ;;
      7) bars+="█" ;;
      *) bars+="▁" ;;
    esac
  done

  printf '{"text":"%s","tooltip":"Audio visualizer"}\n' "$bars"
done
