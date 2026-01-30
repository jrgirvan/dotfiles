#!/bin/bash
# scripts/installers/devbox.sh
set -e

# Devbox
if ! command -v devbox &> /dev/null; then
  echo "0️⃣  Installing Devbox..."
  curl -fsSL https://get.jetify.com/devbox | bash
else
  echo "✅ Devbox already installed"
fi
