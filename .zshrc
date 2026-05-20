# Historial
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

# Aliases
alias ls='eza --icons'
alias ll='eza -lh --icons --group-directories-first'
alias la='eza -lah --icons --group-directories-first'
alias l='eza -lh --icons --group-directories-first'
alias tree='eza --tree --icons'

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/fzf-tab/fzf-tab.plugin.zsh
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Atuin
eval "$(atuin init zsh)"

eval "$(ssh-agent -s)" >/dev/null

ssh-add ~/.ssh/id_ed25519 2>/dev/null
