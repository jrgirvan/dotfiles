# Lines configured by zsh-newuser-install
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

eval "$(direnv hook zsh)"

# bun completions
[ -s "/Users/john.girvan/.bun/_bun" ] && source "/Users/john.girvan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/john.girvan/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
