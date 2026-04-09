#!/usr/bin/env bash

# Mongosh (MongoDB Shell) Installation Script
# This script installs mongosh following the official MongoDB procedure

set -e

echo "============================================"
echo "  MongoDB Shell (mongosh) Installer"
echo "============================================"
echo

# Check if running as root or with sudo access
if [ "$EUID" -ne 0 ] && ! sudo -v 2>/dev/null; then
    echo "Error: This script requires sudo privileges."
    echo "Please run with sudo or as root."
    exit 1
fi

# Use sudo for commands if not running as root
SUDO=""
if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
fi

echo "Step 1: Installing gnupg if not present..."
if ! command -v gpg &> /dev/null; then
    $SUDO apt-get update
    $SUDO apt-get install -y gnupg
fi
echo "gnupg is available."
echo

echo "Step 2: Importing MongoDB public GPG key..."
$SUDO wget -qO- https://www.mongodb.org/static/pgp/server-8.0.asc | $SUDO tee /etc/apt/trusted.gpg.d/server-8.0.asc > /dev/null
echo "GPG key imported successfully."
echo

echo "Step 3: Creating MongoDB repository list file..."
# Determine Debian version for the correct repository
DEBIAN_VERSION=$(lsb_release -rs 2>/dev/null || cat /etc/debian_version | cut -d. -f1)
echo "Detected Debian version: $DEBIAN_VERSION"

# Create the list file
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" | $SUDO tee /etc/apt/sources.list.d/mongodb-org-8.0.list > /dev/null
echo "Repository list file created."
echo

echo "Step 4: Updating package database..."
$SUDO apt-get update
echo

echo "Step 5: Installing mongosh..."
# Detect OpenSSL version and install appropriate package
if [ -f /etc/debian_version ]; then
    # Check if running Debian 12+ (Bookworm) which uses OpenSSL 3.0
    if grep -q "12\|bookworm" /etc/os-release 2>/dev/null || [ "$(cat /etc/debian_version | cut -d. -f1)" -ge 12 ]; then
        echo "Detected Debian 12+ (Bookworm) - using OpenSSL 3.0"
        $SUDO apt-get install -y mongodb-mongosh-shared-openssl3
    elif grep -q "11\|bullseye" /etc/os-release 2>/dev/null || [ "$(cat /etc/debian_version | cut -d. -f1)" -eq 11 ]; then
        echo "Detected Debian 11 (Bullseye) - using OpenSSL 1.1"
        $SUDO apt-get install -y mongodb-mongosh-shared-openssl11
    else
        # Default to latest stable with included OpenSSL
        echo "Using default mongosh package with bundled OpenSSL"
        $SUDO apt-get install -y mongodb-mongosh
    fi
else
    # Default for non-Debian systems
    echo "Using default mongosh package with bundled OpenSSL"
    $SUDO apt-get install -y mongodb-mongosh
fi
echo

echo "Step 6: Verifying installation..."
if command -v mongosh &> /dev/null; then
    echo "mongosh installed successfully!"
    echo
    echo "Version: $(mongosh --version)"
    echo
    echo "============================================"
    echo "  Installation Complete!"
    echo "============================================"
    echo
    echo "To connect to MongoDB, run:"
    echo "  mongosh"
    echo
else
    echo "Error: mongosh command not found after installation."
    echo "Please check the installation manually."
    exit 1
fi
