# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

alias ls='eza --icons'
alias ll='eza -lh --icons --group-directories-first'
alias la='eza -lah --icons --group-directories-first'
alias l='eza -lh --icons --group-directories-first'
alias tree='eza --tree --icons'
# End of lines configured by zsh-newuser-install
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/fzf-tab/fzf-tab.plugin.zsh

eval "$(atuin init zsh)"
