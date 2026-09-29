#!/usr/bin/env bash

ART_DIR="$HOME/.local/share/ascii-art/textart-clean"
LAST_FILE="$ART_DIR/.last-logo"

mapfile -d '' FILES < <(
    find "$ART_DIR" \
        -maxdepth 1 \
        -type f \
        ! -name '.last-logo' \
        ! -name '.*' \
        -print0
)

COUNT="${#FILES[@]}"

if (( COUNT == 0 )); then
    exec fastfetch
fi

LAST=""
[[ -f "$LAST_FILE" ]] && IFS= read -r LAST < "$LAST_FILE"

# Si solo hay uno, usarlo.
if (( COUNT == 1 )); then
    PICK="${FILES[0]}"
else
    # Evitar repetir inmediatamente el mismo logo.
    while :; do
        PICK="${FILES[RANDOM % COUNT]}"
        [[ "$PICK" != "$LAST" ]] && break
    done
fi

printf '%s\n' "$PICK" > "$LAST_FILE"

exec fastfetch --file-raw "$PICK"
