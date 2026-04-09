#!/usr/bin/env bash

# Nginx Installation Script with Let's Encrypt
# This script installs Nginx web server with Let's Encrypt SSL certificate support

# Step 1: Detect the operating system
echo "Detecting operating system..."
OS="$(uname -s)"

case "${OS}" in
    Linux*)
        echo "Linux detected. Installing Nginx for Linux..."

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
        echo "macOS detected. Installing Nginx for macOS..."

        # Check if Homebrew is available
        if ! command -v brew &> /dev/null; then
            echo "Error: Homebrew is required for macOS installation"
            echo "Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        ;;

    *)
        echo "Unsupported operating system: ${OS}"
        echo "Please visit https://nginx.org/en/download.html for manual installation"
        exit 1
        ;;
esac

# Function to install latest stable Certbot via pip
install_certbot_pip() {
    echo "Installing latest stable Certbot via pip..."

    # Remove any existing certbot packages from package managers
    echo "Removing any existing certbot packages from package managers..."
    case "${DISTRO}" in
        ubuntu|debian)
            sudo apt remove -y certbot python3-certbot-nginx 2>/dev/null || true
            # Install Python3 and pip if not present
            sudo apt install -y python3 python3-pip python3-venv
            ;;
        fedora)
            sudo dnf remove -y certbot python3-certbot-nginx 2>/dev/null || true
            # Install Python3 and pip if not present
            sudo dnf install -y python3 python3-pip
            ;;
        centos|rhel)
            sudo yum remove -y certbot python3-certbot-nginx 2>/dev/null || true
            # Install Python3 and pip if not present
            sudo yum install -y python3 python3-pip
            ;;
        arch|manjaro)
            sudo pacman -R --noconfirm certbot certbot-nginx 2>/dev/null || true
            # Install Python3 and pip if not present
            sudo pacman -S --noconfirm python python-pip
            ;;
    esac

    # Install certbot using pip in a virtual environment (recommended method)
    echo "Creating Python virtual environment for Certbot..."
    sudo python3 -m venv /opt/certbot
    
    echo "Installing Certbot and Nginx plugin..."
    sudo /opt/certbot/bin/pip install --upgrade pip
    sudo /opt/certbot/bin/pip install certbot certbot-nginx

    # Create symbolic link to ensure certbot command is in PATH
    echo "Creating certbot symbolic link..."
    sudo ln -sf /opt/certbot/bin/certbot /usr/bin/certbot

    echo "Certbot installed successfully via pip!"
    echo "Certbot version: $(/usr/bin/certbot --version 2>&1)"
}

# Function to install Nginx and Certbot on Linux
install_linux_nginx() {
    echo "Installing Nginx and Let's Encrypt on Linux ($DISTRO)..."

    case "${DISTRO}" in
        ubuntu|debian)
            echo "Installing Nginx via apt..."

            # Update package index
            sudo apt update

            # Install Nginx
            echo "Installing Nginx..."
            sudo apt install -y nginx

            # Install additional useful packages including Fail2ban
            echo "Installing additional packages..."
            sudo apt install -y ufw curl wget fail2ban
            ;;

        fedora)
            echo "Installing Nginx via dnf..."

            # Install Nginx
            echo "Installing Nginx..."
            sudo dnf install -y nginx

            # Install additional useful packages including Fail2ban
            echo "Installing additional packages..."
            sudo dnf install -y firewalld curl wget fail2ban
            ;;

        centos|rhel)
            echo "Installing Nginx via yum..."

            # Enable EPEL repository
            echo "Enabling EPEL repository..."
            sudo yum install -y epel-release

            # Install Nginx
            echo "Installing Nginx..."
            sudo yum install -y nginx

            # Install additional useful packages including Fail2ban
            echo "Installing additional packages..."
            sudo yum install -y firewalld curl wget fail2ban
            ;;

        arch|manjaro)
            echo "Installing Nginx via pacman..."

            # Install Nginx
            echo "Installing Nginx..."
            sudo pacman -S --noconfirm nginx

            # Install additional useful packages including Fail2ban
            echo "Installing additional packages..."
            sudo pacman -S --noconfirm ufw curl wget fail2ban
            ;;

        *)
            echo "Unsupported Linux distribution: ${DISTRO}"
            echo "Please install Nginx and Certbot manually for your distribution"
            return 1
            ;;
    esac

    # Install latest stable Certbot via pip
    install_certbot_pip

    # Start and enable Nginx service
    echo "Starting and enabling Nginx service..."
    sudo systemctl start nginx
    sudo systemctl enable nginx

    # Configure firewall and Fail2ban
    configure_firewall
    configure_fail2ban
}

