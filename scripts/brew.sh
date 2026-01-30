#!/bin/bash
# scripts/brew.sh
set -e

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for this session
  if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/Homebrew/bin/brew shellenv)"
  fi
fi

# Bundle install
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "Running brew bundle..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "✅ Homebrew packages installed"
