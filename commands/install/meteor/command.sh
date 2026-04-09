#!/usr/bin/env bash

# Meteor.js Installation Script
# This script installs Meteor.js for full-stack JavaScript development

# Step 1: Detect the operating system
echo "Detecting operating system..."
OS="$(uname -s)"
ARCH="$(uname -m)"

case "${OS}" in
    Linux*|Darwin*)
        echo "${OS} detected. Installing Meteor.js..."

        # Step 2: Download and install Meteor using official installer
        echo "Downloading and installing Meteor.js..."
        curl https://install.meteor.com/ | sh

        # Step 3: Add Meteor to PATH if not already there
        echo "Checking if Meteor is in PATH..."
        if ! command -v meteor &> /dev/null; then
            echo "Adding Meteor to PATH..."

            # Add to .bashrc if it exists
            if [ -f ~/.bashrc ]; then
                echo 'export PATH="$HOME/.meteor:$PATH"' >> ~/.bashrc
            fi

            # Add to .zshrc if it exists
            if [ -f ~/.zshrc ]; then
                echo 'export PATH="$HOME/.meteor:$PATH"' >> ~/.zshrc
            fi

            # Add to current session
            export PATH="$HOME/.meteor:$PATH"
        fi
        ;;

    CYGWIN*|MINGW*|MSYS*)
        echo "Windows detected. Please use the Windows installer instead."
        echo "Download from: https://www.meteor.com/developers/install"
        echo "Or use Chocolatey: choco install meteor"
        exit 1
        ;;

    *)
        echo "Unsupported operating system: ${OS}"
        echo "Please visit https://www.meteor.com/developers/install for manual installation."
        exit 1
        ;;
esac

# Step 4: Verify installation
echo "Verifying Meteor installation..."
if command -v meteor &> /dev/null; then
    echo "Meteor installed successfully!"
    echo "Meteor version: $(meteor --version)"
else
    echo "Warning: meteor command not found in PATH"
    echo "You may need to restart your terminal or run: source ~/.bashrc"
fi

# Step 5: Check Node.js version compatibility
echo "Checking Node.js compatibility..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "Node.js version: $NODE_VERSION"
    echo "Note: Meteor includes its own Node.js runtime, but having Node.js installed is recommended for development tools."
else
    echo "Node.js not found. Consider installing Node.js for additional development tools."
    echo "You can use the nvm installer script in this same directory."
fi

# Step 6: Create example Meteor app (optional)
echo
read -p "Would you like to create an example Meteor app? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Creating example Meteor app..."
    cd ~
    meteor create my-meteor-app
    echo "Example app created at: ~/my-meteor-app"
    echo "To run the app:"
    echo "  cd ~/my-meteor-app"
    echo "  meteor"
fi

# Step 7: Display usage information
echo
echo "Meteor.js installation complete!"
echo
echo "Getting started with Meteor:"
echo "1. Create a new app:"
echo "   > meteor create my-app"
echo "2. Navigate to your app:"
echo "   > cd my-app"
echo "3. Run your app:"
echo "   > meteor"
echo "4. Open http://localhost:3000 in your browser"
echo
echo "Common Meteor commands:"
echo "- Create app: meteor create <app-name>"
echo "- Run app: meteor (or meteor run)"
echo "- Add package: meteor add <package-name>"
echo "- Remove package: meteor remove <package-name>"
echo "- List packages: meteor list"
echo "- Update Meteor: meteor update"
echo "- Build for production: meteor build <output-directory>"
echo "- Deploy to Galaxy: meteor deploy <site-name>.meteorapp.com"
echo
echo "Popular Meteor packages to try:"
echo "- accounts-ui: meteor add accounts-ui"
echo "- accounts-password: meteor add accounts-password"
echo "- iron:router: meteor add iron:router"
echo "- aldeed:collection2: meteor add aldeed:collection2"
echo "- twbs:bootstrap: meteor add twbs:bootstrap"
echo
echo "Resources:"
echo "- Official Guide: https://guide.meteor.com/"
echo "- API Documentation: https://docs.meteor.com/"
echo "- Atmosphere Packages: https://atmospherejs.com/"
echo "- Community: https://forums.meteor.com/"