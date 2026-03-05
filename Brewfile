# Brewfile - macOS only
# Cross-platform tools are managed by mise (see mise/config.toml)
# Work-only tools (aws, k8s, etc.) are in ~/work/.mise.toml

tap "FelixKratz/formulae"
tap "omnisharp/omnisharp-roslyn"
tap "nikitabobko/tap"

# Core (not available in mise)
brew "bash"    # macOS ships bash 3.2 from 2007
brew "btop"    # aqua backend doesn't support macOS
brew "git"
brew "graphviz" # for go pprof, dot diagrams
brew "luarocks" # not in mise registry, needed for SbarLua
brew "stow"
brew "tree"
brew "watch"
brew "zsh"

# GNU tools (replace macOS POSIX versions)
brew "coreutils"
brew "gnu-sed"
brew "gnu-tar"
brew "gawk"
brew "findutils"
brew "grep"

# Container & Docker
brew "docker-compose"
brew "docker-buildx"
brew "docker-credential-helper"

# jj TUI (not in mise registry)
brew "lazyjj"

# macOS-specific tools
brew "sketchybar"
brew "borders"
brew "ical-buddy"
brew "omnisharp-mono"
brew "nowplaying-cli"
brew "switchaudio-osx"

# Casks (GUI apps)
cask "nikitabobko/tap/aerospace"
cask "obsidian"
cask "vmware-fusion"
cask "dbeaver-community"
cask "background-music"
cask "docker"

cask "font-jetbrains-mono-nerd-font"
