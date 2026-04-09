#!/usr/bin/env bash

# Goodies Installation Script
# This script installs various useful utilities and tools for development and system administration

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
        echo "Linux detected. Installing goodies for Linux..."

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
        echo "macOS detected. Installing goodies for macOS..."

        # Check if Homebrew is available, install if not
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Installing Homebrew first..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH for current session
            if [[ "$ARCH" == "arm64" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            else
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
        ;;

    CYGWIN*|MINGW*|MSYS*)
        echo "Windows detected. Installing goodies for Windows..."
        
        # Check for package managers
        if command -v choco &> /dev/null; then
            WINDOWS_PKG_MGR="chocolatey"
        elif command -v winget &> /dev/null; then
            WINDOWS_PKG_MGR="winget"
        elif command -v scoop &> /dev/null; then
            WINDOWS_PKG_MGR="scoop"
        else
            echo "No supported package manager found (chocolatey, winget, or scoop)"
            echo "Please install one of these package managers first:"
            echo "- Chocolatey: https://chocolatey.org/install"
            echo "- Winget: https://github.com/microsoft/winget-cli"
            echo "- Scoop: https://scoop.sh/"
            exit 1
        fi
        ;;

    *)
        echo "Unsupported operating system: ${OS}"
        exit 1
        ;;
esac

