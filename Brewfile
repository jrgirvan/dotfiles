# Brewfile - macOS only
# Cross-platform tools are managed by mise (see mise/config.toml)
# Work-only tools (aws, k8s, etc.) are in ~/work/.mise.toml

tap "FelixKratz/formulae"
tap "omnisharp/omnisharp-roslyn"
tap "nikitabobko/tap"

# Core (not available in mise)
brew "bash"    # macOS ships bash 3.2 from 2007
brew "git"
brew "zsh"
brew "stow"
brew "tree"
brew "btop"    # aqua backend doesn't support macOS
brew "graphviz" # for go pprof, dot diagrams

# Language servers (not in mise registry)
brew "jdtls"    # not in mise registry
brew "kotlin-language-server" # not in mise registry
brew "lua-language-server" # not in mise registry
brew "luarocks" # not in mise registry, needed for SbarLua
brew "watch"

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
cask "docker-desktop"

cask "font-jetbrains-mono-nerd-font"
