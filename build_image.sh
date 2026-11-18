#!/bin/bash
echo "Building the ROS2 + CoppeliaSim image..."

# The build command
docker build -t ros2-coppelia-img .

if [ $? -eq 0 ]; then
    echo "Image created successfully! Now you can run ./run_sim.sh"
else
    echo "ERROR during the build. Did you restart after installation?"
fi
