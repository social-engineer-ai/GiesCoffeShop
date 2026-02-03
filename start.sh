#!/bin/bash
# Gies Coffee Shop - Setup & Start Script
set -ex

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

# Install Python packages system-wide
echo "Installing Python packages..."
sudo dnf install -y python3-pip
sudo pip3 install streamlit pymysql pandas

# Verify installation
echo "Verifying streamlit installation..."
which streamlit
streamlit --version

# Start Streamlit
echo "Starting Streamlit..."
cd /home/ec2-user/GiesCoffeShop
nohup streamlit run app.py \
    --server.port 8501 \
    --server.address 0.0.0.0 \
    --server.headless true \
    --browser.gatherUsageStats false \
    > /home/ec2-user/streamlit.log 2>&1 &

sleep 2
echo "Streamlit PID: $(pgrep -f streamlit)"
echo "=== Setup Complete ==="
echo "Web App: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8501"
