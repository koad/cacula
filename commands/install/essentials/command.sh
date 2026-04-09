#!/usr/bin/env bash

# VPS Essentials Installation Script
# This script installs only the essential packages needed for VPS administration

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
        echo "Linux detected. Installing VPS essentials for Linux..."

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
        echo "macOS detected. Installing server essentials for macOS..."

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

    *)
        echo "Unsupported operating system: ${OS}"
        echo "This script is designed for server/VPS environments (Linux/macOS)"
        exit 1
        ;;
esac

# Function to install essentials on Linux
install_linux_essentials() {
    echo "Installing VPS essentials on Linux ($DISTRO)..."

    case "${DISTRO}" in
        ubuntu|debian)
            echo "Installing essentials via apt..."

            # Fix any interrupted dpkg operations first
            echo "Checking for interrupted dpkg operations..."
            sudo dpkg --configure -a

            # Update package index
            sudo apt-get update

            # Essential VPS packages
            PACKAGES=(
                # Network essentials
                "curl" "wget" "openssh-server" "net-tools" "dnsutils" "wl-clipboard" "xclip" "xsel" "xdotool"
                # System monitoring
                "htop" "iotop" "tree" "lsof" "ncdu"
                # Text editors and processing
                "vim" "nano" "jq" "grep" "sed"
                # File management
                "zip" "unzip" "rsync" "tar" "gzip"
                # Security essentials
                "ufw" "fail2ban" "gnupg" "ca-certificates"
                # System utilities
                "tmux" "screen" "cron" "logrotate"
                # Development basics
                "git" "build-essential" "python3" "python3-pip"
                # Process management
                "supervisor" "systemd"
                # Backup and sync
                "rclone"
            )

            echo "Installing ${#PACKAGES[@]} essential packages in batch..."
            if ! sudo apt-get install -y "${PACKAGES[@]}"; then
                echo "Batch installation failed. Attempting to fix broken packages..."
                handle_error
                echo "Retrying batch installation..."
                if ! sudo apt-get install -y "${PACKAGES[@]}"; then
                    echo "Batch retry failed. Installing packages individually to identify issues..."
                    for package in "${PACKAGES[@]}"; do
                        echo "Installing $package..."
                        if ! sudo apt-get install -y "$package"; then
                            echo "Warning: Failed to install $package, continuing..."
                        fi
                    done
                fi
            fi

            # Enable and start essential services
            echo "Enabling essential services..."
            sudo systemctl enable ssh 2>/dev/null || sudo systemctl enable sshd 2>/dev/null || true
            sudo systemctl enable fail2ban 2>/dev/null || true
            sudo systemctl enable ufw 2>/dev/null || true
            
            # Configure basic firewall
            echo "Configuring basic firewall..."
            sudo ufw --force enable
            sudo ufw default deny incoming
            sudo ufw default allow outgoing
            sudo ufw allow ssh
            ;;

        fedora)
            echo "Installing essentials via dnf..."

            PACKAGES=(
                # Network essentials
                "curl" "wget" "openssh-server" "net-tools" "bind-utils" "wl-clipboard" "xclip" "xsel" "xdotool"
                # System monitoring
                "htop" "iotop" "tree" "lsof" "ncdu"
                # Text editors and processing
                "vim" "nano" "jq" "grep" "sed"
                # File management
                "zip" "unzip" "rsync" "tar" "gzip"
                # Security essentials
                "firewalld" "fail2ban" "gnupg2" "ca-certificates"
                # System utilities
                "tmux" "screen" "cronie" "logrotate"
                # Development basics
                "git" "@development-tools" "python3" "python3-pip"
                # Process management
                "supervisor" "systemd"
                # Backup and sync
                "rclone"
            )

            echo "Installing ${#PACKAGES[@]} essential packages in batch..."
            if ! sudo dnf install -y "${PACKAGES[@]}"; then
                echo "Batch installation failed. Retrying..."
                handle_error
                if ! sudo dnf install -y "${PACKAGES[@]}"; then
                    echo "Batch retry failed. Installing packages individually to identify issues..."
                    for package in "${PACKAGES[@]}"; do
                        echo "Installing $package..."
                        if ! sudo dnf install -y "$package"; then
                            echo "Warning: Failed to install $package, continuing..."
                        fi
                    done
                fi
            fi

            # Enable and start essential services
            echo "Enabling essential services..."
            sudo systemctl enable sshd
            sudo systemctl enable fail2ban 2>/dev/null || true
            sudo systemctl enable firewalld
            
            # Configure basic firewall
            echo "Configuring basic firewall..."
            sudo firewall-cmd --permanent --add-service=ssh
            sudo firewall-cmd --reload
            ;;

        centos|rhel)
            echo "Installing essentials via yum..."

            # Enable EPEL repository first
            echo "Enabling EPEL repository..."
            if ! sudo yum install -y epel-release; then
                echo "Error installing EPEL repository. Retrying..."
                handle_error
                sudo yum install -y epel-release
            fi

            PACKAGES=(
                # Network essentials
                "curl" "wget" "openssh-server" "net-tools" "bind-utils" "wl-clipboard" "xclip" "xsel" "xdotool"
                # System monitoring
                "htop" "iotop" "tree" "lsof" "ncdu"
                # Text editors and processing
                "vim" "nano" "jq" "grep" "sed"
                # File management
                "zip" "unzip" "rsync" "tar" "gzip"
                # Security essentials
                "firewalld" "fail2ban" "gnupg2" "ca-certificates"
                # System utilities
                "tmux" "screen" "cronie" "logrotate"
                # Development basics
                "git" "gcc" "python3" "python3-pip"
                # Process management
                "supervisor" "systemd"
            )

            echo "Installing ${#PACKAGES[@]} essential packages in batch..."
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

            # Enable and start essential services
            echo "Enabling essential services..."
            sudo systemctl enable sshd
            sudo systemctl enable fail2ban 2>/dev/null || true
            sudo systemctl enable firewalld
            
            # Configure basic firewall
            echo "Configuring basic firewall..."
            sudo firewall-cmd --permanent --add-service=ssh
            sudo firewall-cmd --reload
            ;;

        arch|manjaro)
            echo "Installing essentials via pacman..."

            PACKAGES=(
                # Network essentials
                "curl" "wget" "openssh" "net-tools" "bind" "wl-clipboard" "xclip" "xsel" "xdotool"
                # System monitoring
                "htop" "iotop" "tree" "lsof" "ncdu"
                # Text editors and processing
                "vim" "nano" "jq" "grep" "sed"
                # File management
                "zip" "unzip" "rsync" "tar" "gzip"
                # Security essentials
                "ufw" "fail2ban" "gnupg" "ca-certificates"
                # System utilities
                "tmux" "screen" "cronie" "logrotate"
                # Development basics
                "git" "base-devel" "python" "python-pip"
                # Process management
                "supervisor"
                # Backup and sync
                "rclone"
            )

            echo "Installing ${#PACKAGES[@]} essential packages in batch..."
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

            # Enable and start essential services
            echo "Enabling essential services..."
            sudo systemctl enable sshd
            sudo systemctl enable fail2ban 2>/dev/null || true
            sudo systemctl enable ufw 2>/dev/null || true
            
            # Configure basic firewall
            echo "Configuring basic firewall..."
            sudo ufw --force enable
            sudo ufw default deny incoming
            sudo ufw default allow outgoing
            sudo ufw allow ssh
            ;;

        *)
            echo "Unsupported Linux distribution: ${DISTRO}"
            return 1
            ;;
    esac
}

