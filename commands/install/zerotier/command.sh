#!/usr/bin/env bash

# ZeroTier Installation Script
# This script installs ZeroTier One for creating secure virtual networks

# Step 1: Detect the operating system
echo "Detecting operating system..."
OS="$(uname -s)"
ARCH="$(uname -m)"

case "${OS}" in
    Linux*)
        echo "Linux detected. Installing ZeroTier for Linux..."

        # Step 2: Download and install ZeroTier for Linux using official installer
        echo "Downloading and installing ZeroTier..."
        curl -s https://install.zerotier.com | sudo bash

        # Step 3: Enable and start ZeroTier service
        echo "Enabling and starting ZeroTier service..."
        sudo systemctl enable zerotier-one
        sudo systemctl start zerotier-one
        ;;

    Darwin*)
        echo "macOS detected. Installing ZeroTier for macOS..."

        # Check if Homebrew is available
        if command -v brew &> /dev/null; then
            echo "Installing ZeroTier via Homebrew..."
            brew install --cask zerotier-one
        else
            echo "Homebrew not found. Downloading ZeroTier installer..."
            curl -o ZeroTierOne.pkg https://download.zerotier.com/dist/ZeroTier%20One.pkg

            echo "Installing ZeroTier..."
            sudo installer -pkg ZeroTierOne.pkg -target /

            # Clean up installer file
            echo "Cleaning up installer file..."
            rm -f ZeroTierOne.pkg
        fi

        # Start ZeroTier service on macOS
        echo "Starting ZeroTier service..."
        sudo launchctl load /Library/LaunchDaemons/com.zerotier.one.plist
        ;;

    *)
        echo "Unsupported operating system: ${OS}"
        echo "Please visit https://www.zerotier.com/download/ to download ZeroTier manually."
        exit 1
        ;;
esac

# Step 4: Wait for service to start
echo "Waiting for ZeroTier service to start..."
sleep 3

# Step 5: Get ZeroTier node ID
echo "Getting ZeroTier node information..."
if command -v zerotier-cli &> /dev/null; then
    NODE_ID=$(sudo zerotier-cli info | cut -d' ' -f3)
    echo "ZeroTier Node ID: $NODE_ID"
    echo "ZeroTier Status: $(sudo zerotier-cli info)"
else
    echo "Warning: zerotier-cli command not found"
    echo "ZeroTier may still be starting up"
fi

# Step 6: Display usage information
echo
echo "ZeroTier installation complete!"
echo
echo "Your ZeroTier Node ID: $NODE_ID"
echo
echo "Next steps:"
echo "1. Create a ZeroTier account at: https://my.zerotier.com"
echo "2. Create a new network or get a network ID from an administrator"
echo "3. Join a network:"
echo "   > sudo zerotier-cli join <NETWORK_ID>"
echo
echo "Common ZeroTier commands:"
echo "- Check status: sudo zerotier-cli info"
echo "- List networks: sudo zerotier-cli listnetworks"
echo "- Leave network: sudo zerotier-cli leave <NETWORK_ID>"
echo "- Show peers: sudo zerotier-cli peers"
echo
echo "Web interface (if available): http://localhost:9993"
echo
echo "For more information, visit: https://docs.zerotier.com"