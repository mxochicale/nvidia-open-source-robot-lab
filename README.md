# :robot:  nvidia-open-source-robot-lab
A repository with examples for running **NVIDIA Isaac Sim**, **Isaac Lab**, and **ROS** using containers. 🧪🧠🐳

![animation](docs/figs/ezgif-4fa230460975b3.gif)
Isaac Sim Full App: Windows > Examples > Robotics Example > Policy > Humanoid [LOAD]

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

* Inside the container run app
```bash
# Isaac Sim root directory
export ISAACSIM_PATH=.
# Isaac Sim python executable
export ISAACSIM_PYTHON_EXE="${ISAACSIM_PATH}/python.sh"

# note: you can pass the argument "--help" to see all arguments possible.
${ISAACSIM_PATH}/isaac-sim.sh --allow-root --help

# checks that python path is set correctly
${ISAACSIM_PYTHON_EXE} -c "print('Isaac Sim configuration is now complete.')"
# checks that Isaac Sim can be launched from python
${ISAACSIM_PYTHON_EXE} ${ISAACSIM_PATH}/standalone_examples/api/isaacsim.core.api/add_cubes.py
```
Wait until Isaac Sim is completely loaded (e.g., [186.291s] Isaac Sim Full App is loaded.) 
You can safely ignore the "not responding" message in Isaac Sim.  

* Installing isaaclab
```bash
cd ..
git clone https://github.com/isaac-sim/IsaacLab.git
# enter the cloned repository
cd IsaacLab
./isaaclab.sh --help
# create a symbolic link
ln -s ${ISAACSIM_PATH} _isaac_sim

##installing miniconda
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
source ~/miniconda3/bin/activate
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
conda init --all

# Option 1: Default environment name 'env_isaaclab'
./isaaclab.sh --conda  # or "./isaaclab.sh -c"

# Activate environment
conda activate env_isaaclab  # or "conda activate my_env"


# these dependency are needed by robomimic which is not available on Windows
sudo apt install cmake build-essential
./isaaclab.sh --install # or "./isaaclab.sh -i"

# Option 1: Using the isaaclab.sh executable
# note: this works for both the bundled python and the virtual environment
./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py

# Option 2: Using python in your virtual environment
python scripts/tutorials/00_sim/create_empty.py
```


## Links
* [References](docs/README.md#references)

## 📥 Clone repository
```bash
git clone git@github.com:mxochicale/nvidia-open-source-robot-lab.git
```
