#!/bin/bash

set -e

echo "🔧 Updating system and installing dependencies..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y curl wget apt-transport-https ca-certificates gnupg lsb-release conntrack

echo "🐳 Installing Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

echo "📦 Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

echo "🔧 Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install kubectl /usr/local/bin/kubectl
rm kubectl

echo "🚀 Starting Minikube (bare-metal mode)..."
sudo minikube start --driver=none --memory=1024 --cpus=1 --force

echo "✅ Verifying cluster status..."
kubectl get nodes

echo "⚠️ You may need to log out and back in to apply Docker group changes"

# chmod +x setup-minikube.sh
