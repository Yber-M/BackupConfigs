#!/usr/bin/env bash

# Si EWW está colgado, levantar daemon limpio
if ! pgrep -x eww >/dev/null; then
    eww daemon >/tmp/eww.log 2>&1 &
    sleep 0.5
fi

# Alternar el estado verificando directamente las ventanas activas en eww
if eww active-windows | grep -q "media"; then
    eww close media 2>/dev/null
else
    eww open media 2>/tmp/eww-media-open.log
fi
