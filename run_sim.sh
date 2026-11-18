#!/bin/bash

# 1. Allow Docker to access the screen (X11)
xhost +local:docker > /dev/null

# 2. Name of the image we built
IMAGE_NAME="ros2-coppelia-img"

# 3. Start the container with the correct parameters
docker run -it --rm \
    --name ros2_coppelia_container \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$(pwd):/ros2_ws" \
    --network host \
    --ipc=host \
    --privileged \
    $IMAGE_NAME
    
# If you have an NVIDIA GPU and have installed the NVIDIA Container Toolkit, add this line inside the script before $IMAGE_NAME:
# --gpus all \
