#!/bin/bash
# EC2 User Data - Clone repo and run setup
exec > /var/log/gies-setup.log 2>&1
set -x

dnf install -y git
cd /home/ec2-user
git clone https://github.com/social-engineer-ai/GiesCoffeShop.git
cd GiesCoffeShop
chmod +x start.sh
./start.sh

echo "SETUP_COMPLETE" > /home/ec2-user/setup_complete.txt
