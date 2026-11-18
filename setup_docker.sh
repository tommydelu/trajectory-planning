#!/bin/bash
echo "--- DOCKER INSTALLATION FOR THE PROJECT ---"

# Install Docker if not present
sudo apt update && sudo apt install -y docker.io

# Add the user to the docker group
sudo usermod -aG docker $USER

echo "----------------------------------------------------------"
echo "INSTALLATION COMPLETED!"
echo "IMPORTANT: To make the permissions effective, you must"
echo "RESTART the computer or LOGOUT/LOGIN."
echo "After doing so, you can use the build_image.sh script."
echo "----------------------------------------------------------"