# Function to install essentials on macOS (for server use)
install_macos_essentials() {
    echo "Installing server essentials on macOS via Homebrew..."

    # Essential server packages
    PACKAGES=(
        # Network essentials
        "curl" "wget" "openssh"
        # System monitoring
        "htop" "tree" "lsof" "ncdu"
        # Text editors and processing
        "vim" "nano" "jq" "grep" "sed"
        # File management
        "zip" "unzip" "rsync" "tar" "gzip"
        # Security essentials
        "gnupg" "ca-certificates"
        # System utilities
        "tmux" "screen"
        # Development basics
        "git" "python3"
        # Backup and sync
        "rclone"
    )

    echo "Installing ${#PACKAGES[@]} essential packages via Homebrew in batch..."
    if ! brew install "${PACKAGES[@]}"; then
        echo "Batch installation failed. Installing packages individually to identify issues..."
        for package in "${PACKAGES[@]}"; do
            echo "Installing $package..."
            if ! brew install "$package"; then
                echo "Warning: Failed to install $package, continuing..."
            fi
        done
    fi
}

# Step 2: Install essentials based on OS
if [[ "$OS" == "Linux" ]]; then
    install_linux_essentials
elif [[ "$OS" == "Darwin" ]]; then
    install_macos_essentials
fi

