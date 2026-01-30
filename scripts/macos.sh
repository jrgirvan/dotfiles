#!/bin/bash
# scripts/macos.sh
set -e

echo "Setting macOS defaults..."

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mru-spaces -bool false

# Finder
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Screenshots
defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"
mkdir -p "$HOME/Pictures/screenshots"

# Touch ID for sudo
# Note: Requires manual setup or admin tools; this is a reference
# sudo sed -i .bak 's/^#.*pam_tid.so/auth sufficient pam_tid.so/' /etc/pam.d/sudo

# Restart Dock for changes to take effect
killall Dock 2>/dev/null || true

echo "✅ macOS defaults applied"
