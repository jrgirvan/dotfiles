#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing core packages..."
sudo pacman -S --needed --noconfirm - < "$SCRIPT_DIR/core.pkglist"

echo ""
echo "==> Installing yay (AUR helper)..."
if ! command -v yay &> /dev/null; then
    # Install prerequisites for building yay
    sudo pacman -S --needed --noconfirm base-devel git

    # Clone and build yay
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay

    echo "✓ yay installed successfully"
else
    echo "✓ yay already installed"
fi

echo ""
echo "==> Installing AUR core packages..."
yay -S --needed --noconfirm - < "$SCRIPT_DIR/aur-core.pkglist"

echo ""
echo "==> Environment setup..."
# Use gum to ask about environment type
ENV_TYPE=$(gum choose "wsl" "desktop" --header "Select your environment type:")

if [ "$ENV_TYPE" = "wsl" ]; then
    echo "Installing WSL packages..."
    yay -S --needed --noconfirm - < "$SCRIPT_DIR/wsl.pkglist"
elif [ "$ENV_TYPE" = "desktop" ]; then
    echo "Installing desktop packages..."
    yay -S --needed --noconfirm - < "$SCRIPT_DIR/desktop.pkglist"
fi

echo ""
echo "==> Installation complete! 🎉"
echo ""
echo "Next steps:"
echo "  - Run ./scripts/post-install.sh to set up dotfiles"
echo "  - Configure your shell and tools"