# Step 3: Configure basic security settings
echo
echo "Configuring basic security settings..."

# Create basic fail2ban jail for SSH
if command -v fail2ban-server &> /dev/null; then
    echo "Configuring Fail2ban for SSH protection..."
    sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3
EOF

    sudo systemctl restart fail2ban 2>/dev/null || true
fi

# Step 4: Display completion message and essential commands
echo
echo "VPS Essentials installation complete!"
echo
echo "Essential packages installed:"
echo "✓ Network tools (curl, wget, openssh, net-tools)"
echo "✓ System monitoring (htop, iotop, tree, lsof, ncdu)"
echo "✓ Text editors (vim, nano, jq)"
echo "✓ File management (zip, rsync, tar)"
echo "✓ Security tools (firewall, fail2ban, gnupg)"
echo "✓ System utilities (tmux, screen, cron)"
echo "✓ Development basics (git, build tools, python)"
echo "✓ Process management (supervisor, systemd)"
echo "✓ Backup tools (rclone)"
echo
echo "Essential VPS administration commands:"
echo
echo "System Monitoring:"
echo "- Process monitor: htop"
echo "- Disk usage: ncdu / or df -h"
echo "- Memory usage: free -h"
echo "- Network connections: netstat -tulpn"
echo "- Open files: lsof"
echo "- System logs: journalctl -f"
echo
echo "File Management:"
echo "- Sync files: rsync -avz source/ dest/"
echo "- Cloud sync: rclone sync local remote:"
echo "- Archive: tar -czf backup.tar.gz /path/to/files"
echo "- Extract: tar -xzf backup.tar.gz"
echo
echo "Security:"
echo "- Firewall status: sudo ufw status (Ubuntu/Debian) or sudo firewall-cmd --list-all (CentOS/RHEL)"
echo "- Fail2ban status: sudo fail2ban-client status"
echo "- SSH config: /etc/ssh/sshd_config"
echo "- Check failed logins: sudo journalctl -u ssh"
echo
echo "Process Management:"
echo "- Service status: sudo systemctl status <service>"
echo "- Start service: sudo systemctl start <service>"
echo "- Enable service: sudo systemctl enable <service>"
echo "- View all services: sudo systemctl list-units --type=service"
echo
echo "Session Management:"
echo "- Start tmux: tmux new -s session_name"
echo "- Attach tmux: tmux attach -t session_name"
echo "- List sessions: tmux list-sessions"
echo
echo "Your VPS is now equipped with essential administration tools! 🚀"
echo
echo "Next steps:"
echo "1. Configure SSH key authentication"
echo "2. Set up automatic updates"
echo "3. Configure log rotation"
echo "4. Set up monitoring and alerting"
echo "5. Create regular backup schedules"
