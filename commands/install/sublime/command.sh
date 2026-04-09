#!/usr/bin/env bash

# Sublime Text and Sublime Merge Installation Script
# This script adds Sublime Text repositories and installs both Sublime Text and Sublime Merge

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
        echo "Linux detected. Installing Sublime Text and Sublime Merge for Linux..."

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
        echo "macOS detected. Installing Sublime Text and Sublime Merge for macOS..."

        # Check if Homebrew is available
        if ! command -v brew &> /dev/null; then
            echo "Error: Homebrew is required for macOS installation"
            echo "Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    *)
        echo "Unsupported operating system: ${OS}"
        echo "Please visit https://www.sublimetext.com/download for manual installation"
        exit 1
        ;;
esac

# Function to install Sublime Text and Sublime Merge on Linux
install_linux_sublime() {
    echo "Installing Sublime Text and Sublime Merge on Linux ($DISTRO)..."

    case "${DISTRO}" in
        ubuntu|debian)
            echo "Installing via apt and official Sublime Text repository..."

            # Fix any interrupted dpkg operations first
            echo "Checking for interrupted dpkg operations..."
            sudo dpkg --configure -a

            # Install prerequisites
            echo "Installing prerequisites..."
            sudo apt-get update
            sudo apt-get install -y wget gpg

            # Add Sublime Text's official GPG key
            echo "Adding Sublime Text GPG key..."
            wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

            # Add Sublime Text repository
            echo "Adding Sublime Text repository..."
            echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

            # Update package index
            sudo apt-get update

            # Install Sublime Text and Sublime Merge
            echo "Installing Sublime Text..."
            if ! sudo apt-get install -y sublime-text; then
                echo "Error installing Sublime Text. Attempting to fix broken packages..."
                sudo apt-get --fix-broken install -y
                sudo dpkg --configure -a
                sudo apt-get install -y sublime-text
            fi

            echo "Installing Sublime Merge..."
            if ! sudo apt-get install -y sublime-merge; then
                echo "Error installing Sublime Merge. Attempting to fix broken packages..."
                sudo apt-get --fix-broken install -y
                sudo dpkg --configure -a
                sudo apt-get install -y sublime-merge
            fi
            ;;

        fedora)
            echo "Installing via dnf and official Sublime Text repository..."

            # Install prerequisites
            echo "Installing prerequisites..."
            sudo dnf install -y wget

            # Add Sublime Text repository
            echo "Adding Sublime Text repository..."
            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
            sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

            # Install Sublime Text and Sublime Merge
            echo "Installing Sublime Text..."
            if ! sudo dnf install -y sublime-text; then
                echo "Error installing Sublime Text. Retrying..."
                sudo dnf clean all
                sudo dnf install -y sublime-text
            fi

            echo "Installing Sublime Merge..."
            if ! sudo dnf install -y sublime-merge; then
                echo "Error installing Sublime Merge. Retrying..."
                sudo dnf clean all
                sudo dnf install -y sublime-merge
            fi
            ;;

        centos|rhel)
            echo "Installing via yum and official Sublime Text repository..."

            # Install prerequisites
            echo "Installing prerequisites..."
            sudo yum install -y wget

            # Add Sublime Text repository
            echo "Adding Sublime Text repository..."
            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
            sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

            # Install Sublime Text and Sublime Merge
            echo "Installing Sublime Text..."
            if ! sudo yum install -y sublime-text; then
                echo "Error installing Sublime Text. Retrying..."
                sudo yum clean all
                sudo yum install -y sublime-text
            fi

            echo "Installing Sublime Merge..."
            if ! sudo yum install -y sublime-merge; then
                echo "Error installing Sublime Merge. Retrying..."
                sudo yum clean all
                sudo yum install -y sublime-merge
            fi
            ;;

        arch|manjaro)
            echo "Installing via AUR..."

            # Check if yay is available
            if command -v yay &> /dev/null; then
                echo "Installing Sublime Text and Sublime Merge via yay..."
                yay -S --noconfirm sublime-text-4 sublime-merge
            elif command -v paru &> /dev/null; then
                echo "Installing Sublime Text and Sublime Merge via paru..."
                paru -S --noconfirm sublime-text-4 sublime-merge
            else
                echo "Installing Sublime Text and Sublime Merge via pacman (from AUR)..."
                echo "Note: You may need to install an AUR helper like yay or paru for easier management"
                
                # Install base-devel if not present
                sudo pacman -S --needed --noconfirm base-devel git

                # Create temporary directory
                TEMP_DIR=$(mktemp -d)
                cd "$TEMP_DIR"

                # Install Sublime Text
                echo "Cloning Sublime Text AUR package..."
                git clone https://aur.archlinux.org/sublime-text-4.git
                cd sublime-text-4
                makepkg -si --noconfirm
                cd ..

                # Install Sublime Merge
                echo "Cloning Sublime Merge AUR package..."
                git clone https://aur.archlinux.org/sublime-merge.git
                cd sublime-merge
                makepkg -si --noconfirm

                # Clean up
                cd /
                rm -rf "$TEMP_DIR"
            fi
            ;;

        *)
            echo "Unsupported Linux distribution: ${DISTRO}"
            echo "Please install Sublime Text and Sublime Merge manually for your distribution"
            echo "Visit: https://www.sublimetext.com/download"
            return 1
            ;;
    esac
}

