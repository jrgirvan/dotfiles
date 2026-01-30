#!/bin/bash
# scripts/setup.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "🍎 macOS Setup"
echo ""

# Brew
echo "📦 Installing Homebrew & packages..."
bash "$SCRIPT_DIR/brew.sh"

# Install scripts
echo "📦 Installing additional tools..."
for script in $SCRIPT_DIR/installers/*.sh; do
    if [[ -f "$script" && -x "$script" ]]; then
        echo "Executing: $script"
        "$script"
    fi
done

# System defaults
echo "⚙️  Applying macOS defaults..."
bash "$SCRIPT_DIR/macos.sh"

# Stow dotfiles
echo "📁 Linking dotfiles..."
cd "$DOTFILES_DIR"
stow .
echo "✅ Dotfiles linked"

# Post-install
echo ""
echo "📋 Next steps:"
bash "$SCRIPT_DIR/post-install.sh"

echo ""
echo "✅ Setup complete!"
