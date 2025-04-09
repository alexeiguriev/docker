#!/bin/bash

set -e

# Function to print a heading
print_heading() {
    echo
    echo "========== $1 =========="
}

# Update system and install dependencies
print_heading "Updating system and installing dependencies"
sudo apt-get update -y
sudo apt-get install -y curl apt-transport-https ca-certificates gnupg lsb-release

# Install kubectl
print_heading "Installing kubectl"
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    echo "kubectl installed."
else
    echo "kubectl already installed."
fi

# Install Minikube
print_heading "Installing Minikube"
if ! command -v minikube &> /dev/null; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
    echo "Minikube installed."
else
    echo "Minikube already installed."
fi

# Check if virtualization is supported
print_heading "Checking virtualization support"
if grep -E --color 'vmx|svm' /proc/cpuinfo > /dev/null; then
    echo "Virtualization is supported."
else
    echo "Warning: Virtualization is not supported on this system."
fi

# Check if current user is already in the docker group
if groups $USER | grep &>/dev/null '\bdocker\b'; then
    echo "✅ User '$USER' is already in the 'docker' group."
else
    echo "🔧 Adding user '$USER' to the 'docker' group..."
    sudo usermod -aG docker $USER
    echo "🔄 Applying group change to current session..."
    newgrp docker <<EONG
echo "✅ Docker group membership applied. You can now run docker without sudo."
docker run hello-world
EONG
fi

# Start Minikube
print_heading "Starting Minikube"
minikube start --driver=docker

# Verify installation
print_heading "Verifying Minikube installation"
minikube status

echo
echo "✅ Minikube installation and setup complete."

