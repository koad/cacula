#!/usr/bin/env bash

# GitHub CLI (gh) Installation Script
# This script installs GitHub CLI - the official GitHub command line tool

set -e

echo "=========================================="
echo "  GitHub CLI (gh) Installation"
echo "=========================================="
echo ""

echo "[1/6] Detecting OS and architecture..."
ARCH=$(uname -m)
OS=$(uname -s)

case "$OS" in
    Linux)
        echo "  Detected: Linux"
        ;;
    Darwin)
        echo "  Detected: macOS"
        ;;
    *)
        echo "  ERROR: Unsupported OS: $OS"
        exit 1
        ;;
esac

case "$ARCH" in
    x86_64)
        ARCH_NAME="amd64"
        ;;
    aarch64|arm64)
        ARCH_NAME="arm64"
        ;;
    armv7l)
        ARCH_NAME="armv7"
        ;;
    *)
        echo "  ERROR: Unsupported architecture: $ARCH"
        exit 1
        ;;
esac
echo "  Architecture: $ARCH ($ARCH_NAME)"

echo ""
echo "[2/6] Checking for existing installation..."
if command -v gh &> /dev/null; then
    echo "  WARNING: gh is already installed: $(gh --version 2>/dev/null | head -1)"
    read -p "  Reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "  Installation cancelled."
        exit 0
    fi
    echo "  Proceeding with reinstallation..."
fi

echo ""
echo "[3/6] Checking dependencies..."
if ! command -v curl &> /dev/null; then
    echo "  ERROR: curl is required but not installed!"
    exit 1
fi
echo "  curl: OK"

if ! command -v git &> /dev/null; then
    echo "  WARNING: git not found - some features may not work"
else
    echo "  git: OK"
fi

echo ""
echo "[4/6] Downloading GitHub CLI..."
# Download the latest release
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

if [[ "$OS" == "Darwin" ]]; then
    # macOS - download installer package
    curl -sSL "https://github.com/cli/cli/releases/latest/download/gh_${OS}_${ARCH_NAME}.tar.gz" -o gh.tar.gz
    if tar -xzf gh.tar.gz; then
        echo "  Download and extract complete."
    else
        echo "  ERROR: Download/extract failed!"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
else
    # Linux - download the official install script
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /tmp/githubcli-archive-keyring.gpg
    sudo chmod 644 /tmp/githubcli-archive-keyring.gpg
    sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null
    
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y gh
        rm -rf "$TEMP_DIR"
    else
        # Try dnf/yum
        curl -fsSL https://cli.github.com/packages/rpm/gh-cli.repo | sudo tee /etc/yum.repos.d/github-cli.repo
        if command -v dnf &> /dev/null; then
            sudo dnf install -y gh
        elif command -v yum &> /dev/null; then
            sudo yum install -y gh
        else
            echo "  ERROR: No supported package manager found (apt/dnf/yum)"
            rm -rf "$TEMP_DIR"
            exit 1
        fi
        rm -rf "$TEMP_DIR"
    fi
fi

echo ""
echo "[5/6] Installing gh..."
if [[ "$OS" == "Darwin" ]] && [ -d "$TEMP_DIR/gh_${OS}_${ARCH_NAME}" ]; then
    cd "$TEMP_DIR/gh_${OS}_${ARCH_NAME}"
    sudo cp -r bin/gh /usr/local/bin/
    sudo cp -r share/man/* /usr/local/share/man/ 2>/dev/null || true
    cd ~
    rm -rf "$TEMP_DIR"
    echo "  Installed to /usr/local/bin/"
fi

# Verify installation
if command -v gh &> /dev/null; then
    echo "  SUCCESS: gh is installed"
else
    echo "  ERROR: gh command not found after installation!"
    rm -rf "$TEMP_DIR" 2>/dev/null || true
    exit 1
fi

echo ""
echo "[6/6] Verifying installation..."
if gh --version &> /dev/null; then
    echo "  SUCCESS: GitHub CLI is ready"
    echo "  Version: $(gh --version)"
else
    echo "  ERROR: gh is installed but not working!"
    exit 1
fi

echo ""
echo "=========================================="
echo "  GitHub CLI installation complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Authenticate: gh auth login"
echo "  2. Check status: gh auth status"
echo ""
echo "Basic commands:"
echo "  gh repo clone <owner/repo>  # Clone a repository"
echo "  gh pr create                # Create a pull request"
echo "  gh issue create             # Create an issue"
echo "  gh run watch                # Watch workflow runs"
echo ""
echo "For help: gh help"
