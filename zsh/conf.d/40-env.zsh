# Environment variables

export XDG_CONFIG_HOME=$HOME/.config

# Locale (needed for unicode/nerd font glyphs over SSH)
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# Editor
export EDITOR=nvim
export GIT_EDITOR=nvim
export KUBE_EDITOR=nvim

# Misc
export LESS='-R'

# Dotnet
export DOTNET_ROOT=$HOME/.dotnet
