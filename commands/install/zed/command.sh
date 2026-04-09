#!/usr/bin/env bash

# Zed Editor Installation Script
# This script installs Zed - a modern, fast code editor

echo "=========================================="
echo "  Zed Editor Installation"
echo "=========================================="
echo ""

echo "[1/5] Checking for existing installation..."
if command -v zed &> /dev/null; then
    echo "  Zed is already installed: $(zed --version 2>/dev/null || echo 'unknown version')"
    read -p "  Reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "  Installation cancelled."
        exit 0
    fi
fi

# Also check for zeditor (alternative binary name on some distros)
if command -v zeditor &> /dev/null; then
    echo "  zeditor is already installed: $(zeditor --version 2>/dev/null || echo 'unknown version')"
fi

echo ""
echo "[2/5] Checking system requirements..."
# Check glibc version
GLIBC_VERSION=$(ldd --version 2>/dev/null | head -1 | awk '{print $NF}' || echo "unknown")
echo "  glibc version: $GLIBC_VERSION"

# Check architecture
ARCH=$(uname -m)
echo "  architecture: $ARCH"

if [ "$ARCH" = "x86_64" ]; then
    REQUIRED_GLIBC="2.31"
    echo "  required glibc: >= $REQUIRED_GLIBC (Ubuntu 20+)"
elif [ "$ARCH" = "aarch64" ]; then
    REQUIRED_GLIBC="2.35"
    echo "  required glibc: >= $REQUIRED_GLIBC (Ubuntu 22+)"
fi

echo ""
echo "[3/5] Installing Zed..."
if curl -f https://zed.dev/install.sh | sh; then
    echo "  Zed installed successfully."
else
    echo "  ERROR: Zed installation failed!"
    exit 1
fi

echo ""
echo "[4/5] Setting up CLI..."
# The install script should have added zed to ~/.local/bin or /usr/local/bin
# Make sure ~/.local/bin is in PATH
export PATH="$HOME/.local/bin:$PATH"

if [ -f ~/.bashrc ] && ! grep -q 'export PATH="\$HOME/.local/bin:\$PATH"' ~/.bashrc 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo "  Added to .bashrc"
fi
if [ -f ~/.zshrc ] && ! grep -q 'export PATH="\$HOME/.local/bin:\$PATH"' ~/.zshrc 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    echo "  Added to .zshrc"
fi

echo ""
echo "[5/5] Verifying installation..."
if command -v zed &> /dev/null; then
    echo "  SUCCESS: Zed is installed"
    echo "  Version: $(zed --version 2>/dev/null || echo 'could not determine')"
elif command -v zeditor &> /dev/null; then
    echo "  SUCCESS: Zed (zeditor) is installed"
    echo "  Version: $(zeditor --version 2>/dev/null || echo 'could not determine')"
else
    echo "  ERROR: Zed command not found!"
    echo "  Try adding ~/.local/bin to your PATH"
    exit 1
fi

echo ""
echo "=========================================="
echo "  Zed installation complete!"
echo "=========================================="
echo ""
echo "Usage:"
echo "  zed .                 # Open current directory"
echo "  zed filename          # Open a file"
echo "  zed filename:10:5    # Open at line 10, column 5"
echo ""
echo "To use in current session, run:"
echo "  export PATH=\"$HOME/.local/bin:\$PATH\""