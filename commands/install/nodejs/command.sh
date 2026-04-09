#!/usr/bin/env bash

# NVM (Node Version Manager) Installation Script
# This script installs NVM, Node.js LTS, npm, yarn, and bun

echo "=========================================="
echo "  Node.js Installation (via nvm)"
echo "=========================================="
echo ""

# Step 1: Check if nvm is already installed
echo "[1/7] Checking for nvm..."
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "  nvm already installed, loading..."
    \. "$NVM_DIR/nvm.sh"
elif [ -s "$HOME/.nvm/nvm.sh" ]; then
    echo "  nvm already installed, loading..."
    \. "$HOME/.nvm/nvm.sh"
else
    # Step 2: Download and install NVM
    echo "  Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    \. "$NVM_DIR/nvm.sh"
fi

# Step 3: Install Node.js LTS
echo ""
echo "[2/7] Installing Node.js LTS..."
nvm install --lts
LTS_VERSION=$(nvm version --lts)
echo "  Installed: $LTS_VERSION"

# Step 4: Set LTS as default
echo ""
echo "[3/7] Setting LTS as default..."
nvm alias default lts/*
echo "  Default set to: $(nvm alias default)"

# Step 5: Use LTS
echo ""
echo "[4/7] Switching to LTS..."
nvm use default

# Step 6: Install package managers and tools
echo ""
echo "[5/7] Installing npm, yarn, pnpm, and bun..."

# npm is installed with Node.js, just verify
if command -v npm &> /dev/null; then
    echo "  npm: $(npm --version)"
else
    echo "  ERROR: npm not found!"
    exit 1
fi

# Install yarn
if npm install -g yarn 2>/dev/null; then
    echo "  yarn: $(yarn --version)"
else
    echo "  WARNING: yarn install failed"
fi

# Install pnpm
if npm install -g pnpm 2>/dev/null; then
    echo "  pnpm: $(pnpm --version)"
else
    echo "  WARNING: pnpm install failed"
fi

# Install bun
if command -v bun &> /dev/null; then
    echo "  bun: $(bun --version)"
else
    echo "  Installing bun..."
    curl -fsSL https://bun.sh/install | bash
    # Source bun
    if [ -f "$HOME/.bun/bin/bun" ]; then
        export BUN_INSTALL="$HOME/.bun"
        export PATH="$BUN_INSTALL/bin:$PATH"
        echo "  bun: $(bun --version)"
    fi
fi

# Step 7: Add NVM and bun to shell profiles
echo ""
echo "[6/7] Configuring shell profiles..."

add_to_profile() {
    local profile=$1
    local content=$2
    if [ -f "$profile" ] && ! grep -q "$content" "$profile" 2>/dev/null; then
        echo "$content" >> "$profile"
    fi
}

# NVM initialization
NVM_INIT='export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'

# Bun PATH
BUN_PATH='export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"'

if [ -f ~/.bashrc ]; then
    add_to_profile ~/.bashrc "$NVM_INIT"
    add_to_profile ~/.bashrc "$BUN_PATH"
    echo "  Added to .bashrc"
fi

if [ -f ~/.zshrc ]; then
    add_to_profile ~/.zshrc "$NVM_INIT"
    add_to_profile ~/.zshrc "$BUN_PATH"
    echo "  Added to .zshrc"
fi

# Step 8: Verify installations
echo ""
echo "[7/7] Verifying installations..."
echo "  Node.js: $(node --version)"
echo "  npm: $(npm --version)"
echo "  yarn: $(yarn --version 2>/dev/null || echo 'not installed')"
echo "  pnpm: $(pnpm --version 2>/dev/null || echo 'not installed')"
echo "  bun: $(bun --version 2>/dev/null || echo 'not installed')"

echo ""
echo "=========================================="
echo "  Node.js installation complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  - Node.js: $(node --version) (default)"
echo "  - npm: $(npm --version)"
echo "  - yarn: $(yarn --version 2>/dev/null || echo 'installed')"
echo "  - pnpm: $(pnpm --version 2>/dev/null || echo 'installed')"
echo "  - bun: $(bun --version 2>/dev/null || echo 'installed')"
echo ""
echo "To use in current session, run:"
echo "  source ~/.bashrc  # or ~/.zshrc for zsh"