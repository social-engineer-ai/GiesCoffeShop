#!/bin/bash
# Gies Coffee Shop - Setup & Start Script
# Run this after cloning the repo on EC2

set -e
echo "=== Gies Coffee Shop Setup ==="

# Install MariaDB
echo "Installing MariaDB..."
sudo dnf install -y mariadb105-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Configure remote access
echo "Configuring MySQL remote access..."
sudo tee /etc/my.cnf.d/remote-access.cnf > /dev/null <<EOF
[mysqld]
bind-address = 0.0.0.0
EOF
sudo systemctl restart mariadb

# Load database
echo "Loading database..."
sudo mysql < setup.sql

# Install Python packages
echo "Installing Python packages..."
sudo dnf install -y python3-pip
pip3 install -r requirements.txt

# Start Streamlit
echo "Starting Streamlit..."
nohup $(which streamlit) run app.py \
    --server.port 8501 \
    --server.address 0.0.0.0 \
    --server.headless true \
    --browser.gatherUsageStats false \
    > ~/streamlit.log 2>&1 &

echo "=== Setup Complete ==="
echo "Web App: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8501"
