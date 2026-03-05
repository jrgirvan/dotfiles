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

# mise: use gh token to avoid GitHub API rate limits for aqua-backed tools
if command -v gh &>/dev/null && gh auth status &>/dev/null 2>&1; then
  export MISE_GITHUB_TOKEN="$(gh auth token)"
fi

# Dotnet
export DOTNET_ROOT=$HOME/.dotnet
