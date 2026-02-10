#!/bin/bash

# Isaac Sim Docker Manager
# Script to build and run Isaac Sim with ROS2 support and Isaac Lab

# Default values
ISAAC_VERSION="5.1.0"
ROS_DISTRO="Humble"
IMAGE_NAME="isaac_sim_ros2"
FULL_TAG="${IMAGE_NAME}:${ISAAC_VERSION}-${ROS_DISTRO}"
BUILD_CONTEXT="."

# Isaac Lab specific
ISAAC_LAB_VERSION="2.3.1"
ISAAC_LAB_IMAGE="nvcr.io/nvidia/isaac-lab:${ISAAC_LAB_VERSION}"

# Volume paths (customize these as needed)
DOCKER_BASE_PATH="$HOME/docker/isaac-sim"
CACHE_KIT="${DOCKER_BASE_PATH}/cache/kit"
CACHE_OV="${DOCKER_BASE_PATH}/cache/ov"
CACHE_PIP="${DOCKER_BASE_PATH}/cache/pip"
CACHE_GLCACHE="${DOCKER_BASE_PATH}/cache/glcache"
CACHE_COMPUTECACHE="${DOCKER_BASE_PATH}/cache/computecache"
LOGS_PATH="${DOCKER_BASE_PATH}/logs"
DATA_PATH="${DOCKER_BASE_PATH}/data"
DOCUMENTS_PATH="${DOCKER_BASE_PATH}/documents"

# Create directory structure
create_directories() {
    echo "Creating directory structure..."
    mkdir -p "$CACHE_KIT"
    mkdir -p "$CACHE_OV"
    mkdir -p "$CACHE_PIP"
    mkdir -p "$CACHE_GLCACHE"
    mkdir -p "$CACHE_COMPUTECACHE"
    mkdir -p "$LOGS_PATH"
    mkdir -p "$DATA_PATH"
    mkdir -p "$DOCUMENTS_PATH"
    echo "Directories created successfully."
}

# Pull Isaac Lab Docker image
pull_isaac_lab() {
    echo "Pulling Isaac Lab image: ${ISAAC_LAB_IMAGE}"
    
    docker pull "$ISAAC_LAB_IMAGE"
    
    if [ $? -eq 0 ]; then
        echo "✅ Isaac Lab image pulled successfully: ${ISAAC_LAB_IMAGE}"
    else
        echo "❌ Failed to pull Isaac Lab image"
        exit 1
    fi
}

# Launch Isaac Lab container
launch_isaac_lab() {
    echo "Launching Isaac Lab container..."
    
    # Enable X11 display
    xhost + > /dev/null 2>&1
    
    # Run the container
    docker run --name isaac-lab \
        --entrypoint bash \
        -it \
        --gpus all \
        -e "ACCEPT_EULA=Y" \
        -e "PRIVACY_CONSENT=Y" \
        --rm \
        --network=host \
        -e DISPLAY \
        -v "$HOME/.Xauthority:/root/.Xauthority:rw" \
        -v "${CACHE_KIT}:/isaac-sim/kit/cache:rw" \
        -v "${CACHE_OV}:/root/.cache/ov:rw" \
        -v "${CACHE_PIP}:/root/.cache/pip:rw" \
        -v "${CACHE_GLCACHE}:/root/.cache/nvidia/GLCache:rw" \
        -v "${CACHE_COMPUTECACHE}:/root/.nv/ComputeCache:rw" \
        -v "${LOGS_PATH}:/root/.nvidia-omniverse/logs:rw" \
        -v "${DATA_PATH}:/root/.local/share/ov/data:rw" \
        -v "${DOCUMENTS_PATH}:/root/Documents:rw" \
        "$ISAAC_LAB_IMAGE"
}

