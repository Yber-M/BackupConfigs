#!/usr/bin/env zsh

# Fuerza deduplicación exactamente dentro de la función
# que construye las sugerencias de historial.

autoload -Uz _autocomplete__history_lines

# Guardar una copia de la implementación original.
if (( ! ${+functions[_yb_autocomplete_history_lines_original]} )); then
    functions -c \
        _autocomplete__history_lines \
        _yb_autocomplete_history_lines_original
fi

# Wrapper.
_autocomplete__history_lines() {
    setopt localoptions
    setopt HIST_FIND_NO_DUPS

    _yb_autocomplete_history_lines_original "$@"
}
