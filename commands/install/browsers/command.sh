#!/usr/bin/env bash

# Browser Installation Script
# This script installs multiple browsers: Google Chrome, Brave, Chromium, Vivaldi, and Opera

# Step 1: Detect the operating system
echo "Detecting operating system..."
OS="$(uname -s)"

case "${OS}" in
    Linux*)
        echo "Linux detected. Installing browsers for Linux..."

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
        echo "macOS detected. Installing browsers for macOS..."

        # Check if Homebrew is available
        if ! command -v brew &> /dev/null; then
            echo "Error: Homebrew is required for macOS installation"
            echo "Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    *)
        echo "Unsupported operating system: ${OS}"
        echo "This script supports Linux and macOS only"
        exit 1
        ;;
esac

# Function to install browsers on Linux
install_linux_browsers() {
    echo "Installing browsers on Linux ($DISTRO)..."

    case "${DISTRO}" in
        ubuntu|debian)
            echo "Installing browsers via apt and external repositories..."

            # Update package list
            sudo apt update

            # Install Chromium (from default repos)
            echo "Installing Chromium..."
            sudo apt install -y chromium-browser

            # Install Google Chrome
            echo "Installing Google Chrome..."
            wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
            echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
            sudo apt update
            sudo apt install -y google-chrome-stable

            # Install Brave Browser
            echo "Installing Brave Browser..."
            curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
            sudo apt update
            sudo apt install -y brave-browser

            # Install Vivaldi
            echo "Installing Vivaldi..."
            wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo apt-key add -
            echo "deb https://repo.vivaldi.com/archive/deb/ stable main" | sudo tee /etc/apt/sources.list.d/vivaldi-archive.list
            sudo apt update
            sudo apt install -y vivaldi-stable

            # Install Opera
            echo "Installing Opera..."
            wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
            echo "deb https://deb.opera.com/opera-stable/ stable non-free" | sudo tee /etc/apt/sources.list.d/opera-stable.list
            sudo apt update
            sudo apt install -y opera-stable
            ;;

        fedora)
            echo "Installing browsers via dnf and external repositories..."

            # Install Chromium (from default repos)
            echo "Installing Chromium..."
            sudo dnf install -y chromium

            # Install Google Chrome
            echo "Installing Google Chrome..."
            sudo dnf install -y fedora-workstation-repositories
            sudo dnf config-manager --set-enabled google-chrome
            sudo dnf install -y google-chrome-stable

            # Install Brave Browser
            echo "Installing Brave Browser..."
            sudo dnf install -y dnf-plugins-core
            sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
            sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
            sudo dnf install -y brave-browser

            # Install Vivaldi
            echo "Installing Vivaldi..."
            sudo dnf config-manager --add-repo https://repo.vivaldi.com/archive/vivaldi-fedora.repo
            sudo dnf install -y vivaldi-stable

            # Install Opera
            echo "Installing Opera..."
            sudo dnf config-manager --add-repo https://rpm.opera.com/rpm
            sudo rpm --import https://rpm.opera.com/rpmrepo.key
            sudo dnf install -y opera-stable
            ;;

        arch|manjaro)
            echo "Installing browsers via pacman and AUR..."

            # Install Chromium (from default repos)
            echo "Installing Chromium..."
            sudo pacman -S --noconfirm chromium

            # Install Google Chrome (AUR)
            echo "Installing Google Chrome..."
            if command -v yay &> /dev/null; then
                yay -S --noconfirm google-chrome
            elif command -v paru &> /dev/null; then
                paru -S --noconfirm google-chrome
            else
                echo "Warning: AUR helper (yay/paru) not found. Skipping Google Chrome."
                echo "Install manually: yay -S google-chrome"
            fi

            # Install Brave Browser
            echo "Installing Brave Browser..."
            if command -v yay &> /dev/null; then
                yay -S --noconfirm brave-bin
            elif command -v paru &> /dev/null; then
                paru -S --noconfirm brave-bin
            else
                echo "Warning: AUR helper not found. Skipping Brave Browser."
                echo "Install manually: yay -S brave-bin"
            fi

            # Install Vivaldi
            echo "Installing Vivaldi..."
            if command -v yay &> /dev/null; then
                yay -S --noconfirm vivaldi
            elif command -v paru &> /dev/null; then
                paru -S --noconfirm vivaldi
            else
                echo "Warning: AUR helper not found. Skipping Vivaldi."
                echo "Install manually: yay -S vivaldi"
            fi

            # Install Opera
            echo "Installing Opera..."
            if command -v yay &> /dev/null; then
                yay -S --noconfirm opera
            elif command -v paru &> /dev/null; then
                paru -S --noconfirm opera
            else
                echo "Warning: AUR helper not found. Skipping Opera."
                echo "Install manually: yay -S opera"
            fi
            ;;

        *)
            echo "Unsupported Linux distribution: ${DISTRO}"
            echo "Please install browsers manually for your distribution"
            return 1
            ;;
    esac
}

