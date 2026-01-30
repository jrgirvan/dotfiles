# Environment variables

export XDG_CONFIG_HOME=$HOME/.config

# Editor
export EDITOR=nvim
export GIT_EDITOR=nvim
export KUBE_EDITOR=nvim

# Misc
export LESS='-R'

# Dotnet
export DOTNET_ROOT=$HOME/.dotnet

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
