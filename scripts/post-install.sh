#!/bin/bash
# scripts/post-install.sh
# macOS-specific post-install tasks (run after stow + mise install)
set -e

echo ""
echo "Running macOS post-install..."
echo ""

# kubectl krew plugins
if command -v kubectl-krew &>/dev/null; then
  echo "==> Installing kubectl krew plugins..."
  kubectl krew install ctx ns oidc-login 2>/dev/null || true
else
  echo "    Skipping krew plugins (krew not installed)"
fi

# SketchyBar app font
FONT_PATH="$HOME/Library/Fonts/sketchybar-app-font.ttf"
if [[ ! -f "$FONT_PATH" ]]; then
  echo "==> Installing SketchyBar app font..."
  mkdir -p "$HOME/Library/Fonts"
  curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf \
    -o "$FONT_PATH"
else
  echo "    SketchyBar app font already installed"
fi

# SbarLua
if [[ ! -f "$HOME/.local/share/sketchybar_lua/sketchybar.so" ]]; then
  echo "==> Building SbarLua..."
  rm -rf /tmp/SbarLua
  git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
  (cd /tmp/SbarLua/ && make install)
  rm -rf /tmp/SbarLua
else
  echo "    SbarLua already installed"
fi

echo "==> Starting SketchyBar service..."
brew services start sketchybar 2>/dev/null || true

echo ""
echo "Done. macOS post-install complete."