# Function to install Nginx on macOS
install_macos_nginx() {
    echo "Installing Nginx on macOS via Homebrew..."

    # Install Nginx
    echo "Installing Nginx..."
    brew install nginx

    # Install Certbot
    echo "Installing Certbot..."
    brew install certbot

    echo "Note: Let's Encrypt certificates on macOS require manual configuration."
    echo "Consider using a reverse proxy or cloud service for SSL termination."
}

# Function to configure firewall
configure_firewall() {
    echo "Configuring firewall for Nginx..."

    case "${DISTRO}" in
        ubuntu|debian|arch|manjaro)
            if command -v ufw &> /dev/null; then
                echo "Configuring UFW firewall..."
                sudo ufw allow 'Nginx Full'
                sudo ufw --force enable
            fi
            ;;
        fedora|centos|rhel)
            if command -v firewall-cmd &> /dev/null; then
                echo "Configuring firewalld..."
                sudo firewall-cmd --permanent --add-service=http
                sudo firewall-cmd --permanent --add-service=https
                sudo firewall-cmd --reload
            fi
            ;;
    esac
}

# Function to configure Fail2ban
configure_fail2ban() {
    echo "Configuring Fail2ban for Nginx protection..."

    # Detect ZeroTier interfaces
    echo "Detecting ZeroTier network interfaces..."
    ZEROTIER_IPS=""
    if command -v zerotier-cli &> /dev/null; then
        # Get ZeroTier network IPs
        ZEROTIER_IPS=$(ip addr show | grep -E "zt[0-9]+" -A 2 | grep "inet " | awk '{print $2}' | cut -d'/' -f1 | tr '\n' ' ')
        if [ -n "$ZEROTIER_IPS" ]; then
            echo "Found ZeroTier IPs: $ZEROTIER_IPS"
        fi
    fi

    # Also check for common ZeroTier subnet ranges
    ZT_SUBNETS="10.147.0.0/16 10.242.0.0/16 10.243.0.0/16 10.244.0.0/16"
    
    # Build ignoreip list
    IGNORE_IPS="127.0.0.1/8 ::1"
    if [ -n "$ZEROTIER_IPS" ]; then
        for ip in $ZEROTIER_IPS; do
            IGNORE_IPS="$IGNORE_IPS $ip"
        done
    fi
    # Add common ZeroTier subnets
    IGNORE_IPS="$IGNORE_IPS $ZT_SUBNETS"

    echo "Fail2ban will ignore these IPs/subnets: $IGNORE_IPS"

    # Create Fail2ban jail configuration for Nginx
    sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[DEFAULT]
# Ban hosts for one hour:
bantime = 3600

# Whitelist ZeroTier and localhost IPs
# These IPs will never be banned
ignoreip = $IGNORE_IPS

# Override /etc/fail2ban/jail.d/00-firewalld.conf:
banaction = iptables-multiport

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3

[nginx-http-auth]
enabled = true
filter = nginx-http-auth
port = http,https
logpath = /var/log/nginx/error.log
maxretry = 3

[nginx-limit-req]
enabled = true
filter = nginx-limit-req
port = http,https
logpath = /var/log/nginx/error.log
maxretry = 3

[nginx-botsearch]
enabled = true
filter = nginx-botsearch
port = http,https
logpath = /var/log/nginx/access.log
maxretry = 2

[nginx-noscript]
enabled = true
filter = nginx-noscript
port = http,https
logpath = /var/log/nginx/access.log
maxretry = 6

[nginx-noproxy]
enabled = true
filter = nginx-noproxy
port = http,https
logpath = /var/log/nginx/access.log
maxretry = 2

[nginx-badbots]
enabled = true
filter = nginx-badbots
port = http,https
logpath = /var/log/nginx/access.log
maxretry = 2
EOF

    # Create custom Nginx filters
    sudo tee /etc/fail2ban/filter.d/nginx-botsearch.conf > /dev/null <<EOF
[Definition]
failregex = ^<HOST> -.*"(GET|POST).*/(wp-admin|wp-login|xmlrpc|admin|phpmyadmin|mysql|sql|database).*" (404|403|500) .*$
ignoreregex =
EOF

    sudo tee /etc/fail2ban/filter.d/nginx-noscript.conf > /dev/null <<EOF
[Definition]
failregex = ^<HOST> -.*"(GET|POST).*(\.php|\.asp|\.exe|\.pl|\.cgi|\.scgi).*" (404|403|500) .*$
ignoreregex =
EOF

    sudo tee /etc/fail2ban/filter.d/nginx-noproxy.conf > /dev/null <<EOF
[Definition]
failregex = ^<HOST> -.*"(GET|POST) http.*" (404|403|500) .*$
ignoreregex =
EOF

    sudo tee /etc/fail2ban/filter.d/nginx-badbots.conf > /dev/null <<EOF
[Definition]
failregex = ^<HOST> -.*".*" (404|403|500) .* ".*(?:libwww-perl|wget|python|nikto|curl|scan|java|winhttp|clshttp|loader).*"$
ignoreregex = ^<HOST> -.*".*" (404|403|500) .* ".*(?:google|bing|yahoo|baidu).*"$
EOF

    # Start and enable Fail2ban
    echo "Starting and enabling Fail2ban service..."
    sudo systemctl start fail2ban
    sudo systemctl enable fail2ban

    # Configure UFW to work with Fail2ban
    if command -v ufw &> /dev/null; then
        echo "Configuring UFW to work with Fail2ban..."
        # UFW and Fail2ban integration is automatic, but ensure UFW is active
        sudo ufw --force enable
    fi
}