# Build the Docker image
build_image() {
    echo "Building Docker image: ${FULL_TAG}"
    echo "Build context: ${BUILD_CONTEXT}"
    
    docker build -t "$FULL_TAG" "$BUILD_CONTEXT"
    
    if [ $? -eq 0 ]; then
        echo "✅ Docker image built successfully: ${FULL_TAG}"
    else
        echo "❌ Docker build failed"
        exit 1
    fi
}

# Run the Docker container
run_container() {
    echo "Running Isaac Sim with ROS2 ${ROS_DISTRO}"
    
    # Enable X11 display
    xhost + > /dev/null 2>&1
    
    # Run the container
    docker run --name isaac-sim \
        --entrypoint bash \
        -it \
        --runtime=nvidia \
        --gpus all \
        -e "ACCEPT_EULA=Y" \
        -e "PRIVACY_CONSENT=Y" \
        --rm \
        --network=host \
        -e DISPLAY \
        -v "$HOME/.Xauthority:/root/.Xauthority:rw" \
        -v "${CACHE_KIT}:/isaac-sim/kit/cache:rw" \
        -v "${CACHE_OV}:/root/.cache/ov:rw" \
        -v "${CACHE_PIP}:/root/.cache/pip:rw" \
        -v "${CACHE_GLCACHE}:/root/.cache/nvidia/GLCache:rw" \
        -v "${CACHE_COMPUTECACHE}:/root/.nv/ComputeCache:rw" \
        -v "${LOGS_PATH}:/root/.nvidia-omniverse/logs:rw" \
        -v "${DATA_PATH}:/root/.local/share/ov/data:rw" \
        -v "${DOCUMENTS_PATH}:/root/Documents:rw" \
        "$FULL_TAG"
}

# Run Isaac Sim application directly (alternative to bash entrypoint)
run_isaac_app() {
    echo "Running Isaac Sim application directly..."
    
    # Enable X11 display
    xhost + > /dev/null 2>&1
    
    # Run with default Isaac Sim entrypoint
    docker run --name isaac-sim \
        -it \
        --runtime=nvidia \
        --gpus all \
        -e "ACCEPT_EULA=Y" \
        -e "PRIVACY_CONSENT=Y" \
        --rm \
        --network=host \
        -e DISPLAY \
        -v "$HOME/.Xauthority:/root/.Xauthority:rw" \
        -v "${CACHE_KIT}:/isaac-sim/kit/cache:rw" \
        -v "${CACHE_OV}:/root/.cache/ov:rw" \
        -v "${CACHE_PIP}:/root/.cache/pip:rw" \
        -v "${CACHE_GLCACHE}:/root/.cache/nvidia/GLCache:rw" \
        -v "${CACHE_COMPUTECACHE}:/root/.nv/ComputeCache:rw" \
        -v "${LOGS_PATH}:/root/.nvidia-omniverse/logs:rw" \
        -v "${DATA_PATH}:/root/.local/share/ov/data:rw" \
        -v "${DOCUMENTS_PATH}:/root/Documents:rw" \
        "$FULL_TAG"
}

# Clean up containers
clean_containers() {
    echo "Cleaning up containers..."
    docker ps -a | grep -E '(isaac-sim|isaac-lab)' | awk '{print $1}' | xargs -r docker rm -f
    echo "Containers cleaned up."
}

# Clean up images
clean_images() {
    echo "Cleaning up images..."
    docker images | grep -E "(${IMAGE_NAME}|isaac-lab)" | awk '{print $3}' | xargs -r docker rmi -f
    echo "Images cleaned up."
}

# List available images
list_images() {
    echo "Available Isaac Sim images:"
    docker images | grep -E "(${IMAGE_NAME}|isaac-lab)"
}

