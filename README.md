# Gies Coffee Shop Demo

EC2 Demo for BADM 558/358 - MySQL Database + Streamlit Web Application

## Quick Start (EC2 User Data)

Use this in EC2 User Data when launching:

```bash
#!/bin/bash
dnf install -y git
cd /home/ec2-user
git clone https://github.com/akumar261089/gies-coffee-shop.git
cd gies-coffee-shop
chmod +x start.sh
./start.sh
```

## Security Group Ports

| Port | Purpose |
|------|---------|
| 22   | SSH     |
| 8501 | Streamlit |
| 3306 | MySQL   |

## Database Credentials

| User | Password | Access |
|------|----------|--------|
| admin | GiesCoffee2026! | Full |
| student | coffee123 | Read + INSERT |

## Student Connect Command

```bash
sudo dnf install -y mariadb105
mysql -h <EC2_PUBLIC_IP> -u student -p'coffee123' gies_coffee_shop
```
