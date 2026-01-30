# :robot:  nvidia-open-source-robot-lab
A repository with examples for running **NVIDIA Isaac Sim**, **Isaac Lab**, and **ROS** using containers. 🧪🧠🐳

| Humanoid Policy Demo | Franka Lift Cube (RL Training) |
|----------------------|--------------------------------|
| ![Humanoid Animation](docs/figs/ezgif-4fa230460975b3.gif) | ![Franka Animation](docs/figs/ezgif-Isaac-Lift-Cube-Franka-v0.gif) |
| **Isaac Sim Full App**  <br>Windows → Examples → Robotics Example → Policy → Humanoid **[LOAD]** | **Training Command**  <br>`./isaaclab.sh -p scripts/reinforcement_learning/rsl_rl/train.py --task=Isaac-Lift-Cube-Franka-v0` |


## 🛠️ Requirements
- 🐧 Ubuntu > [:link:](https://github.com/mxochicale/tools/tree/main/ubuntu)
- 🐋 Docker > [:link:](https://github.com/mxochicale/code/tree/main/docker)
- 🎮 NVIDIA Drivers and Container Toolkit > [:link:](https://github.com/mxochicale/code/tree/main/gpu/installation)

## 🏗️ Build and run with bash scripts

🐳 **Build and Run Docker image**
```bash
bash isaac-docker.sh --version 5.1.0 --ros-distro Humble build
bash isaac-docker.sh --version 5.1.0 --ros-distro Humble run
docker system prune -f --volumes
```
* sample output for docker images
```bash
REPOSITORY       TAG            IMAGE ID       CREATED             SIZE
isaac_sim_ros2   5.0.0-Humble   a74b6685718f   About an hour ago   19.1GB
```

## 🐳 Running Pre-Built Isaac Lab Container 
Instructions to run pre-built isaac lab with container registry [ref](https://isaac-sim.github.io/IsaacLab/main/source/deployment/docker.html). See official tag releases of [isaac-lab](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/isaac-lab/tags?version=2.3.1)

```bash
docker pull nvcr.io/nvidia/isaac-lab:2.3.1
```
* sample output for docker images
```bash
REPOSITORY                 TAG       IMAGE ID       CREATED       SIZE
nvcr.io/nvidia/isaac-lab   2.3.1     0fbc8026bae6   8 weeks ago   17.5GB
```

* Run isaac lab with some examples
```
#To enable rendering through X11 forwarding, run:
xhost +
docker run --name isaac-lab --entrypoint bash -it --gpus all -e "ACCEPT_EULA=Y" --rm --network=host \
   -e "PRIVACY_CONSENT=Y" \
   -e DISPLAY \
   -v $HOME/.Xauthority:/root/.Xauthority \
   -v ~/docker/isaac-sim/cache/kit:/isaac-sim/kit/cache:rw \
   -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
   -v ~/docker/isaac-sim/cache/pip:/root/.cache/pip:rw \
   -v ~/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw \
   -v ~/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw \
   -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
   -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
   -v ~/docker/isaac-sim/documents:/root/Documents:rw \
   nvcr.io/nvidia/isaac-lab:2.3.1
#To run an example within the container, run:
./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py
./isaaclab.sh -p scripts/reinforcement_learning/rsl_rl/train.py --task=Isaac-Ant-v0 --headless
./isaaclab.sh -p scripts/reinforcement_learning/rsl_rl/train.py --task=Isaac-Humanoid-v0
./isaaclab.sh -p scripts/reinforcement_learning/rsl_rl/train.py --task=Isaac-Lift-Cube-Franka-v0
#See other Environment IDs > https://isaac-sim.github.io/IsaacLab/main/source/overview/environments.html
```

## Links
* [References](docs/README.md#references)

## 📥 Clone repository
```bash
git clone git@github.com:mxochicale/nvidia-open-source-robot-lab.git
```