# Function to install goodies on Linux
install_linux_goodies() {
    echo "Installing goodies on Linux ($DISTRO)..."

    # Define package lists for different distributions
    case "${DISTRO}" in
        ubuntu|debian)
            echo "Installing goodies via apt..."

            # Fix any interrupted dpkg operations first
            echo "Checking for interrupted dpkg operations..."
            sudo dpkg --configure -a

            # Update package index
            sudo apt-get update

            # Core utilities and tools
            PACKAGES=(
                # Network tools
                "net-tools" "curl" "wget" "nmap" "netcat-openbsd" "traceroute" "dnsutils" "whois"
                # System monitoring and process management
                "htop" "iotop" "iftop" "ncdu" "tree" "lsof" "strace" "tcpdump"
                # Text processing and editors
                "vim" "nano" "jq" "yq" "grep" "sed" "awk" "less" "most"
                # File management and compression
                "zip" "unzip" "p7zip-full" "rsync" "rclone" "fd-find" "ripgrep"
                # Development tools
                "git" "build-essential" "cmake" "make" "gcc" "g++" "gdb" "valgrind"
                # Diff and merge tools
                "meld" "diff" "colordiff" "wdiff"
                # System information
                "neofetch" "inxi" "lshw" "hwinfo" "dmidecode"
                # Security and encryption
                "gnupg" "openssl" "ca-certificates" "fail2ban"
                # Archive and backup
                "tar" "gzip" "bzip2" "xz-utils" "pigz"
                # Performance and benchmarking
                "stress" "stress-ng" "sysbench" "iperf3"
                # Misc utilities
                "tmux" "screen" "bc" "figlet" "cowsay" "fortune-mod" "sl"
                # Python and package management
                "python3" "python3-pip" "python3-venv"
                # Additional useful tools
                "bat" "exa" "fzf" "silversearcher-ag" "tldr"
            )

            echo "Installing ${#PACKAGES[@]} packages..."
            for package in "${PACKAGES[@]}"; do
                echo "Installing $package..."
                if ! sudo apt-get install -y "$package"; then
                    echo "Warning: Failed to install $package, continuing..."
                fi
            done

            # Install additional tools via snap if available
            if command -v snap &> /dev/null; then
                echo "Installing additional tools via snap..."
                sudo snap install code --classic 2>/dev/null || echo "VS Code snap installation failed"
                sudo snap install discord 2>/dev/null || echo "Discord snap installation failed"
            fi
            ;;

        fedora)
            echo "Installing goodies via dnf..."

            PACKAGES=(
                # Network tools
                "net-tools" "curl" "wget" "nmap" "nc" "traceroute" "bind-utils" "whois"
                # System monitoring
                "htop" "iotop" "iftop" "ncdu" "tree" "lsof" "strace" "tcpdump"
                # Text processing
                "vim" "nano" "jq" "yq" "grep" "sed" "gawk" "less" "most"
                # File management
                "zip" "unzip" "p7zip" "rsync" "rclone" "fd-find" "ripgrep"
                # Development tools
                "git" "@development-tools" "cmake" "make" "gcc" "gcc-c++" "gdb" "valgrind"
                # Diff tools
                "meld" "diffutils" "colordiff" "wdiff"
                # System info
                "neofetch" "inxi" "lshw" "hwinfo" "dmidecode"
                # Security
                "gnupg2" "openssl" "ca-certificates" "fail2ban"
                # Archives
                "tar" "gzip" "bzip2" "xz" "pigz"
                # Performance
                "stress" "stress-ng" "sysbench" "iperf3"
                # Utilities
                "tmux" "screen" "bc" "figlet" "cowsay" "fortune-mod" "sl"
                # Python
                "python3" "python3-pip"
                # Additional tools
                "bat" "exa" "fzf" "the_silver_searcher" "tldr"
            )

            for package in "${PACKAGES[@]}"; do
                echo "Installing $package..."
                if ! sudo dnf install -y "$package"; then
                    echo "Warning: Failed to install $package, continuing..."
                fi
            done
            ;;

        centos|rhel)
            echo "Installing goodies via yum..."

            # Enable EPEL repository first
            echo "Enabling EPEL repository..."
            sudo yum install -y epel-release

            PACKAGES=(
                # Network tools
                "net-tools" "curl" "wget" "nmap" "nc" "traceroute" "bind-utils" "whois"
                # System monitoring
                "htop" "iotop" "iftop" "ncdu" "tree" "lsof" "strace" "tcpdump"
                # Text processing
                "vim" "nano" "jq" "grep" "sed" "gawk" "less"
                # File management
                "zip" "unzip" "p7zip" "rsync"
                # Development tools
                "git" "gcc" "gcc-c++" "make" "cmake" "gdb"
                # Diff tools
                "meld" "diffutils"
                # System info
                "neofetch" "inxi" "lshw" "dmidecode"
                # Security
                "gnupg2" "openssl" "ca-certificates"
                # Archives
                "tar" "gzip" "bzip2" "xz" "pigz"
                # Utilities
                "tmux" "screen" "bc" "figlet" "cowsay" "fortune-mod"
                # Python
                "python3" "python3-pip"
            )

            echo "Installing ${#PACKAGES[@]} packages in batch..."
            if ! sudo yum install -y "${PACKAGES[@]}"; then
                echo "Batch installation failed. Retrying..."
                handle_error
                if ! sudo yum install -y "${PACKAGES[@]}"; then
                    echo "Batch retry failed. Installing packages individually to identify issues..."
                    for package in "${PACKAGES[@]}"; do
                        echo "Installing $package..."
                        if ! sudo yum install -y "$package"; then
                            echo "Warning: Failed to install $package, continuing..."
                        fi
                    done
                fi
            fi
            ;;

        arch|manjaro)
            echo "Installing goodies via pacman..."

            PACKAGES=(
                # Network tools
                "net-tools" "curl" "wget" "nmap" "gnu-netcat" "traceroute" "bind" "whois"
                # System monitoring
                "htop" "iotop" "iftop" "ncdu" "tree" "lsof" "strace" "tcpdump"
                # Text processing
                "vim" "nano" "jq" "yq" "grep" "sed" "gawk" "less" "most"
                # File management
                "zip" "unzip" "p7zip" "rsync" "rclone" "fd" "ripgrep"
                # Development tools
                "git" "base-devel" "cmake" "make" "gcc" "gdb" "valgrind"
                # Diff tools
                "meld" "diffutils" "colordiff" "wdiff"
                # System info
                "neofetch" "inxi" "lshw" "hwinfo" "dmidecode"
                # Security
                "gnupg" "openssl" "ca-certificates" "fail2ban"
                # Archives
                "tar" "gzip" "bzip2" "xz" "pigz"
                # Performance
                "stress" "sysbench" "iperf3"
                # Utilities
                "tmux" "screen" "bc" "figlet" "cowsay" "fortune-mod" "sl"
                # Python
                "python" "python-pip"
                # Additional tools
                "bat" "exa" "fzf" "the_silver_searcher" "tldr"
            )

            echo "Installing ${#PACKAGES[@]} packages in batch..."
            if ! sudo pacman -S --noconfirm "${PACKAGES[@]}"; then
                echo "Batch installation failed. Retrying with updated package database..."
                sudo pacman -Sy
                if ! sudo pacman -S --noconfirm "${PACKAGES[@]}"; then
                    echo "Batch retry failed. Installing packages individually to identify issues..."
                    for package in "${PACKAGES[@]}"; do
                        echo "Installing $package..."
                        if ! sudo pacman -S --noconfirm "$package"; then
                            echo "Warning: Failed to install $package, continuing..."
                        fi
                    done
                fi
            fi
            ;;

        *)
            echo "Unsupported Linux distribution: ${DISTRO}"
            return 1
            ;;
    esac

    # Install Homebrew on Linux if requested
    echo
    read -p "Would you like to install Homebrew on Linux for additional packages? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing Homebrew on Linux..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add to PATH
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        
        # Install some additional tools via Homebrew in batch
        if ! brew install gh lazygit bottom dust procs bandwhich dog; then
            echo "Batch Homebrew installation failed. Installing individually..."
            for pkg in gh lazygit bottom dust procs bandwhich dog; do
                brew install "$pkg" || echo "Warning: Failed to install $pkg"
            done
        fi
    fi
}

