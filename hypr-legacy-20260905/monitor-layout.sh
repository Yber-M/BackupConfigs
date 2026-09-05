#!/usr/bin/env bash

OUT="$HOME/.config/hypr/workspaces-dynamic.conf"

HDMI_DESC="Samsung Electric Company LS32AG55x HNTTC00172"
LAPTOP_DESC="LG Display 0x07A3"

if hyprctl monitors | grep -q "$HDMI_DESC"; then
cat > "$OUT" <<EOF
workspace=1,monitor:desc:$HDMI_DESC,default:true
workspace=2,monitor:desc:$LAPTOP_DESC,default:true
workspace=3,monitor:desc:$LAPTOP_DESC
workspace=4,monitor:desc:$LAPTOP_DESC
workspace=5,monitor:desc:$LAPTOP_DESC
workspace=6,monitor:desc:$HDMI_DESC
workspace=7,monitor:desc:$HDMI_DESC
workspace=8,monitor:desc:$LAPTOP_DESC
workspace=9,monitor:desc:$LAPTOP_DESC
workspace=10,monitor:desc:$LAPTOP_DESC
EOF
else
cat > "$OUT" <<EOF
workspace=1,monitor:desc:$LAPTOP_DESC,default:true
workspace=2,monitor:desc:$LAPTOP_DESC
workspace=3,monitor:desc:$LAPTOP_DESC
workspace=4,monitor:desc:$LAPTOP_DESC
workspace=5,monitor:desc:$LAPTOP_DESC
workspace=6,monitor:desc:$LAPTOP_DESC
workspace=7,monitor:desc:$LAPTOP_DESC
workspace=8,monitor:desc:$LAPTOP_DESC
workspace=9,monitor:desc:$LAPTOP_DESC
workspace=10,monitor:desc:$LAPTOP_DESC
EOF
fi

sleep 1
hyprctl reload
sleep 1
hyprctl dispatch moveworkspacetomonitor 1 "desc:$HDMI_DESC" 2>/dev/null || true
hyprctl dispatch workspace 1
