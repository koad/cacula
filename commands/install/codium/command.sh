#!/usr/bin/env bash

# VSCodium Installation Script
# This script adds VSCodium repositories and installs VSCodium (open-source VS Code)

# Error handling function
handle_error() {
    echo "Error occurred during installation. Attempting to fix..."
    case "${DISTRO}" in
        ubuntu|debian)
            echo "Running dpkg --configure -a to fix interrupted installations..."
            sudo dpkg --configure -a
            echo "Running apt --fix-broken install..."
            sudo apt-get --fix-broken install -y
            ;;
        fedora)
            echo "Cleaning dnf cache..."
            sudo dnf clean all
            ;;
        centos|rhel)
            echo "Cleaning yum cache..."
            sudo yum clean all
            ;;
    esac
}

# Step 1: Detect the operating system
echo "Detecting operating system..."
OS="$(uname -s)"
ARCH="$(uname -m)"

case "${OS}" in
    Linux*)
        echo "Linux detected. Installing VSCodium for Linux..."

        # Detect Linux distribution
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO=$ID
        else
            echo "Cannot detect Linux distribution"
            exit 1
        fi

        echo "Distribution: $DISTRO"
        ;;

    Darwin*)
        echo "macOS detected. Installing VSCodium for macOS..."

        # Check if Homebrew is available
        if ! command -v brew &> /dev/null; then
            echo "Error: Homebrew is required for macOS installation"
            echo "Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    *)
        echo "Unsupported operating system: ${OS}"
        echo "Please visit https://vscodium.com/#install for manual installation"
        exit 1
        ;;
esac

# Function to install VSCodium on Linux
install_linux_codium() {
    echo "Installing VSCodium on Linux ($DISTRO)..."

    case "${DISTRO}" in
        ubuntu|debian)
            echo "Installing via apt and official VSCodium repository..."

            # Fix any interrupted dpkg operations first
            echo "Checking for interrupted dpkg operations..."
            sudo dpkg --configure -a

            # Install prerequisites
            echo "Installing prerequisites..."
            sudo apt-get update
            if ! sudo apt-get install -y wget gpg; then
                echo "Error installing prerequisites. Attempting to fix..."
                handle_error
                sudo apt-get install -y wget gpg
            fi

            # Add VSCodium's official GPG key
            echo "Adding VSCodium GPG key..."
            if ! wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg; then
                echo "Error adding GPG key"
                exit 1
            fi

            # Add VSCodium repository
            echo "Adding VSCodium repository..."
            echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list

            # Update package index
            sudo apt-get update

            # Install VSCodium
            echo "Installing VSCodium..."
            if ! sudo apt-get install -y codium; then
                echo "Error installing VSCodium. Attempting to fix broken packages..."
                handle_error
                sudo apt-get install -y codium
            fi
            ;;

        fedora)
            echo "Installing via dnf and official VSCodium repository..."

            # Install prerequisites
            echo "Installing prerequisites..."
            if ! sudo dnf install -y wget; then
                echo "Error installing prerequisites. Retrying..."
                handle_error
                sudo dnf install -y wget
            fi

            # Add VSCodium repository
            echo "Adding VSCodium repository..."
            sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
            printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo

            # Install VSCodium
            echo "Installing VSCodium..."
            if ! sudo dnf install -y codium; then
                echo "Error installing VSCodium. Retrying..."
                handle_error
                sudo dnf install -y codium
            fi
            ;;

        centos|rhel)
            echo "Installing via yum and official VSCodium repository..."

            # Install prerequisites
            echo "Installing prerequisites..."
            if ! sudo yum install -y wget; then
                echo "Error installing prerequisites. Retrying..."
                handle_error
                sudo yum install -y wget
            fi

            # Add VSCodium repository
            echo "Adding VSCodium repository..."
            sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
            printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo

            # Install VSCodium
            echo "Installing VSCodium..."
            if ! sudo yum install -y codium; then
                echo "Error installing VSCodium. Retrying..."
                handle_error
                sudo yum install -y codium
            fi
            ;;

        arch|manjaro)
            echo "Installing via AUR..."

            # Check if yay is available
            if command -v yay &> /dev/null; then
                echo "Installing VSCodium via yay..."
                if ! yay -S --noconfirm vscodium-bin; then
                    echo "Error installing VSCodium via yay. Trying alternative..."
                    yay -S --noconfirm vscodium
                fi
            elif command -v paru &> /dev/null; then
                echo "Installing VSCodium via paru..."
                if ! paru -S --noconfirm vscodium-bin; then
                    echo "Error installing VSCodium via paru. Trying alternative..."
                    paru -S --noconfirm vscodium
                fi
            else
                echo "Installing VSCodium via pacman (from AUR)..."
                echo "Note: You may need to install an AUR helper like yay or paru for easier management"
                
                # Install base-devel if not present
                sudo pacman -S --needed --noconfirm base-devel git

                # Create temporary directory
                TEMP_DIR=$(mktemp -d)
                cd "$TEMP_DIR"

                # Install VSCodium
                echo "Cloning VSCodium AUR package..."
                if ! git clone https://aur.archlinux.org/vscodium-bin.git; then
                    echo "Error cloning vscodium-bin, trying vscodium..."
                    git clone https://aur.archlinux.org/vscodium.git
                    cd vscodium
                else
                    cd vscodium-bin
                fi
                
                makepkg -si --noconfirm

                # Clean up
                cd /
                rm -rf "$TEMP_DIR"
            fi
            ;;

        *)
            echo "Unsupported Linux distribution: ${DISTRO}"
            echo "Please install VSCodium manually for your distribution"
            echo "Visit: https://vscodium.com/#install"
            return 1
            ;;
    esac
}

