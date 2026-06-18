#!/bin/bash

# This script sets up a Jenkins server in a Docker container on an Ubuntu system.
set -e

echo "===== Updating System ====="
sudo apt update -y
sudo apt upgrade -y

echo "===== Installing Docker ====="
sudo apt install -y docker.io

echo "===== Starting Docker ====="
sudo systemctl enable docker
sudo systemctl start docker

echo "===== Verifying Docker ====="
sudo docker --version

echo "===== Creating Jenkins Volume ====="
sudo docker volume create jenkins_home

echo "===== Removing Existing Jenkins Container (if any) ====="
sudo docker rm -f jenkins 2>/dev/null || true

echo "===== Running Jenkins Container ====="
sudo docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts-jdk21

echo "===== Waiting for Jenkins to Start ====="
sleep 60

echo "===== Jenkins Container Status ====="
sudo docker ps

echo "===== Jenkins Initial Admin Password ====="
sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

echo ""
echo "===== Jenkins Installation Complete ====="
echo "Access Jenkins at:"
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "http://$PUBLIC_IP:8080"