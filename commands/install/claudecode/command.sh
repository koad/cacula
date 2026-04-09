#!/usr/bin/env bash

# Claude Code Installation Script
# This script installs Claude Code - Anthropic's AI coding assistant

set -e

echo "=========================================="
echo "  Claude Code Installation"
echo "=========================================="
echo ""

# Check for prerequisites
echo "[1/7] Checking prerequisites..."

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "  ERROR: curl is required but not installed!"
    exit 1
fi

# Check if we have a terminal (required for interactive auth)
if [ ! -t 0 ]; then
    echo "  WARNING: Not running in a terminal - some features may not work"
fi

# Install clipboard helpers when apt is available
echo "  Prerequisites check passed."

echo ""
if [[ "$OSTYPE" == "linux-gnu"* ]] && command -v apt &> /dev/null; then
    echo "[2/7] Ensuring clipboard helpers (wl-clipboard/xclip/xsel/xdotool)"
    sudo apt update >/dev/null && sudo apt install -y wl-clipboard xclip xsel xdotool
else
    echo "[2/7] Skipping clipboard helpers (apt not available)"
fi

echo ""
echo "[3/7] Downloading and running Claude Code installer..."

# Use the official native installer (recommended method)
# This works on macOS, Linux, and Windows (via WSL/Git Bash)
CLAUDE_INSTALL_SCRIPT="/tmp/claude-code-install.sh"

if curl -fsSL https://claude.ai/install.sh -o "$CLAUDE_INSTALL_SCRIPT"; then
    echo "  Download complete."
else
    echo "  ERROR: Failed to download Claude Code installer!"
    exit 1
fi

# Run the installer
if bash "$CLAUDE_INSTALL_SCRIPT"; then
    echo "  Claude Code installed successfully."
else
    echo "  ERROR: Claude Code installation failed!"
    rm -f "$CLAUDE_INSTALL_SCRIPT"
    exit 1
fi

# Clean up installer script
rm -f "$CLAUDE_INSTALL_SCRIPT"

echo ""
echo "[4/7] Configuring PATH for Claude Code..."

echo ""
echo "[5/7] Adding Claude Code to shell profiles..."

# Claude Code is installed in ~/.local/bin/
CLAUDE_PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'

# Add to .bashrc if it exists
if [ -f ~/.bashrc ]; then
    if grep -q 'Claude Code' ~/.bashrc 2>/dev/null; then
        echo "  Already configured in .bashrc"
    else
        echo '' >> ~/.bashrc
        echo '# Claude Code initialization' >> ~/.bashrc
        echo "$CLAUDE_PATH_LINE" >> ~/.bashrc
        echo "  Added to .bashrc"
    fi
fi

# Add to .zshrc if it exists
if [ -f ~/.zshrc ]; then
    if grep -q 'Claude Code' ~/.zshrc 2>/dev/null; then
        echo "  Already configured in .zshrc"
    else
        echo '' >> ~/.zshrc
        echo '# Claude Code initialization' >> ~/.zshrc
        echo "$CLAUDE_PATH_LINE" >> ~/.zshrc
        echo "  Added to .zshrc"
    fi
fi

# Also check for .profile
if [ -f ~/.profile ]; then
    if grep -q 'Claude Code' ~/.profile 2>/dev/null; then
        echo "  Already configured in .profile"
    else
        echo '' >> ~/.profile
        echo '# Claude Code initialization' >> ~/.profile
        echo "$CLAUDE_PATH_LINE" >> ~/.profile
        echo "  Added to .profile"
    fi
fi

echo ""
echo "[6/7] Verifying Claude Code installation..."

# Add to PATH for this session
export PATH="$HOME/.local/bin:$PATH"

if command -v claude &> /dev/null; then
    echo "  SUCCESS: Claude Code is installed"
    echo "  Version: $(claude --version 2>/dev/null || echo 'unknown')"
else
    echo "  ERROR: Claude Code command not found in PATH!"
    echo "  Expected location: $HOME/.local/bin/claude"
    exit 1
fi

echo ""
echo "[7/7] Setup instructions..."

echo ""
echo "=========================================="
echo "  Claude Code installation complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Run 'claude setup' to configure your API key"
echo "2. Create a CLAUDE.md file in your project for project-specific instructions"
echo ""
echo "To use Claude Code in current session, run:"
echo "  source ~/.bashrc"
echo ""
echo "Or open a new terminal and run:"
echo "  claude --help"
echo ""