# Function to install VSCodium on macOS
install_macos_codium() {
    echo "Installing VSCodium on macOS via Homebrew..."

    # Install VSCodium using Homebrew cask
    echo "Installing VSCodium..."
    if ! brew install --cask vscodium; then
        echo "Error installing VSCodium via Homebrew"
        echo "You can also download it manually from: https://vscodium.com/"
        exit 1
    fi

    echo "VSCodium installed successfully!"
}

# Step 2: Install VSCodium based on OS
if [[ "$OS" == "Linux" ]]; then
    install_linux_codium
elif [[ "$OS" == "Darwin" ]]; then
    install_macos_codium
fi

# Step 3: Verify installation
echo
echo "Verifying VSCodium installation..."

# Check VSCodium
if command -v codium &> /dev/null; then
    echo "VSCodium installed successfully!"
    echo "VSCodium version: $(codium --version | head -n 1 2>/dev/null || echo 'Version info not available via CLI')"
else
    echo "Warning: codium command not found"
    echo "VSCodium may still be installed but not in PATH"
fi

# Step 4: Display usage information
echo
echo "VSCodium installation complete!"
echo
echo "Getting started with VSCodium:"
echo "1. Launch VSCodium:"
echo "   > codium"
echo "   > codium <file_or_directory>"
echo
echo "2. Open current directory in VSCodium:"
echo "   > codium ."
echo
echo "3. Open a specific file:"
echo "   > codium myfile.txt"
echo
echo "4. Install extensions:"
echo "   > codium --install-extension <extension-id>"
echo
echo "Useful VSCodium shortcuts:"
echo "- Command Palette: Ctrl+Shift+P (Linux/Windows) / Cmd+Shift+P (macOS)"
echo "- Quick Open: Ctrl+P (Linux/Windows) / Cmd+P (macOS)"
echo "- Find in Files: Ctrl+Shift+F (Linux/Windows) / Cmd+Shift+F (macOS)"
echo "- Integrated Terminal: Ctrl+\` (Linux/Windows) / Cmd+\` (macOS)"
echo "- Split Editor: Ctrl+\\ (Linux/Windows) / Cmd+\\ (macOS)"
echo
echo "Extension Management:"
echo "- Open Extensions: Ctrl+Shift+X (Linux/Windows) / Cmd+Shift+X (macOS)"
echo "- Install from VSIX: codium --install-extension <path-to-vsix>"
echo "- List installed extensions: codium --list-extensions"
echo
echo "VSCodium vs VS Code:"
echo "- VSCodium is the open-source version of VS Code without Microsoft telemetry"
echo "- Uses Open VSX Registry instead of Microsoft's marketplace by default"
echo "- Compatible with most VS Code extensions"
echo "- Privacy-focused alternative to VS Code"
echo
echo "Extension Marketplaces:"
echo "- Default: Open VSX Registry (https://open-vsx.org/)"
echo "- Alternative: You can configure to use VS Code marketplace if needed"
echo
echo "Resources:"
echo "- VSCodium Website: https://vscodium.com/"
echo "- GitHub Repository: https://github.com/VSCodium/vscodium"
echo "- Open VSX Registry: https://open-vsx.org/"
echo "- Documentation: https://code.visualstudio.com/docs (same as VS Code)"