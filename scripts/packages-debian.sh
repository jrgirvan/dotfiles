#!/bin/bash
# scripts/packages-debian.sh
# Install base packages on Debian 13 (headless server)
# Cross-platform tools are managed by mise (see mise/config.toml)
set -e

echo "Installing Debian packages..."

sudo apt-get update
sudo apt-get install -y \
  build-essential \
  curl \
  git \
  graphviz \
  locales \
  luarocks \
  stow \
  tree \
  unzip \
  watch \
  zsh

# Ensure UTF-8 locale exists (needed for starship/nerd font glyphs)
if ! locale -a 2>/dev/null | grep -q "en_US.utf8"; then
  echo "Generating en_US.UTF-8 locale..."
  sudo sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
  sudo locale-gen
fi

echo "Done. Debian packages installed."
