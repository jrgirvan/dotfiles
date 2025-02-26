zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

export PATH=/opt/homebrew/bin:$PATH

source ~/.config/zsh/zsh_profile

export NIX_CONF_DIR=$HOME/.config/nix

export XDG_CONFIG_HOME="/Users/john.girvan/.config"


eval "$(starship init zsh)"
eval "$(atuin init zsh)"
eval "$(direnv hook zsh)"
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/john.girvan/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
