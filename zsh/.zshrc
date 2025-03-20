bindkey "^[[3~" delete-char

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
# AWS CLI completions
autoload -U +X bashcompinit && bashcompinit
complete -C $(which aws_completer) aws
complete -C $(which aws_completer) aws2
complete -C $(which aws_completer) aws-sso

# End of Docker CLI completions

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
