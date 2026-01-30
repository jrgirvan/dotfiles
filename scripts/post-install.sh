#!/bin/bash
# scripts/post-install.sh
set -e

echo ""
echo "Setting up language managers..."
echo ""

# Rustup & Rust
if ! command -v rustup &> /dev/null; then
  echo "1️⃣  Installing Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
  rustup default stable
else
  echo "✅ Rustup already installed"
fi

# SDKman
if ! command -v sdk &> /dev/null; then
  echo "2️⃣  Installing SDKman..."
  curl -s 'https://get.sdkman.io' | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk install java
else
  echo "✅ SDKman already installed"
fi

# Mise (install tools from config)
echo "3️⃣  Installing Mise tools from config..."
mise install

# Kubectl krew plugins
echo "4️⃣  Installing kubectl krew plugins..."
kubectl krew install ctx ns oidc-login

# SketchyBar
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf
# SbarLua
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)
echo "5️⃣  Starting SketchyBar service..."
brew services start sketchybar

echo ""
echo "✅ Language managers installed"
echo ""
echo "Per-project setup (each project):"
echo "   devbox init"
echo "   devbox add bun node go python java"
echo "   direnv allow"
echo ""
echo "Verify:"
echo "   rustc --version"
echo "   sdk version"
echo "   mise --version"
echo "   kubectl ctx --help"
echo ""