# Function to create basic Nginx configuration
create_basic_config() {
    echo "Creating basic Nginx configuration..."

    # Backup original config
    if [ -f /etc/nginx/nginx.conf ]; then
        sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
    fi

    # Create a basic server block
    sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
}
EOF

    # Create basic index page
    sudo mkdir -p /var/www/html
    sudo tee /var/www/html/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Nginx!</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 600px; margin: 0 auto; text-align: center; }
        h1 { color: #333; }
        .info { background: #f4f4f4; padding: 20px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Nginx!</h1>
        <p>If you can see this page, the web server is successfully installed and working.</p>
        <div class="info">
            <h3>Next Steps:</h3>
            <p>1. Configure your domain in /etc/nginx/sites-available/</p>
            <p>2. Set up SSL with: sudo certbot --nginx -d yourdomain.com</p>
            <p>3. Test configuration: sudo nginx -t</p>
            <p>4. Reload Nginx: sudo systemctl reload nginx</p>
        </div>
    </div>
</body>
</html>
EOF

    # Set proper permissions
    sudo chown -R www-data:www-data /var/www/html 2>/dev/null || sudo chown -R nginx:nginx /var/www/html 2>/dev/null || true
    sudo chmod -R 755 /var/www/html
}

# Step 2: Install Nginx based on OS
if [[ "$OS" == "Linux" ]]; then
    install_linux_nginx
    if [ $? -eq 0 ]; then
        create_basic_config
    fi
elif [[ "$OS" == "Darwin" ]]; then
    install_macos_nginx
fi

# Step 3: Verify installation
echo
echo "Verifying Nginx installation..."

if command -v nginx &> /dev/null; then
    echo "Nginx installed successfully!"
    echo "Nginx version: $(nginx -v 2>&1)"
else
    echo "Warning: nginx command not found"
    echo "Installation may have failed"
fi

# Check Certbot installation
if command -v certbot &> /dev/null; then
    echo "Certbot installed successfully!"
    echo "Certbot version: $(certbot --version 2>&1)"
else
    echo "Warning: certbot command not found"
fi

# Check Fail2ban installation
if command -v fail2ban-server &> /dev/null; then
    echo "Fail2ban installed successfully!"
    echo "Fail2ban version: $(fail2ban-server --version 2>&1)"
else
    echo "Warning: fail2ban-server command not found"
fi

# Test Nginx configuration
if [[ "$OS" == "Linux" ]]; then
    echo "Testing Nginx configuration..."
    if sudo nginx -t &> /dev/null; then
        echo "Nginx configuration test successful!"

        # Reload Nginx to apply new configuration
        sudo systemctl reload nginx
        echo "Nginx reloaded with new configuration."
    else
        echo "Warning: Nginx configuration test failed"
    fi
fi

# Step 4: Display usage information
echo
echo "Nginx installation with Let's Encrypt and Fail2ban complete!"
echo
echo "Getting started with Nginx:"
echo "1. Check Nginx status:"
echo "   > sudo systemctl status nginx"
echo
echo "2. Test configuration:"
echo "   > sudo nginx -t"
echo
echo "3. Reload configuration:"
echo "   > sudo systemctl reload nginx"
echo
echo "4. Restart Nginx:"
echo "   > sudo systemctl restart nginx"
echo
echo "SSL Certificate setup with Let's Encrypt:"
echo "1. Obtain SSL certificate for your domain:"
echo "   > sudo certbot --nginx -d yourdomain.com"
echo
echo "2. Test automatic renewal:"
echo "   > sudo certbot renew --dry-run"
echo
echo "3. List certificates:"
echo "   > sudo certbot certificates"
echo
echo "4. Renew certificates manually:"
echo "   > sudo certbot renew"
echo
echo "Fail2ban management:"
echo "1. Check Fail2ban status:"
echo "   > sudo fail2ban-client status"
echo
echo "2. Check specific jail status:"
echo "   > sudo fail2ban-client status nginx-http-auth"
echo
echo "3. Unban an IP address:"
echo "   > sudo fail2ban-client set nginx-http-auth unbanip <IP>"
echo
echo "4. Check banned IPs:"
echo "   > sudo fail2ban-client status nginx-http-auth"
echo
echo "5. Restart Fail2ban:"
echo "   > sudo systemctl restart fail2ban"
echo
echo "Configuration files:"
echo "- Main config: /etc/nginx/nginx.conf"
echo "- Site configs: /etc/nginx/sites-available/"
echo "- Enabled sites: /etc/nginx/sites-enabled/"
echo "- Web root: /var/www/html/"
echo "- Logs: /var/log/nginx/"
echo "- Fail2ban config: /etc/fail2ban/jail.local"
echo "- Fail2ban logs: /var/log/fail2ban.log"
echo
echo "Common Nginx commands:"
echo "- Check syntax: nginx -t"
echo "- Reload config: nginx -s reload"
echo "- Stop server: nginx -s stop"
echo "- Start server: nginx"
echo
echo "Security tips:"
echo "- Always test configuration before reloading"
echo "- Keep Nginx and system updated"
echo "- Use strong SSL configurations"
echo "- Monitor access and error logs regularly"
echo "- Fail2ban is protecting against brute force attacks"
echo "- Check Fail2ban logs for blocked attempts"
echo
echo "Your Nginx server with Fail2ban protection is now running!"
if [[ "$OS" == "Linux" ]]; then
    echo "Visit http://localhost or http://your-server-ip to see the welcome page."
fi
echo
echo "Resources:"
echo "- Nginx Documentation: https://nginx.org/en/docs/"
echo "- Let's Encrypt: https://letsencrypt.org/"
echo "- Certbot Documentation: https://certbot.eff.org/"