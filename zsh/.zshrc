#y Lines configured by zsh-newuser-install
bindkey -e
bindkey "^[[3~" delete-char
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source ~/.zsh_profile

eval "$(starship init zsh)"

. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"
source <(kubectl completion zsh)
