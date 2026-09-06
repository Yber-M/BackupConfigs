#!/usr/bin/env bash
set -u

action="${1:-text}"

cache="${XDG_CACHE_HOME:-$HOME/.cache}/hyprlock"
url_file="$cache/mpris-art.url"
path_file="$cache/mpris-art.path"

get_player() {
    local p status
    local paused=""

    while IFS= read -r p; do
        [[ -n "$p" ]] || continue

        status="$(playerctl status -p "$p" 2>/dev/null || true)"

        if [[ "$status" == "Playing" ]]; then
            printf '%s\n' "$p"
            return 0
        fi
    done < <(playerctl -l 2>/dev/null || true)

    return 1
}

player="$(get_player || true)"

case "$action" in
    text)
        [[ -n "$player" ]] || exit 0

        playerctl metadata -p "$player" \
            --format '{{title}} — {{artist}}' \
            2>/dev/null || true
        ;;

    art)
        fallback="${XDG_CACHE_HOME:-$HOME/.cache}/hyprlock/transparent.png"

        if [[ -z "$player" ]]; then
            printf '%s\n' "$fallback"
            exit 0
        fi

        url="$(
            playerctl metadata -p "$player" \
                mpris:artUrl 2>/dev/null || true
        )"

        if [[ -z "$url" ]]; then
            printf '%s\n' "$fallback"
            exit 0
        fi

        mkdir -p "$cache"

        if [[ -r "$url_file" && -r "$path_file" ]]; then
            old_url="$(cat "$url_file")"
            old_path="$(cat "$path_file")"

            if [[ "$url" == "$old_url" && -f "$old_path" ]]; then
                printf '%s\n' "$old_path"
                exit 0
            fi
        fi

        tmp="$(mktemp "$cache/.mpris-art.XXXXXX")"

        scheme="${url%%:*}"

        if [[ "$scheme" == "http" || "$scheme" == "https" ]]; then
            if ! curl                 -LfsS                 --connect-timeout 3                 --max-time 8                 "$url"                 -o "$tmp"
            then
                rm -f "$tmp"

                if [[ -r "$path_file" ]]; then
                    old_path="$(cat "$path_file")"
                    [[ -f "$old_path" ]] && printf '%s\n' "$old_path"
                fi

                exit 0
            fi

        elif [[ "$scheme" == "file" ]]; then
            local_path="$(
                python3 -c                 'import sys, urllib.parse; print(urllib.parse.unquote(urllib.parse.urlparse(sys.argv[1]).path))'                 "$url"
            )"

            if [[ ! -f "$local_path" ]]; then
                rm -f "$tmp"
                exit 0
            fi

            cp -- "$local_path" "$tmp"

        else
            rm -f "$tmp"
            exit 0
        fi

        mime="$(file -b --mime-type "$tmp")"

        case "$mime" in
            image/jpeg)
                dest="$cache/mpris-art.jpg"
                ;;
            image/png)
                dest="$cache/mpris-art.png"
                ;;
            image/webp)
                dest="$cache/mpris-art.webp"
                ;;
            *)
                rm -f "$tmp"
                exit 0
                ;;
        esac

        rm -f \
            "$cache/mpris-art.jpg" \
            "$cache/mpris-art.png" \
            "$cache/mpris-art.webp"

        mv "$tmp" "$dest"

        printf '%s' "$url" > "$url_file"
        printf '%s' "$dest" > "$path_file"

        printf '%s\n' "$dest"
        ;;

    next)
        [[ -n "$player" ]] &&
            playerctl -p "$player" next 2>/dev/null || true
        ;;

    previous)
        [[ -n "$player" ]] &&
            playerctl -p "$player" previous 2>/dev/null || true
        ;;

    toggle)
        [[ -n "$player" ]] &&
            playerctl -p "$player" play-pause 2>/dev/null || true
        ;;

    *)
        exit 2
        ;;
esac
