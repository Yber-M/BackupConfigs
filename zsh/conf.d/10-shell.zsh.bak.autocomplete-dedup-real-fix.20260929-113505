#!/usr/bin/env zsh

[[ $- == *i* ]] || return

# Historial
export HISTFILE="$ZDOTDIR/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Completions propias disponibles antes de cargar OMZ.
fpath=("$ZDOTDIR/completions" "${fpath[@]}")


# Autocompletado predictivo tipo PSReadLine ListView.
# Muestra coincidencias del historial automáticamente mientras escribimos.
zstyle ':autocomplete:*' default-context history-incremental-search-backward

# Mostrar sugerencias desde el primer carácter.
zstyle ':autocomplete:*' min-input 1

# Máximo de líneas para las sugerencias del historial.
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8

if [[ -r /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git
    sudo
    zsh-256color
    zsh-syntax-highlighting
)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# Funciones propias
for file in "$ZDOTDIR/functions/"*.zsh(N); do
    source "$file"
done

# Completions propias
for file in "$ZDOTDIR/completions/"*.zsh(N); do
    source "$file"
done

# Mantener Ctrl+R como búsqueda manual con fzf.
if (( $+widgets[fzf-history-widget] )); then
    bindkey '^R' fzf-history-widget
fi

# Aliases que antes proporcionaba HyDE.
alias c='clear'
alias in='yay -S'
alias un='yay -Rns'
alias up='yay -Syu'
alias pl='yay -Qs'
alias pa='yay -Ss'
alias vc='code'
alias fastfetch='~/.local/bin/random-fastfetch.sh'

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias mkdir='mkdir -p'

# Configuración personal actual.
[[ -r "$ZDOTDIR/.zshrc" ]] && source "$ZDOTDIR/.zshrc"

# Fastfetch automático al abrir Kitty.
if [[ -n "${KITTY_WINDOW_ID:-}" && -x "$HOME/.local/bin/random-fastfetch.sh" ]]; then
   "$HOME/.local/bin/random-fastfetch.sh"
fi

# Oh My Posh - tema Montys local.
if command -v oh-my-posh >/dev/null 2>&1; then
   eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/montys.omp.json")"
fi

# Separación visual entre comando, salida y siguiente prompt.
autoload -Uz add-zsh-hook

typeset -g _YB_COMMAND_RAN=0

_yb_command_spacing_preexec() {
    print
    _YB_COMMAND_RAN=1
}

_yb_command_spacing_precmd() {
    if (( _YB_COMMAND_RAN )); then
        print
        _YB_COMMAND_RAN=0
    fi
}

add-zsh-hook preexec _yb_command_spacing_preexec
add-zsh-hook precmd  _yb_command_spacing_precmd

# Política final de historial.
# Se aplica después de OMZ/plugins para evitar que otro módulo la sobrescriba.
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Bindings finales estables para zsh-autocomplete.

# ↑ / ↓: entrar y navegar sugerencias.
bindkey -M main '^[[A' up-line-or-search
bindkey -M main '^[OA'  up-line-or-search

bindkey -M main '^[[B' down-line-or-select
bindkey -M main '^[OB'  down-line-or-select

# ← / →: cursor normal fuera del menú.
bindkey -M main '^[[D' backward-char
bindkey -M main '^[OD'  backward-char

bindkey -M main '^[[C' forward-char
bindkey -M main '^[OC'  forward-char

# Tab: completion normal, incluso con historial predictivo activo.
if (( $+widgets[yb-smart-tab] )); then
    bindkey -M main '^I' yb-smart-tab
else
    bindkey -M main '^I' complete-word
fi

# Menú interactivo de zsh-autocomplete.
bindkey -M menuselect '^I' menu-complete

bindkey -M menuselect '^[[A' up-history
bindkey -M menuselect '^[OA'  up-history

bindkey -M menuselect '^[[B' down-history
bindkey -M menuselect '^[OB'  down-history

bindkey -M menuselect '^[[D' backward-char
bindkey -M menuselect '^[OD'  backward-char

bindkey -M menuselect '^[[C' forward-char
bindkey -M menuselect '^[OC'  forward-char

# Paginación nativa de zsh-autocomplete.
zmodload -F zsh/terminfo p:terminfo

if [[ -n "${terminfo[kpp]-}" ]]; then
    bindkey -M menuselect "$terminfo[kpp]" backward-word
fi

if [[ -n "${terminfo[knp]-}" ]]; then
    bindkey -M menuselect "$terminfo[knp]" forward-word
fi

# Ctrl+R: búsqueda profunda con fzf.
if (( $+widgets[fzf-history-widget] )); then
    bindkey -M main '^R' fzf-history-widget
fi

