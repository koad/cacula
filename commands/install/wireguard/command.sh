#!/usr/bin/env bash

# WireGuard Installation Script
# This script installs WireGuard VPN for secure networking

# Step 1: Detect the operating system
echo "Detecting operating system..."
OS="$(uname -s)"
ARCH="$(uname -m)"

case "${OS}" in
    Linux*)
        echo "Linux detected. Installing WireGuard for Linux..."

        # Detect Linux distribution
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO=$ID
        else
            echo "Cannot detect Linux distribution"
            exit 1
        fi

        case "${DISTRO}" in
            ubuntu|debian)
                echo "Debian/Ubuntu detected. Installing via apt..."
                sudo apt update
                sudo apt install -y wireguard wireguard-tools
                ;;
            fedora)
                echo "Fedora detected. Installing via dnf..."
                sudo dnf install -y wireguard-tools
                ;;
            centos|rhel)
                echo "CentOS/RHEL detected. Installing via yum..."
                sudo yum install -y epel-release
                sudo yum install -y wireguard-tools
                ;;
            arch)
                echo "Arch Linux detected. Installing via pacman..."
                sudo pacman -S --noconfirm wireguard-tools
                ;;
            *)
                echo "Unsupported Linux distribution: ${DISTRO}"
                echo "Please install WireGuard manually for your distribution"
                exit 1
                ;;
        esac
        ;;

    Darwin*)
        echo "macOS detected. Installing WireGuard for macOS..."

        # Check if Homebrew is available
        if command -v brew &> /dev/null; then
            echo "Installing WireGuard via Homebrew..."
            brew install wireguard-tools
            brew install --cask wireguard
        else
            echo "Homebrew not found. Please install Homebrew first or download WireGuard from the App Store"
            echo "App Store: https://apps.apple.com/us/app/wireguard/id1451685025"
            exit 1
        fi
        ;;

    *)
        echo "Unsupported operating system: ${OS}"
        echo "Please visit https://www.wireguard.com/install/ to install WireGuard manually."
        exit 1
        ;;
esac

# Step 2: Verify installation
echo "Verifying WireGuard installation..."
if command -v wg &> /dev/null; then
    echo "WireGuard tools installed successfully"
    echo "WireGuard version: $(wg --version)"
else
    echo "Warning: wg command not found"
    echo "WireGuard may not be properly installed"
fi

# Step 3: Create configuration directory
echo "Creating WireGuard configuration directory..."
sudo mkdir -p /etc/wireguard
sudo chmod 700 /etc/wireguard

# Step 4: Generate example key pair (optional)
echo "Generating example key pair..."
PRIVATE_KEY=$(wg genkey)
PUBLIC_KEY=$(echo $PRIVATE_KEY | wg pubkey)

echo "Example private key: $PRIVATE_KEY"
echo "Example public key: $PUBLIC_KEY"

# Step 5: Create example configuration template
echo "Creating example configuration template..."
sudo tee /etc/wireguard/wg0.conf.example > /dev/null <<EOF
[Interface]
PrivateKey = $PRIVATE_KEY
Address = 10.0.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = PEER_PUBLIC_KEY_HERE
Endpoint = SERVER_IP:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

sudo chmod 600 /etc/wireguard/wg0.conf.example

# Step 6: Display usage information
echo
echo "WireGuard installation complete!"
echo
echo "Configuration files are stored in: /etc/wireguard/"
echo "Example configuration created: /etc/wireguard/wg0.conf.example"
echo
echo "Next steps:"
echo "1. Create or obtain a WireGuard configuration file"
echo "2. Save it as /etc/wireguard/wg0.conf (replace wg0 with your interface name)"
echo "3. Start the VPN connection:"
echo "   > sudo wg-quick up wg0"
echo "4. Stop the VPN connection:"
echo "   > sudo wg-quick down wg0"
echo "5. Enable auto-start on boot:"
echo "   > sudo systemctl enable wg-quick@wg0"
echo
echo "Common WireGuard commands:"
echo "- Show interface status: sudo wg show"
echo "- Generate private key: wg genkey"
echo "- Generate public key: echo 'PRIVATE_KEY' | wg pubkey"
echo "- Show configuration: sudo wg showconf wg0"
echo
echo "Your example keys (save these securely):"
echo "Private Key: $PRIVATE_KEY"
echo "Public Key: $PUBLIC_KEY"
echo
echo "For more information, visit: https://www.wireguard.com/quickstart/"