#!/usr/bin/env bash
set -u

action="${1:-}"

laptop="alsa_output.pci-0000_80_1f.3-platform-sof_sdw.HiFi__Speaker__sink"
hdmi="alsa_output.pci-0000_02_00.1.hdmi-stereo"

sink_exists() {
    pactl list short sinks |
        awk '{print $2}' |
        grep -Fxq "$1"
}

move_audio() {
    local sink="$1"

    sink_exists "$sink" || return 1

    pactl set-default-sink "$sink"

    while IFS=$'\t' read -r input _; do
        [[ "$input" =~ ^[0-9]+$ ]] || continue
        pactl move-sink-input "$input" "$sink" 2>/dev/null || true
    done < <(pactl list short sink-inputs)

    return 0
}

case "$action" in
    disconnected)
        move_audio "$laptop"
        ;;

    connected)
        # PipeWire puede tardar un momento en publicar el sink HDMI.
        for _ in {1..20}; do
            if move_audio "$hdmi"; then
                exit 0
            fi
            sleep 0.25
        done

        exit 0
        ;;

    *)
        echo "Uso: audio-hotplug.sh {connected|disconnected}" >&2
        exit 2
        ;;
esac
