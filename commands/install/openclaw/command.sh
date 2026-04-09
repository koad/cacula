#!/usr/bin/env bash

# OpenClaw Installation Script
# This script installs OpenClaw - an open-source personal AI assistant (formerly Moltbot/Clawdbot)
# It also installs ClawHub CLI for managing skills

set -e

echo "=========================================="
echo "  OpenClaw Installation"
echo "=========================================="
echo ""

echo "[1/8] Checking prerequisites..."
echo "  Checking for nvm..."

# Check if nvm is installed (source nvm if available)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh"
elif [ -s "$HOME/.nvm/nvm.sh" ]; then
    \. "$HOME/.nvm/nvm.sh"
fi

# Check if nvm command is available
if ! command -v nvm &> /dev/null; then
    if [ -d "$NVM_DIR" ]; then
        # nvm directory exists but not loaded, source it
        \. "$NVM_DIR/nvm.sh" 2>/dev/null || true
    fi
    
    # Check again after sourcing
    if ! command -v nvm &> /dev/null; then
        echo "  ERROR: nvm is required but not installed!"
        echo "  Please install nvm first: https://github.com/nvm-sh/nvm"
        exit 1
    fi
fi
echo "  nvm found"

echo "  Checking Node.js version..."
if ! command -v node &> /dev/null; then
    echo "  ERROR: Node.js is not installed!"
    echo "  Please install Node.js (22.16+ or 24 recommended):"
    echo "    nvm install 24"
    echo "    nvm alias default 24"
    exit 1
fi

NODE_VERSION=$(node --version)
echo "  Node.js found: $NODE_VERSION"

# Extract major.minor version (e.g., v22.16.0 -> 22.16)
NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d'v' -f2 | cut -d'.' -f1)
NODE_MINOR=$(echo "$NODE_VERSION" | cut -d'v' -f2 | cut -d'.' -f2)
NODE_PATCH=$(echo "$NODE_VERSION" | cut -d'v' -f2 | cut -d'.' -f3)

# Check if Node 24+ (recommended)
if [ "$NODE_MAJOR" -ge 24 ]; then
    echo "  Node.js version EXCELLENT (24+ recommended)"
elif [ "$NODE_MAJOR" -eq 22 ]; then
    # Check if 22.16+
    if [ "$NODE_MINOR" -gt 16 ] || ([ "$NODE_MINOR" -eq 16 ] && [ "$NODE_PATCH" -ge 0 ]); then
        echo "  Node.js version OK (22.16+ supported)"
    else
        echo "  ERROR: Node.js 22.16+ required, current: $NODE_VERSION"
        echo "  Run: nvm install 22 && nvm alias default 22"
        exit 1
    fi
else
    echo "  ERROR: Node.js 22.16+ (or 24 recommended) required, current: $NODE_VERSION"
    echo "  Run: nvm install 24 && nvm alias default 24"
    exit 1
fi

# Ensure default alias is set to Node 24
CURRENT_DEFAULT=$(nvm alias default 2>/dev/null | head -1 | sed 's/.*v//' | tr -d ' ')
if [ -n "$CURRENT_DEFAULT" ]; then
    DEFAULT_MAJOR=$(echo "$CURRENT_DEFAULT" | cut -d'.' -f1)
    
    if [ "$DEFAULT_MAJOR" -lt 24 ]; then
        echo "  WARNING: Default node version is $CURRENT_DEFAULT, updating to 24..."
        nvm alias default 24 2>/dev/null || true
    fi
fi

if ! command -v npm &> /dev/null; then
    echo "  ERROR: npm is required but not found!"
    exit 1
fi
echo "  npm found: $(npm --version)"

echo ""
echo "[2/8] Checking for existing installation..."
if command -v clawd &> /dev/null; then
    echo "  WARNING: Clawd is already installed: $(clawd --version 2>/dev/null || echo 'unknown version')"
    read -p "  Reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "  Installation cancelled."
        exit 0
    fi
fi

echo ""
echo "[3/8] Running OpenClaw installer..."
if curl -fsSL https://openclaw.ai/install.sh | bash; then
    echo "  Installer script completed."
else
    echo "  WARNING: Official installer may have failed, trying npm..."
fi

echo ""
echo "[4/8] Setting up PATH..."
if [[ ":$PATH:" != *"$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
    if [ -f ~/.bashrc ] && ! grep -q 'export PATH="\$HOME/.local/bin:\$PATH"' ~/.bashrc 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        echo "  Added to .bashrc"
    fi
    if [ -f ~/.zshrc ] && ! grep -q 'export PATH="\$HOME/.local/bin:\$PATH"' ~/.zshrc 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
        echo "  Added to .zshrc"
    fi
else
    echo "  PATH already configured."
fi

echo ""
echo "[5/8] Verifying clawd command..."
if command -v clawd &> /dev/null; then
    echo "  SUCCESS: Clawd is installed"
    echo "  Version: $(clawd --version 2>/dev/null || echo 'could not determine')"
else
    echo "  Clawd not found, trying npm install..."
    
    echo ""
    echo "[6/8] Installing via npm..."
    if npm i -g clawdbot; then
        echo "  npm install complete."
    else
        echo "  ERROR: npm install failed!"
        exit 1
    fi
fi

echo ""
echo "[7/8] Installing ClawHub CLI..."
if command -v clawhub &> /dev/null; then
    echo "  ClawHub already installed: $(clawhub --version 2>/dev/null || echo 'unknown version')"
else
    if npm i -g clawhub; then
        echo "  ClawHub CLI installed successfully."
    else
        echo "  WARNING: ClawHub install failed, but continuing..."
    fi
fi

echo ""
echo "[8/8] Final verification..."
if command -v clawd &> /dev/null; then
    echo "  SUCCESS: OpenClaw is ready!"
    echo "  Command: clawd"
else
    echo "  ERROR: Installation failed - clawd command not found!"
    echo "  Please check the logs above."
    exit 1
fi

echo ""
echo "=========================================="
echo "  OpenClaw installation complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Run: clawd onboard"
echo "  2. Configure your AI API key"
echo "  3. Start: clawd"
echo ""
echo "ClawHub (skill manager):"
echo "  clawhub search <skill>  - Search for skills"
echo "  clawhub install <skill> - Install a skill"
echo "  clawhub list            - List installed skills"