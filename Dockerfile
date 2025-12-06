# Base image

ARG ISAAC_MAJOR=5
ARG ISAAC_MINOR=0
ARG ISAAC_PATCH=0
FROM nvcr.io/nvidia/isaac-sim:${ISAAC_MAJOR}.${ISAAC_MINOR}.${ISAAC_PATCH}

# Environment configuration
ENV DEBIAN_FRONTEND=noninteractive \
    ACCEPT_EULA=Y \
    PRIVACY_CONSENT=Y \
    LANG=en_GB.UTF-8 \
    LC_ALL=en_GB.UTF-8 \
    TZ=Europe/London \
    ROS_DISTRO=humble \
    ROS_VERSION=2 \
    ROS_PYTHON_VERSION=3 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=all

# Configure timezone to Europe/London
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# Configure locales
RUN apt-get update && \
    apt-get install -y --no-install-recommends locales && \
    locale-gen en_GB.UTF-8 && \
    update-locale LC_ALL=${LC_ALL} LANG=${LANG} && \
    rm -rf /var/lib/apt/lists/*

#####################################
# Installing and setting up ROS2
#####################################

# Setup ROS2 repository
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        curl \
        ca-certificates && \
    add-apt-repository universe && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/ros2.list && \
    rm -rf /var/lib/apt/lists/*

# Install ROS2 packages in a single layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends --allow-downgrades \
        libbrotli1=1.0.9-2build6 \
        ros-${ROS_DISTRO}-desktop \
        ros-${ROS_DISTRO}-ros-ign-bridge \
        ros-${ROS_DISTRO}-xacro && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    bash-completion \
    cmake \
    gdb \
    git \
    git-core \
    gnupg2 \
    bash-completion \
    openssh-client \
    file \
    tree \
    lsb-release \
    wget \
    less \
    udev \
    sudo \
    libpng-dev \
    libgomp1 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libmagic-mgc \
    libmagic1 \
    libxext6 \
    libxrender-dev \
    software-properties-common \
    tree \
    curl \
    vim \
    vim-gtk \
    xclip \
    zstd \
    && rm -rf /var/lib/apt/lists/*



# Set up volumes for caches and data
VOLUME ["/isaac-sim/kit/cache", "/root/.cache/ov", "/root/.cache/pip", "/root/.cache/nvidia/GLCache", "/root/.nv/ComputeCache", "/root/.nvidia-omniverse/logs", "/root/.local/share/ov/data", "/root/Documents"]

# ROS2 Environment Setup and sourcing
SHELL ["/bin/bash", "-c"]
RUN echo "" >> ~/.bashrc
RUN echo "## ROS2" >> ~/.bashrc
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
