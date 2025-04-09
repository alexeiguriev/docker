#!/bin/bash

set -e

echo "Installing Helm..."

# Download the official Helm install script
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "✅ Helm installed successfully!"
helm version

