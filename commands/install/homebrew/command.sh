#!/usr/bin/env bash

# Homebrew Installation Script
# This script installs Homebrew - the missing package manager for macOS and Linux

set -e

echo "=========================================="
echo "  Homebrew Installation"
echo "=========================================="
echo ""

echo "[1/7] Detecting OS..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "  Detected: Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  Detected: macOS"
else
    echo "  ERROR: Unsupported OS: $OSTYPE"
    exit 1
fi

echo ""
echo "[2/7] Checking for existing installation..."
if command -v brew &> /dev/null; then
    echo "  WARNING: Homebrew is already installed: $(brew --version)"
    read -p "  Reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "  Installation cancelled."
        exit 0
    fi
    echo "  Proceeding with reinstallation..."
fi

echo ""
echo "[3/7] Checking dependencies..."
# Check for git
if ! command -v git &> /dev/null; then
    echo "  ERROR: git is required but not installed!"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "  Install with: sudo apt-get install git (Debian/Ubuntu)"
        echo "  Or: sudo dnf install git (Fedora/RHEL)"
    fi
    exit 1
fi
echo "  git: OK"

# Check for curl
if ! command -v curl &> /dev/null; then
    echo "  ERROR: curl is required but not installed!"
    exit 1
fi
echo "  curl: OK"

# Check for build tools (only for Linux)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if ! command -v make &> /dev/null; then
        echo "  WARNING: make not found. Some packages may fail to build."
    else
        echo "  make: OK"
    fi
    
    if ! command -v gcc &> /dev/null; then
        echo "  WARNING: gcc not found. Some packages may fail to build."
    else
        echo "  gcc: OK"
    fi
fi

echo ""
echo "[4/7] Installing Homebrew..."
# The official Homebrew installation script
if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    echo "  Installation script completed."
else
    echo "  ERROR: Installation failed!"
    exit 1
fi

echo ""
echo "[5/7] Setting up PATH..."
# Add Homebrew to PATH for current session
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linuxbrew paths
    if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
        echo "  Added /home/linuxbrew/.linuxbrew/bin to PATH"
    fi
    if [ -d "$HOME/.linuxbrew/bin" ]; then
        export PATH="$HOME/.linuxbrew/bin:$PATH"
        echo "  Added ~/.linuxbrew/bin to PATH"
    fi
    
    # Add to shell profiles
    if [ -f ~/.bashrc ]; then
        if ! grep -q 'linuxbrew' ~/.bashrc 2>/dev/null; then
            echo '' >> ~/.bashrc
            echo '# Homebrew' >> ~/.bashrc
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
            echo "  Added to .bashrc"
        fi
    fi
    if [ -f ~/.zshrc ]; then
        if ! grep -q 'linuxbrew' ~/.zshrc 2>/dev/null; then
            echo '' >> ~/.zshrc
            echo '# Homebrew' >> ~/.zshrc
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
            echo "  Added to .zshrc"
        fi
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if [ -f ~/.zshrc ]; then
        if ! grep -q 'homebrew' ~/.zshrc 2>/dev/null; then
            echo '' >> ~/.zshrc
            echo '# Homebrew' >> ~/.zshrc
            echo 'eval "$(brew --prefix)/bin/brew shellenv"' >> ~/.zshrc
            echo "  Added to .zshrc"
        fi
    fi
    if [ -f ~/.bash_profile ]; then
        if ! grep -q 'homebrew' ~/.bash_profile 2>/dev/null; then
            echo '' >> ~/.bash_profile
            echo '# Homebrew' >> ~/.bash_profile
            echo 'eval "$(brew --prefix)/bin/brew shellenv"' >> ~/.bash_profile
            echo "  Added to .bash_profile"
        fi
    fi
fi

echo ""
echo "[6/7] Running brew doctor..."
# Refresh path for verification
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 2>/dev/null || true
fi

if command -v brew &> /dev/null; then
    echo "  Running brew doctor..."
    if brew doctor 2>&1 | head -20; then
        echo "  brew doctor: OK"
    else
        echo "  WARNING: brew doctor found issues, but continuing..."
    fi
else
    echo "  ERROR: brew command not found after installation!"
    exit 1
fi

echo ""
echo "[7/7] Verifying installation..."
if command -v brew &> /dev/null; then
    echo "  SUCCESS: Homebrew is installed"
    echo "  Version: $(brew --version)"
else
    echo "  ERROR: brew command not found!"
    echo "  Please restart your shell or run:"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "    eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""
    else
        echo "    eval \"\$(brew --prefix)/bin/brew shellenv\""
    fi
    exit 1
fi

echo ""
echo "=========================================="
echo "  Homebrew installation complete!"
echo "=========================================="
echo ""
echo "Basic commands:"
echo "  brew install <package>   # Install a package"
echo "  brew search <package>    # Search for packages"
echo "  brew list               # List installed packages"
echo "  brew update             # Update Homebrew"
echo ""
echo "For help: brew help"
