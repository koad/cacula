#!/usr/bin/env bash

# Docker Installation Script
# This script installs Docker and sets up the docker group for non-root access

# Step 1: Detect the operating system
echo "Detecting operating system..."
OS="$(uname -s)"
ARCH="$(uname -m)"

case "${OS}" in
    Linux*)
        echo "Linux detected. Installing Docker for Linux..."

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
        echo "macOS detected. Installing Docker Desktop for macOS..."

        # Check if Homebrew is available
        if ! command -v brew &> /dev/null; then
            echo "Error: Homebrew is required for macOS installation"
            echo "Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    *)
        echo "Unsupported operating system: ${OS}"
        echo "Please visit https://docs.docker.com/get-docker/ for manual installation"
        exit 1
        ;;
esac

# Function to install Docker on Linux
install_linux_docker() {
    echo "Installing Docker on Linux ($DISTRO)..."

    case "${DISTRO}" in
        ubuntu|debian)
            echo "Installing Docker via apt and official Docker repository..."

            # Remove old versions
            echo "Removing old Docker versions..."
            sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

            # Update package index
            sudo apt-get update

            # Install prerequisites
            echo "Installing prerequisites..."
            sudo apt-get install -y ca-certificates curl gnupg lsb-release

            # Add Docker's official GPG key
            echo "Adding Docker GPG key..."
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/$DISTRO/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

            # Set up repository
            echo "Setting up Docker repository..."
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$DISTRO $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

            # Install Docker Engine
            echo "Installing Docker Engine..."
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;

        fedora)
            echo "Installing Docker via dnf and official Docker repository..."

            # Remove old versions
            echo "Removing old Docker versions..."
            sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine 2>/dev/null || true

            # Install prerequisites
            echo "Installing prerequisites..."
            sudo dnf install -y dnf-plugins-core

            # Add Docker repository
            echo "Adding Docker repository..."
            sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

            # Install Docker Engine
            echo "Installing Docker Engine..."
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;

        centos|rhel)
            echo "Installing Docker via yum and official Docker repository..."

            # Remove old versions
            echo "Removing old Docker versions..."
            sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine 2>/dev/null || true

            # Install prerequisites
            echo "Installing prerequisites..."
            sudo yum install -y yum-utils

            # Add Docker repository
            echo "Adding Docker repository..."
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

            # Install Docker Engine
            echo "Installing Docker Engine..."
            sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;

        arch|manjaro)
            echo "Installing Docker via pacman..."

            # Install Docker from official repositories
            echo "Installing Docker..."
            sudo pacman -S --noconfirm docker docker-compose
            ;;

        *)
            echo "Unsupported Linux distribution: ${DISTRO}"
            echo "Please install Docker manually for your distribution"
            echo "Visit: https://docs.docker.com/engine/install/"
            return 1
            ;;
    esac

    # Start and enable Docker service
    echo "Starting and enabling Docker service..."
    sudo systemctl start docker
    sudo systemctl enable docker
}

# Function to install Docker on macOS
install_macos_docker() {
    echo "Installing Docker Desktop on macOS via Homebrew..."

    # Install Docker Desktop using Homebrew cask
    brew install --cask docker

    echo "Docker Desktop installed. Please start it from Applications or Launchpad."
}

# Function to setup Docker group
setup_docker_group() {
    echo "Setting up Docker group for non-root access..."

    # Create docker group if it doesn't exist
    if ! getent group docker > /dev/null 2>&1; then
        echo "Creating docker group..."
        sudo groupadd docker
    else
        echo "Docker group already exists."
    fi

    # Add current user to docker group
    echo "Adding user $USER to docker group..."
    sudo usermod -aG docker $USER

    echo "Docker group setup complete!"
    echo "Note: You may need to log out and back in for group changes to take effect."
    echo "Or run: newgrp docker"
}

# Step 2: Install Docker based on OS
if [[ "$OS" == "Linux" ]]; then
    install_linux_docker
    if [ $? -eq 0 ]; then
        setup_docker_group
    fi
elif [[ "$OS" == "Darwin" ]]; then
    install_macos_docker
fi

# Step 3: Verify installation
echo
echo "Verifying Docker installation..."

if command -v docker &> /dev/null; then
    echo "Docker installed successfully!"
    echo "Docker version: $(docker --version)"

    # Test Docker installation (only on Linux where daemon should be running)
    if [[ "$OS" == "Linux" ]]; then
        echo "Testing Docker installation..."
        if sudo docker run hello-world &> /dev/null; then
            echo "Docker test successful!"
        else
            echo "Warning: Docker test failed. Docker daemon may not be running."
        fi
    fi
else
    echo "Warning: docker command not found"
    echo "Installation may have failed"
fi

# Step 4: Check Docker Compose
if command -v docker-compose &> /dev/null || docker compose version &> /dev/null 2>&1; then
    echo "Docker Compose is available"
    if command -v docker-compose &> /dev/null; then
        echo "Docker Compose version: $(docker-compose --version)"
    else
        echo "Docker Compose version: $(docker compose version)"
    fi
else
    echo "Docker Compose not found"
fi

# Step 5: Display usage information
echo
echo "Docker installation complete!"
echo
echo "Getting started with Docker:"
echo "1. Test Docker installation:"
echo "   > docker run hello-world"
echo
echo "2. Run a container:"
echo "   > docker run -it ubuntu bash"
echo
echo "3. List running containers:"
echo "   > docker ps"
echo
echo "4. List all containers:"
echo "   > docker ps -a"
echo
echo "5. List images:"
echo "   > docker images"
echo
echo "Common Docker commands:"
echo "- Pull an image: docker pull <image>"
echo "- Run container: docker run <image>"
echo "- Stop container: docker stop <container_id>"
echo "- Remove container: docker rm <container_id>"
echo "- Remove image: docker rmi <image>"
echo "- Build image: docker build -t <name> ."
echo "- View logs: docker logs <container_id>"
echo
echo "Docker Compose commands:"
echo "- Start services: docker-compose up"
echo "- Start in background: docker-compose up -d"
echo "- Stop services: docker-compose down"
echo "- View logs: docker-compose logs"
echo
if [[ "$OS" == "Linux" ]]; then
    echo "Important: To use Docker without sudo, either:"
    echo "1. Log out and back in, or"
    echo "2. Run: newgrp docker"
    echo
fi
echo "Resources:"
echo "- Official Documentation: https://docs.docker.com/"
echo "- Docker Hub: https://hub.docker.com/"
echo "- Get Started Guide: https://docs.docker.com/get-started/"