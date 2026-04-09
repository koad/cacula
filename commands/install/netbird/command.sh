#!/usr/bin/env bash

# Netbird Installation Script
# This script installs Netbird - an open-source VPN solution

set -e

echo "=========================================="
echo "  Netbird Installation"
echo "=========================================="
echo ""

echo "[1/6] Detecting OS..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "  Detected: Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  Detected: macOS"
else
    echo "  ERROR: Unsupported OS: $OSTYPE"
    exit 1
fi

echo ""
echo "[2/6] Checking for existing installation..."
if command -v netbird &> /dev/null; then
    echo "  WARNING: Netbird is already installed: $(netbird version 2>/dev/null || echo 'unknown version')"
    read -p "  Reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "  Installation cancelled."
        exit 0
    fi
    echo "  Proceeding with reinstallation..."
fi

echo ""
echo "[3/6] Running Netbird installer..."
if curl -fsSL https://pkgs.netbird.io/install.sh | sh; then
    echo "  Installer completed successfully."
else
    echo "  ERROR: Installer failed!"
    exit 1
fi

echo ""
echo "[4/6] Verifying netbird command..."
if command -v netbird &> /dev/null; then
    echo "  SUCCESS: Netbird is installed"
    echo "  Version: $(netbird version 2>/dev/null || echo 'could not determine')"
else
    echo "  ERROR: Netbird command not found!"
    echo "  The installer may have failed. Check the logs above."
    exit 1
fi

echo ""
echo "[5/6] Checking service status..."
export PATH="$PATH:/usr/local/bin"
if netbird service status &> /dev/null; then
    echo "  Service is installed"
    if netbird service is-running &> /dev/null; then
        echo "  Service is running"
    else
        echo "  Service is installed but not running"
    fi
else
    echo "  Service not yet configured (this is normal before first connection)"
fi

echo ""
echo "[6/6] Testing netbird command..."
if netbird version &> /dev/null; then
    echo "  Netbird CLI is working correctly."
else
    echo "  WARNING: Netbird installed but CLI may need PATH refresh"
fi

echo ""
echo "=========================================="
echo "  Netbird installation complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Run: netbird up"
echo "  2. Or: netbird login (will open browser for SSO)"
echo "  3. Check status: netbird status"
echo ""
echo "For help: netbird --help"
