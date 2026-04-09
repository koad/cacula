#!/usr/bin/env bash

# Bun Installation Script
# This script installs Bun - the all-in-one JavaScript runtime

set -e

echo "=========================================="
echo "  Bun Installation"
echo "=========================================="
echo ""

echo "[1/5] Downloading Bun installer..."
if curl -fsSL https://bun.sh/install | bash; then
    echo "  Download complete."
else
    echo "  ERROR: Download failed!"
    exit 1
fi

echo ""
echo "[2/5] Sourcing Bun environment..."
BUN_INSTALL="$HOME/.bun"
if [ -s "$BUN_INSTALL/env" ]; then
    source "$BUN_INSTALL/env"
    echo "  Bun environment sourced."
else
    echo "  WARNING: Bun env file not found at $BUN_INSTALL/env"
fi

echo ""
echo "[3/5] Adding Bun to shell profiles..."
# Add to .bashrc if it exists
if [ -f ~/.bashrc ]; then
    if grep -q 'Bun initialization' ~/.bashrc 2>/dev/null; then
        echo "  Already configured in .bashrc"
    else
        echo '' >> ~/.bashrc
        echo '# Bun initialization' >> ~/.bashrc
        echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.bashrc
        echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.bashrc
        echo "  Added to .bashrc"
    fi
fi

# Add to .zshrc if it exists
if [ -f ~/.zshrc ]; then
    if grep -q 'Bun initialization' ~/.zshrc 2>/dev/null; then
        echo "  Already configured in .zshrc"
    else
        echo '' >> ~/.zshrc
        echo '# Bun initialization' >> ~/.zshrc
        echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.zshrc
        echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.zshrc
        echo "  Added to .zshrc"
    fi
fi

echo ""
echo "[4/5] Checking Bun installation..."
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

if command -v bun &> /dev/null; then
    echo "  SUCCESS: Bun is installed"
    echo "  Version: $(bun --version)"
else
    echo "  ERROR: Bun command not found in PATH!"
    echo "  Expected location: $BUN_INSTALL/bin/bun"
    exit 1
fi

echo ""
echo "[5/5] Verifying Bun works..."
if bun --version &> /dev/null; then
    echo "  Bun is working correctly."
else
    echo "  ERROR: Bun is installed but not working!"
    exit 1
fi

echo ""
echo "=========================================="
echo "  Bun installation complete!"
echo "=========================================="
echo ""
echo "To use Bun in current session, run:"
echo "  source ~/.bashrc"
