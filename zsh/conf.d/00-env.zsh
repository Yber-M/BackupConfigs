#!/usr/bin/env zsh

# XDG
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-$XDG_DATA_HOME:/usr/local/share:/usr/share}"

# Usuario
[[ ":$PATH:" == *":$HOME/.local/bin:"* ]] || export PATH="$HOME/.local/bin:$PATH"

if command -v xdg-user-dir >/dev/null 2>&1; then
    export XDG_DESKTOP_DIR="${XDG_DESKTOP_DIR:-$(xdg-user-dir DESKTOP)}"
    export XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-$(xdg-user-dir DOWNLOAD)}"
    export XDG_TEMPLATES_DIR="${XDG_TEMPLATES_DIR:-$(xdg-user-dir TEMPLATES)}"
    export XDG_PUBLICSHARE_DIR="${XDG_PUBLICSHARE_DIR:-$(xdg-user-dir PUBLICSHARE)}"
    export XDG_DOCUMENTS_DIR="${XDG_DOCUMENTS_DIR:-$(xdg-user-dir DOCUMENTS)}"
    export XDG_MUSIC_DIR="${XDG_MUSIC_DIR:-$(xdg-user-dir MUSIC)}"
    export XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$(xdg-user-dir PICTURES)}"
    export XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-$(xdg-user-dir VIDEOS)}"
fi

export LESSHISTFILE="${LESSHISTFILE:-/tmp/less-hist}"
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"

# Hyprland actual: configuración Lua.
export HYPRLAND_CONFIG="$XDG_CONFIG_HOME/hypr/hyprland.lua"