# Function to install goodies on macOS
install_macos_goodies() {
    echo "Installing goodies on macOS via Homebrew..."

    # Core utilities and tools
    PACKAGES=(
        # Network tools
        "curl" "wget" "nmap" "netcat" "traceroute" "whois" "dog"
        # System monitoring
        "htop" "iotop" "ncdu" "tree" "lsof" "tcpdump" "bottom" "procs"
        # Text processing
        "vim" "nano" "jq" "yq" "grep" "sed" "gawk" "less" "most"
        # File management
        "zip" "unzip" "p7zip" "rsync" "rclone" "fd" "ripgrep" "dust"
        # Development tools
        "git" "cmake" "make" "gcc" "gdb" "gh" "lazygit"
        # Diff tools
        "meld" "diff-so-fancy" "colordiff" "wdiff"
        # System info
        "neofetch" "inxi"
        # Security
        "gnupg" "openssl" "ca-certificates"
        # Performance
        "stress" "iperf3" "bandwhich"
        # Utilities
        "tmux" "screen" "bc" "figlet" "cowsay" "fortune" "sl"
        # Python
        "python3" "pipenv"
        # Additional modern tools
        "bat" "exa" "fzf" "the_silver_searcher" "tldr" "mas"
        # macOS specific
        "cask" "mas" "duti" "trash"
    )

    echo "Installing ${#PACKAGES[@]} packages via Homebrew in batch..."
    if ! brew install "${PACKAGES[@]}"; then
        echo "Batch installation failed. Installing packages individually to identify issues..."
        for package in "${PACKAGES[@]}"; do
            echo "Installing $package..."
            if ! brew install "$package"; then
                echo "Warning: Failed to install $package, continuing..."
            fi
        done
    fi

    # Install GUI applications via Homebrew Cask
    echo "Installing GUI applications via Homebrew Cask..."
    CASK_PACKAGES=(
        "visual-studio-code" "iterm2" "firefox" "google-chrome"
        "vlc" "the-unarchiver" "appcleaner" "rectangle"
        "discord" "slack" "zoom" "spotify"
        "docker" "postman" "wireshark"
    )

    echo "Installing ${#CASK_PACKAGES[@]} cask packages in batch..."
    if ! brew install --cask "${CASK_PACKAGES[@]}"; then
        echo "Batch cask installation failed. Installing packages individually to identify issues..."
        for package in "${CASK_PACKAGES[@]}"; do
            echo "Installing $package..."
            if ! brew install --cask "$package"; then
                echo "Warning: Failed to install $package, continuing..."
            fi
        done
    fi
}

