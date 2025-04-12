#!/bin/bash

# install-kubernetes-tools.sh

# Exit on any error
set -e

# Colors for output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print colored message
print_message() {
    echo -e "${BLUE}>>> $1${NC}"
}

# Print error message
print_error() {
    echo -e "${RED}>>> Error: $1${NC}"
}

# Print success message
print_success() {
    echo -e "${GREEN}>>> $1${NC}"
}

# Function to fix Docker permissions
fix_docker_permissions() {
    print_message "Fixing Docker permissions..."
    
    # Check if user is in docker group
    if ! groups $USER | grep -q "docker"; then
        print_message "Adding user to docker group..."
        sudo usermod -aG docker $USER
    else
        print_message "User already in docker group"
    fi

    # Set permissions for docker.sock
    print_message "Setting docker.sock permissions..."
    sudo chmod 666 /var/run/docker.sock

    # Restart docker service
    print_message "Restarting Docker service..."
    sudo systemctl restart docker

    # Wait for Docker to be ready
    print_message "Waiting for Docker to be ready..."
    sleep 5

    # Start new shell session with docker group
    print_message "Starting new shell session with docker group..."
    newgrp docker << EOF

    # Verify Docker works
    print_message "Verifying Docker installation..."
    if ! docker ps > /dev/null 2>&1; then
        print_error "Docker is not working properly"
        exit 1
    else
        print_success "Docker is working properly"
    fi

    # Start Minikube
    print_message "Starting Minikube..."
    minikube start --driver=docker --memory=2048 --cpus=2

EOF
}

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Please do not run as root or with sudo"
    exit 1
fi

# Update system
print_message "Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install required packages
print_message "Installing required packages..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    wget \
    software-properties-common

# Install Docker
print_message "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    # Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
else
    print_message "Docker is already installed"
fi

# Install kubectl
print_message "Installing kubectl..."
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
else
    print_message "kubectl is already installed"
fi

# Install Minikube
print_message "Installing Minikube..."
if ! command -v minikube &> /dev/null; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
else
    print_message "Minikube is already installed"
fi

# Install cri-dockerd
print_message "Installing cri-dockerd..."
if ! command -v cri-dockerd &> /dev/null; then
    # Get latest version
    VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g')
    wget https://github.com/Mirantis/cri-dockerd/releases/download/v${VER}/cri-dockerd-${VER}.amd64.tgz
    tar xvf cri-dockerd-${VER}.amd64.tgz
    sudo mv cri-dockerd/cri-dockerd /usr/local/bin/
    rm -rf cri-dockerd cri-dockerd-${VER}.amd64.tgz

    # Configure systemd service
    wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
    wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
    sudo mv cri-docker.socket cri-docker.service /etc/systemd/system/
    sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service

    # Start and enable services
    sudo systemctl daemon-reload
    sudo systemctl enable cri-docker.service
    sudo systemctl enable cri-docker.socket
    sudo systemctl start cri-docker.socket
    sudo systemctl start cri-docker.service
else
    print_message "cri-dockerd is already installed"
fi

# Install Helm
print_message "Installing Helm..."
if ! command -v helm &> /dev/null; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
    print_message "Helm is already installed"
fi

# Fix Docker permissions and start Minikube
fix_docker_permissions

# Print versions
print_message "Installed versions:"
docker --version
kubectl version --client
minikube version
helm version

# Add Helm repositories (optional)
print_message "Would you like to add some common Helm repositories? (y/n)"
read -r add_repos

if [[ "$add_repos" =~ ^[Yy]$ ]]; then
    print_message "Adding common Helm repositories..."
    helm repo add stable https://charts.helm.sh/stable
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo add jetstack https://charts.jetstack.io
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    
    print_success "Helm repositories added successfully!"
    print_message "You can list repositories with: helm repo list"
fi

print_success "Installation complete!"
print_message "You can verify the installation by running:"
echo -e "${GREEN}docker ps${NC}"
echo -e "${GREEN}minikube status${NC}"
echo -e "${GREEN}kubectl get nodes${NC}"
echo -e "${GREEN}helm list${NC}"