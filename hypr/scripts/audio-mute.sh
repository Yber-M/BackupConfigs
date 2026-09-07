#!/usr/bin/env bash
set -euo pipefail

device="${1:-}"

case "$device" in
    output)
        target="@DEFAULT_AUDIO_SINK@"
        replace_id=8

        wpctl set-mute "$target" toggle
        state="$(wpctl get-volume "$target")"

        if [[ "$state" == *"[MUTED]"* ]]; then
            notify-send \
                -a "Audio" \
                -r "$replace_id" \
                -t 1500 \
                -i audio-volume-muted-symbolic \
                "Audio silenciado"
        else
            notify-send \
                -a "Audio" \
                -r "$replace_id" \
                -t 1500 \
                -i audio-volume-high-symbolic \
                "Audio activado"
        fi
        ;;

    input)
        target="@DEFAULT_AUDIO_SOURCE@"
        replace_id=9

        wpctl set-mute "$target" toggle
        state="$(wpctl get-volume "$target")"

        if [[ "$state" == *"[MUTED]"* ]]; then
            notify-send \
                -a "Micrófono" \
                -r "$replace_id" \
                -t 1500 \
                -i microphone-sensitivity-muted-symbolic \
                "Micrófono silenciado"
        else
            notify-send \
                -a "Micrófono" \
                -r "$replace_id" \
                -t 1500 \
                -i microphone-sensitivity-high-symbolic \
                "Micrófono activado"
        fi
        ;;

    *)
        echo "Uso: $0 {input|output}" >&2
        exit 2
        ;;
esac