# Function to install Sublime Text and Sublime Merge on macOS
install_macos_sublime() {
    echo "Installing Sublime Text and Sublime Merge on macOS via Homebrew..."

    # Install Sublime Text using Homebrew cask
    echo "Installing Sublime Text..."
    brew install --cask sublime-text

    # Install Sublime Merge using Homebrew cask
    echo "Installing Sublime Merge..."
    brew install --cask sublime-merge

    echo "Sublime Text and Sublime Merge installed successfully!"
}

# Step 2: Install Sublime Text and Sublime Merge based on OS
if [[ "$OS" == "Linux" ]]; then
    install_linux_sublime
elif [[ "$OS" == "Darwin" ]]; then
    install_macos_sublime
fi

# Step 3: Verify installation
echo
echo "Verifying Sublime Text and Sublime Merge installation..."

# Check Sublime Text
if command -v subl &> /dev/null; then
    echo "Sublime Text installed successfully!"
    echo "Sublime Text version: $(subl --version 2>/dev/null || echo 'Version info not available via CLI')"
else
    echo "Warning: subl command not found"
    echo "Sublime Text may still be installed but not in PATH"
fi

# Check Sublime Merge
if command -v smerge &> /dev/null; then
    echo "Sublime Merge installed successfully!"
    echo "Sublime Merge version: $(smerge --version 2>/dev/null || echo 'Version info not available via CLI')"
else
    echo "Warning: smerge command not found"
    echo "Sublime Merge may still be installed but not in PATH"
fi

# Step 4: Display usage information
echo
echo "Sublime Text and Sublime Merge installation complete!"
echo
echo "Getting started with Sublime Text:"
echo "1. Launch Sublime Text:"
echo "   > subl"
echo "   > subl <file_or_directory>"
echo
echo "2. Open current directory in Sublime Text:"
echo "   > subl ."
echo
echo "3. Open a specific file:"
echo "   > subl myfile.txt"
echo
echo "Getting started with Sublime Merge:"
echo "1. Launch Sublime Merge:"
echo "   > smerge"
echo
echo "2. Open current git repository:"
echo "   > smerge ."
echo
echo "3. Open a specific repository:"
echo "   > smerge /path/to/repo"
echo
echo "Useful Sublime Text shortcuts:"
echo "- Command Palette: Ctrl+Shift+P (Linux/Windows) / Cmd+Shift+P (macOS)"
echo "- Quick Open: Ctrl+P (Linux/Windows) / Cmd+P (macOS)"
echo "- Find in Files: Ctrl+Shift+F (Linux/Windows) / Cmd+Shift+F (macOS)"
echo "- Multiple Cursors: Ctrl+D (Linux/Windows) / Cmd+D (macOS)"
echo "- Go to Line: Ctrl+G (Linux/Windows) / Cmd+G (macOS)"
echo
echo "Package Control (for plugins):"
echo "- Install Package Control from: https://packagecontrol.io/installation"
echo "- Access via Command Palette: 'Package Control: Install Package'"
echo
echo "Resources:"
echo "- Sublime Text Documentation: https://www.sublimetext.com/docs/"
echo "- Sublime Merge Documentation: https://www.sublimemerge.com/docs/"
echo "- Package Control: https://packagecontrol.io/"
echo "- Sublime Text Forum: https://forum.sublimetext.com/"