# Function to install browsers on macOS
install_macos_browsers() {
    echo "Installing browsers on macOS via Homebrew..."

    # Install all browsers using Homebrew casks
    echo "Installing Chromium..."
    brew install --cask chromium

    echo "Installing Google Chrome..."
    brew install --cask google-chrome

    echo "Installing Brave Browser..."
    brew install --cask brave-browser

    echo "Installing Vivaldi..."
    brew install --cask vivaldi

    echo "Installing Opera..."
    brew install --cask opera
}

# Step 2: Install browsers based on OS
if [[ "$OS" == "Linux" ]]; then
    install_linux_browsers
elif [[ "$OS" == "Darwin" ]]; then
    install_macos_browsers
fi

# Step 3: Verify installations
echo
echo "Verifying browser installations..."

browsers=("chromium" "google-chrome" "brave" "vivaldi" "opera")
installed_browsers=()
failed_browsers=()

for browser in "${browsers[@]}"; do
    case "$browser" in
        "chromium")
            if command -v chromium &> /dev/null || command -v chromium-browser &> /dev/null; then
                installed_browsers+=("Chromium")
            else
                failed_browsers+=("Chromium")
            fi
            ;;
        "google-chrome")
            if command -v google-chrome &> /dev/null || command -v google-chrome-stable &> /dev/null; then
                installed_browsers+=("Google Chrome")
            else
                failed_browsers+=("Google Chrome")
            fi
            ;;
        "brave")
            if command -v brave &> /dev/null || command -v brave-browser &> /dev/null; then
                installed_browsers+=("Brave Browser")
            else
                failed_browsers+=("Brave Browser")
            fi
            ;;
        "vivaldi")
            if command -v vivaldi &> /dev/null || command -v vivaldi-stable &> /dev/null; then
                installed_browsers+=("Vivaldi")
            else
                failed_browsers+=("Vivaldi")
            fi
            ;;
        "opera")
            if command -v opera &> /dev/null || command -v opera-stable &> /dev/null; then
                installed_browsers+=("Opera")
            else
                failed_browsers+=("Opera")
            fi
            ;;
    esac
done

# Step 4: Display results
echo
echo "Browser installation complete!"
echo

if [ ${#installed_browsers[@]} -gt 0 ]; then
    echo "Successfully installed browsers:"
    for browser in "${installed_browsers[@]}"; do
        echo "  ✓ $browser"
    done
fi

if [ ${#failed_browsers[@]} -gt 0 ]; then
    echo
    echo "Failed to install browsers:"
    for browser in "${failed_browsers[@]}"; do
        echo "  ✗ $browser"
    done
    echo
    echo "Note: Some browsers may require manual installation or AUR helpers on Arch Linux."
fi

echo
echo "Browser features comparison:"
echo "• Chromium: Open-source base for Chrome, privacy-focused"
echo "• Google Chrome: Full-featured with Google services integration"
echo "• Brave Browser: Privacy-focused with built-in ad blocking"
echo "• Vivaldi: Highly customizable with advanced features"
echo "• Opera: Feature-rich with built-in VPN and workspaces"
echo
echo "All browsers should now be available in your applications menu."