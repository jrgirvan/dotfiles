#!/bin/bash
# scripts/setup.sh
# Multi-platform dotfiles bootstrap
#
# Bootstrap flow on a new machine:
#   1. Install git (comes with OS or xcode-select --install on mac)
#   2. git clone git@github.com:<user>/dotfiles.git ~/dotfiles
#   3. cd ~/dotfiles && bash scripts/setup.sh
#   4. bash scripts/git-to-jj.sh   (converts repo to native jj)
#
# After conversion, use jj for all VCS operations on this repo.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
OS="$(uname -s)"

detect_distro() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo "$ID"
  fi
}

echo "==> Dotfiles setup"
echo "    OS: $OS"
echo ""

# --- Step 1: Platform packages ---
echo "==> Installing platform packages..."

if [[ "$OS" == "Darwin" ]]; then
  bash "$SCRIPT_DIR/brew.sh"
elif [[ "$OS" == "Linux" ]]; then
  DISTRO="$(detect_distro)"
  echo "    Distro: $DISTRO"
  case "$DISTRO" in
    arch)
      bash "$SCRIPT_DIR/packages-arch.sh"
      ;;
    debian|ubuntu)
      bash "$SCRIPT_DIR/packages-debian.sh"
      ;;
    *)
      echo "ERROR: Unsupported distro: $DISTRO"
      exit 1
      ;;
  esac
fi

# --- Step 2: Install mise ---
echo ""
echo "==> Installing mise..."

if ! command -v mise &>/dev/null; then
  curl https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
echo "    mise $(mise --version)"

# --- Step 3: Create ~/.zshenv (must exist before zsh reads config) ---
echo ""
echo "==> Setting up ~/.zshenv..."
if [[ ! -f "$HOME/.zshenv" ]] || ! grep -q 'ZDOTDIR' "$HOME/.zshenv"; then
  echo 'export ZDOTDIR="$HOME/.config/zsh"' > "$HOME/.zshenv"
  echo "    Created ~/.zshenv (ZDOTDIR -> ~/.config/zsh)"
else
  echo "    ~/.zshenv already sets ZDOTDIR"
fi

# --- Step 4: Stow dotfiles (mise config must be linked before mise install) ---
echo ""
echo "==> Linking dotfiles..."
cd "$DOTFILES_DIR"
stow .
echo "    Dotfiles linked to ~/.config"

# --- Step 4b: Stow work config (macOS only) ---
if [[ "$OS" == "Darwin" ]]; then
  echo "==> Linking work config..."
  mkdir -p "$HOME/work"
  stow --target="$HOME/work" work
  echo "    Work mise config linked to ~/work/.mise.toml"
fi

# --- Step 5: Install all mise tools ---
echo ""
echo "==> Installing mise tools (this will take a while)..."
mise install --yes

# --- Step 5b: Install work tools (macOS only) ---
if [[ "$OS" == "Darwin" ]]; then
  echo "==> Installing work mise tools..."
  mise install --yes --cd "$HOME/work"
fi

# --- Step 6: macOS-specific setup ---
if [[ "$OS" == "Darwin" ]]; then
  echo ""
  echo "==> Applying macOS defaults..."
  bash "$SCRIPT_DIR/macos.sh"

  echo ""
  echo "==> Running macOS post-install..."
  bash "$SCRIPT_DIR/post-install.sh"
fi

# --- Step 7: Set default shell ---
ZSH_PATH="$(which zsh)"
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  echo ""
  echo "==> Setting default shell to zsh..."
  if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
  fi
  chsh -s "$ZSH_PATH"
fi

echo ""
echo "==> Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Open a new shell (or: exec zsh)"
echo "  2. Verify: mise doctor"
echo "  3. Convert this repo from git to jj:"
echo "     cd $DOTFILES_DIR && bash scripts/git-to-jj.sh"
