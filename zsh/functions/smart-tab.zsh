#!/usr/bin/env zsh

# TAB independiente del historial predictivo.
#
# - Solo completa directorios del filesystem.
# - Nunca utiliza sugerencias de history.
# - Cada Tab cicla entre coincidencias sobre LA MISMA línea.
# - No imprime descripciones internas de completion.

autoload -Uz _generic

# No permitir que zsh-autocomplete repinte historial
# como consecuencia de pulsar este widget.
zstyle ':autocomplete:yb-smart-tab:*' ignore yes

# Este widget usa exclusivamente _files.
zstyle ':completion:yb-smart-tab:*' completer _files

# Solo directorios.
zstyle ':completion:yb-smart-tab:*' \
    file-patterns '*(/):directories'

zstyle ':completion:yb-smart-tab:*' \
    tag-order directories

# No mostrar textos internos como:
# directory *(#q-/)...:globbed-files
zstyle ':completion:yb-smart-tab:*:descriptions' format ''
zstyle ':completion:yb-smart-tab:*:messages'     format ''
zstyle ':completion:yb-smart-tab:*:warnings'     format ''

# Sin encabezados/grupos adicionales.
zstyle ':completion:yb-smart-tab:*' group-name ''

# Widget separado del completion predictivo.
# menu-complete hace que cada Tab pase a la siguiente carpeta
# sin crear un prompt nuevo.
zle -C yb-smart-tab menu-complete _generic
