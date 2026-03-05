#!/bin/bash
# scripts/git-to-jj.sh
# Convert this repo from a git clone to a native jj repo (no colocation).
#
# Strategy: jj git clone --no-colocate from the existing .git, then
# replace the original with the jj version.
#
# Usage: cd ~/dotfiles && bash scripts/git-to-jj.sh
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

if [[ ! -d .git ]]; then
  if [[ -d .jj ]]; then
    echo "Already a jj repo. Nothing to do."
    exit 0
  fi
  echo "ERROR: No .git or .jj directory found."
  exit 1
fi

echo "==> Converting git repo to native jj (non-colocated)"
echo "    Repo: $REPO_DIR"
echo ""

# Step 1: Get remote URL
REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"
if [[ -z "$REMOTE_URL" ]]; then
  echo "ERROR: No git remote 'origin' found. Cannot proceed."
  exit 1
fi
echo "    Remote: $REMOTE_URL"

# Step 2: Make sure there are no uncommitted changes
if [[ -n "$(git status --porcelain)" ]]; then
  echo ""
  echo "WARNING: You have uncommitted changes."
  echo "These will be preserved as the jj working copy, but make sure"
  echo "anything important is committed first."
  echo ""
  read -p "Continue anyway? [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Step 3: Clone into a temporary directory using jj
TMPDIR="$(mktemp -d)"
JJ_CLONE="$TMPDIR/dotfiles"
echo "==> Cloning via jj git clone --no-colocate..."
jj git clone --no-colocate "$REMOTE_URL" "$JJ_CLONE"

# Step 4: Swap .git for .jj
echo "==> Removing .git from working directory..."
rm -rf "$REPO_DIR/.git"

echo "==> Moving .jj into place..."
mv "$JJ_CLONE/.jj" "$REPO_DIR/.jj"

# Step 5: Clean up temp
rm -rf "$TMPDIR"

# Step 6: Let jj snapshot the working copy
echo "==> Snapshotting working copy..."
cd "$REPO_DIR"
jj st

echo ""
echo "==> Done! This repo is now a native jj repo (non-colocated)."
echo ""
echo "Useful commands:"
echo "  jj log              # view history"
echo "  jj st               # status"
echo "  jj git fetch        # fetch from remote"
echo "  jj git push         # push to remote"
echo "  jj new              # start new change"
echo "  jj describe -m ''   # set change description"
