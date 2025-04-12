#!/bin/bash

set -e

echo "🔧 Updating system and installing dependencies..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y curl wget apt-transport-https ca-certificates gnupg lsb-release conntrack socat

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

echo "🔧 Installing crictl (required for Kubernetes)..."
CRICTL_VERSION="v1.28.0"
curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz
sudo tar -C /usr/local/bin -xzf crictl-${CRICTL_VERSION}-linux-amd64.tar.gz
rm crictl-${CRICTL_VERSION}-linux-amd64.tar.gz

# # Ensure proper permissions for the Docker group
# echo "⚙️ Ensuring Docker group permissions..."
# newgrp docker <<EONG

# echo "🧠 Checking system memory..."
# TOTAL_MEM=$(free -m | awk '/^Mem:/{print $2}')
# if [ "$TOTAL_MEM" -lt 1900 ]; then
#   echo "⚠️  Available memory (${TOTAL_MEM}MB) is less than the recommended 1900MB."
#   echo "⚙️  Starting minikube with available memory and --force..."
#   sudo minikube start --driver=none --memory=${TOTAL_MEM}mb --force
# else
#   echo "🚀 Starting Minikube (bare-metal mode)..."
#   sudo minikube start --driver=none --memory=1900mb
# fi

# EONG

# echo "✅ Verifying cluster status..."
# kubectl get nodes

# echo "⚠️  You may need to log out and back in to apply Docker group changes"
