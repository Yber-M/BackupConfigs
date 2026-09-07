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

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git
    sudo
    zsh-256color
    zsh-autosuggestions
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

# Starship: una sola inicialización.
if command -v starship >/dev/null 2>&1; then
    export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
    eval "$(starship init zsh)"
fi