# Function to install goodies on Windows
install_windows_goodies() {
    echo "Installing goodies on Windows via $WINDOWS_PKG_MGR..."

    case "$WINDOWS_PKG_MGR" in
        "chocolatey")
            PACKAGES=(
                # Network tools
                "curl" "wget" "nmap" "wireshark" "putty"
                # System monitoring
                "procexp" "procmon" "autoruns" "sysinternals"
                # Text editors and processing
                "vim" "notepadplusplus" "jq" "grep" "sed"
                # File management
                "7zip" "winrar" "rsync" "rclone" "fd" "ripgrep"
                # Development tools
                "git" "cmake" "make" "gcc" "gdb" "github-desktop"
                # Diff tools
                "meld" "winmerge" "beyondcompare"
                # System info
                "neofetch" "hwinfo" "cpu-z" "gpu-z"
                # Security
                "gnupg" "openssl"
                # Utilities
                "tmux" "screen" "bc" "figlet" "cowsay"
                # Python
                "python3" "pip"
                # Additional tools
                "bat" "fzf" "ag" "tldr"
                # Windows specific
                "powertoys" "everything" "windirstat" "ccleaner"
                # Browsers and apps
                "firefox" "googlechrome" "vlc" "discord" "slack" "zoom" "spotify"
                # Development
                "vscode" "docker-desktop" "postman"
            )

            echo "Installing ${#PACKAGES[@]} packages via Chocolatey in batch..."
            if ! choco install -y "${PACKAGES[@]}"; then
                echo "Batch installation failed. Installing packages individually to identify issues..."
                for package in "${PACKAGES[@]}"; do
                    echo "Installing $package..."
                    if ! choco install -y "$package"; then
                        echo "Warning: Failed to install $package, continuing..."
                    fi
                done
            fi
            ;;

        "winget")
            PACKAGES=(
                # Development tools
                "Git.Git" "Microsoft.VisualStudioCode" "GitHub.GitHubDesktop"
                # Browsers
                "Mozilla.Firefox" "Google.Chrome"
                # Utilities
                "7zip.7zip" "WinRAR.WinRAR" "Notepad++.Notepad++"
                # System tools
                "Microsoft.PowerToys" "voidtools.Everything" "WinDirStat.WinDirStat"
                # Media
                "VideoLAN.VLC" "Spotify.Spotify"
                # Communication
                "Discord.Discord" "SlackTechnologies.Slack" "Zoom.Zoom"
                # Development
                "Docker.DockerDesktop" "Postman.Postman"
            )

            echo "Installing ${#PACKAGES[@]} packages via Winget..."
            # Note: Winget doesn't support batch installation, so we install individually
            for package in "${PACKAGES[@]}"; do
                echo "Installing $package..."
                if ! winget install -e --id "$package"; then
                    echo "Warning: Failed to install $package, continuing..."
                fi
            done
            ;;

        "scoop")
            # Add extra buckets
            scoop bucket add extras
            scoop bucket add versions
            scoop bucket add java

            PACKAGES=(
                # Network tools
                "curl" "wget" "nmap" "putty"
                # System monitoring
                "procexp" "procmon"
                # Text processing
                "vim" "nano" "jq" "grep" "sed"
                # File management
                "7zip" "rsync" "rclone" "fd" "ripgrep"
                # Development tools
                "git" "cmake" "make" "gcc" "gdb"
                # Utilities
                "tmux" "bc" "figlet" "cowsay"
                # Python
                "python" "pip"
                # Additional tools
                "bat" "fzf" "ag" "tldr"
            )

            echo "Installing ${#PACKAGES[@]} packages via Scoop..."
            # Note: Scoop doesn't support batch installation, so we install individually
            for package in "${PACKAGES[@]}"; do
                echo "Installing $package..."
                if ! scoop install "$package"; then
                    echo "Warning: Failed to install $package, continuing..."
                fi
            done
            ;;
    esac
}

# Step 2: Install goodies based on OS
if [[ "$OS" == "Linux" ]]; then
    install_linux_goodies
elif [[ "$OS" == "Darwin" ]]; then
    install_macos_goodies
elif [[ "$OS" == CYGWIN* ]] || [[ "$OS" == MINGW* ]] || [[ "$OS" == MSYS* ]]; then
    install_windows_goodies
fi

# Step 3: Display completion message
echo
echo "Goodies installation complete!"
echo
echo "Installed categories include:"
echo "✓ Network tools (curl, wget, nmap, netcat, etc.)"
echo "✓ System monitoring (htop, iotop, tree, lsof, etc.)"
echo "✓ Text processing (vim, jq, grep, sed, etc.)"
echo "✓ File management (zip, rsync, fd, ripgrep, etc.)"
echo "✓ Development tools (git, gcc, cmake, gdb, etc.)"
echo "✓ Diff and merge tools (meld, colordiff, etc.)"
echo "✓ System information (neofetch, inxi, hwinfo, etc.)"
echo "✓ Security tools (gnupg, openssl, fail2ban, etc.)"
echo "✓ Performance tools (stress, iperf3, sysbench, etc.)"
echo "✓ Utilities (tmux, screen, figlet, cowsay, etc.)"
echo "✓ Modern alternatives (bat, exa, bottom, dust, etc.)"
echo
echo "Quick start commands to try:"
echo "- System info: neofetch"
echo "- Process monitor: htop"
echo "- File search: fd <pattern> or find . -name '*pattern*'"
echo "- Text search: rg <pattern> or grep -r <pattern> ."
echo "- Directory size: ncdu or du -sh *"
echo "- Network scan: nmap -sn 192.168.1.0/24"
echo "- JSON processing: cat file.json | jq '.'"
echo "- File differences: meld file1 file2"
echo "- Terminal multiplexer: tmux"
echo "- Fun: cowsay 'Hello World!' | figlet"
echo
echo "Enjoy your new goodies! 🎉"