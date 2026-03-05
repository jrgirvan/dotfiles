#!/bin/bash
# scripts/packages-arch.sh
# Install base packages on Arch Linux (personal desktop)
# Cross-platform tools are managed by mise (see mise/config.toml)
set -e

echo "Installing Arch packages..."

sudo pacman -Syu --noconfirm

# Core tools not managed by mise
sudo pacman -S --needed --noconfirm \
  base-devel \
  git \
  graphviz \
  luarocks \
  stow \
  tree \
  unzip \
  watch \
  zsh

# Install yay (AUR helper)
if ! command -v yay &>/dev/null; then
  echo "Installing yay..."
  TMPDIR="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$TMPDIR/yay"
  (cd "$TMPDIR/yay" && makepkg -si --noconfirm)
  rm -rf "$TMPDIR"
else
  echo "yay already installed"
fi

# Desktop environment (Hyprland stack)
yay -S --needed --noconfirm \
  hyprland \
  hyprlock \
  hyprpaper \
  hypridle \
  rofi-wayland \
  waybar

echo "Done. Arch packages installed."
