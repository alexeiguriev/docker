#!/bin/bash

# Update the system package index
echo "Updating system package index..."
sudo apt update

# Install the build-essential package, which includes GCC, G++, and other development tools
echo "Installing build-essential package (includes GCC)..."
sudo apt install -y build-essential

# Verify the installation of GCC
echo "Verifying GCC installation..."
gcc --version

# Check if GCC was installed successfully
if [ $? -eq 0 ]; then
  echo "GCC has been successfully installed!"
else
  echo "GCC installation failed!"
fi
