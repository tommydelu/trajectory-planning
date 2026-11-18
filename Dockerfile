# Usa l'immagine ufficiale ROS2 Humble Desktop
FROM --platform=linux/amd64 osrf/ros:humble-desktop-full

# Evita prompt interattivi durante l'installazione
ENV DEBIAN_FRONTEND=noninteractive

# 1. Installa dipendenze di sistema (Aggiunti git, xsltproc e lxml necessari per la build del plugin)
RUN apt-get update && apt-get install -y \
    wget \
    git \
    python3-lxml \
    xsltproc \
    libglib2.0-0 \
    libgl1-mesa-glx \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxkbcommon-x11-0 \
    libdbus-1-3 \
    python3-pip && \
    pip3 install pyzmq cbor2 \
    && rm -rf /var/lib/apt/lists/*

# 2. Scarica e installa CoppeliaSim
ADD CoppeliaSim_Edu_V4_10_0_rev0_Ubuntu22_04.tar.xz /opt/

# 3. Imposta variabili d'ambiente necessarie
ENV COPPELIASIM_ROOT_DIR=/opt/CoppeliaSim_Edu_V4_10_0_rev0_Ubuntu22_04
ENV PATH="/opt/CoppeliaSim_Edu_V4_10_0_rev0_Ubuntu22_04:${PATH}"

# 4. COMPILAZIONE DEL PLUGIN ROS2 IN UN WORKSPACE TEMPORANEO
WORKDIR /tmp/plugin_ws/src
RUN git clone https://github.com/CoppeliaRobotics/simROS2.git --depth 1

RUN grep -q "sensor_msgs/msg/JointState" simROS2/meta/interfaces.txt || \
    echo "sensor_msgs/msg/JointState" >> simROS2/meta/interfaces.txt

RUN grep -q "sensor_msgs/msg/RegionOfInterest" simROS2/meta/interfaces.txt || \
    echo "sensor_msgs/msg/RegionOfInterest" >> simROS2/meta/interfaces.txt

RUN grep -q "sensor_msgs/msg/CameraInfo" simROS2/meta/interfaces.txt || \
    echo "sensor_msgs/msg/CameraInfo" >> simROS2/meta/interfaces.txt

# Compiliamo il plugin (colcon troverà in automatico il pacchetto sim_ros2)
WORKDIR /tmp/plugin_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"

# Copiamo il plugin. Nota il percorso corretto: build/sim_ros2_interface/
RUN cp build/sim_ros2_interface/libsimROS2.so $COPPELIASIM_ROOT_DIR/ && \
    rm -rf /tmp/plugin_ws

# 5. Configurazione finale del workspace degli studenti
WORKDIR /ros2_ws
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

# Carica automaticamente l'ambiente ROS2 in ogni nuovo terminale
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

RUN apt-get update && apt-get install -y ros-humble-rmw-cyclonedds-cpp
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV CYCLONEDDS_URI=file:///ros2_ws/cyclonedds.xml
RUN rm -f $COPPELIASIM_ROOT_DIR/libsimMujoco.so
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