# Show usage information
usage() {
    cat << EOF
Isaac Sim Docker Manager

Usage: $0 [OPTION] [COMMAND]

Options:
  -v, --version VERSION        Set Isaac Sim version (default: ${ISAAC_VERSION})
  -r, --ros-distro DISTRO      Set ROS2 distribution (default: ${ROS_DISTRO})
  -i, --image NAME             Set image name (default: ${IMAGE_NAME})
  -c, --context PATH           Set Docker build context path (default: current directory)
  -lv, --lab-version VERSION   Set Isaac Lab version (default: ${ISAAC_LAB_VERSION})
  -li, --lab-image IMAGE       Set Isaac Lab full image name (overrides lab-version)

Commands:
  build                    Build the Docker image
  run                      Run the container with bash entrypoint
  app                      Run the container with default Isaac Sim entrypoint
  setup                    Create directory structure for volumes
  pull-lab                 Pull Isaac Lab Docker image
  launch-lab               Launch Isaac Lab container
  clean-containers         Remove all Isaac Sim/Lab containers
  clean-images             Remove all Isaac Sim/Lab images
  list                     List available Isaac Sim/Lab images
  help                     Show this help message

Examples:
  $0 build
  $0 run
  $0 --version 5.1.0 --ros-distro Humble run
  $0 setup
  $0 --lab-version 2.2.0 pull-lab
  $0 --lab-image nvcr.io/nvidia/isaac-lab:2.2.0 pull-lab
  $0 launch-lab
  $0 clean-containers
  $0 clean-images

EOF
}

# Parse command line arguments
PARAMS=""
while (( "$#" )); do
    case "$1" in
        build|run|app|setup|pull-lab|launch-lab|clean-containers|clean-images|list|help)
            COMMAND="$1"
            shift
            ;;
        -v|--version)
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                ISAAC_VERSION="$2"
                shift 2
            else
                echo "Error: Argument for $1 is missing" >&2
                exit 1
            fi
            ;;
        -r|--ros-distro)
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                ROS_DISTRO="$2"
                shift 2
            else
                echo "Error: Argument for $1 is missing" >&2
                exit 1
            fi
            ;;
        -i|--image)
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                IMAGE_NAME="$2"
                shift 2
            else
                echo "Error: Argument for $1 is missing" >&2
                exit 1
            fi
            ;;
        -c|--context)
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                BUILD_CONTEXT="$2"
                shift 2
            else
                echo "Error: Argument for $1 is missing" >&2
                exit 1
            fi
            ;;
        -lv|--lab-version)
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                ISAAC_LAB_VERSION="$2"
                # Update the image with new version
                ISAAC_LAB_IMAGE="nvcr.io/nvidia/isaac-lab:${ISAAC_LAB_VERSION}"
                shift 2
            else
                echo "Error: Argument for $1 is missing" >&2
                exit 1
            fi
            ;;
        -li|--lab-image)
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                ISAAC_LAB_IMAGE="$2"
                # Extract version from image name if possible
                if [[ "$2" =~ :([0-9]+\.[0-9]+\.[0-9]+) ]]; then
                    ISAAC_LAB_VERSION="${BASH_REMATCH[1]}"
                fi
                shift 2
            else
                echo "Error: Argument for $1 is missing" >&2
                exit 1
            fi
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*|--*=)
            echo "Error: Unsupported flag $1" >&2
            usage
            exit 1
            ;;
        *)
            PARAMS="$PARAMS $1"
            shift
            ;;
    esac
done

# Update full tag with potentially new values
FULL_TAG="${IMAGE_NAME}:${ISAAC_VERSION}-${ROS_DISTRO}"

# Execute command
case "${COMMAND}" in
    build)
        build_image
        ;;
    run)
        create_directories
        run_container
        ;;
    app)
        create_directories
        run_isaac_app
        ;;
    setup)
        create_directories
        ;;
    pull-lab)
        pull_isaac_lab
        ;;
    launch-lab)
        create_directories
        launch_isaac_lab
        ;;
    clean-containers)
        clean_containers
        ;;
    clean-images)
        clean_images
        ;;
    list)
        list_images
        ;;
    help)
        usage
        ;;
    *)
        echo "Error: No command specified"
        usage
        exit 1
        ;;
esac