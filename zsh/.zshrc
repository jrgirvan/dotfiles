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
