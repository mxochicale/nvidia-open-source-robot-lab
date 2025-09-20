# :robot:  nvidia-open-source-robot-lab
A repository with examples for running **NVIDIA Isaac Sim**, **Isaac Lab**, and **ROS** using containers. 🧪🧠🐳

![animation](docs/figs/ezgif-4fa230460975b3.gif)
Isaac Sim Full App: Windows > Examples > Robotics Example > Policy > Humanoid [LOAD]

## 🛠️ Requirements
- 🐧 Ubuntu
- 🐋 Docker > https://github.com/mxochicale/code/tree/main/docker  
- 🎮 NVIDIA Drivers & Container Toolkit > https://github.com/mxochicale/code/tree/main/gpu/installation

## 🏗️ Build and run with bash scripts

🔧 **Build Docker image**
```bash
bash build.bash
```

## 🐳 Run Docker and Isaac Sim inside the container
* Run docker
```bash
bash run.bash
```

* Inside the container run app
```bash
bash runapp.sh
```
Wait until Isaac Sim is completely loaded (e.g., [186.291s] Isaac Sim Full App is loaded.) 
You can safely ignore the "not responding" message in Isaac Sim.  


## Links
* [References](docs/README.md#references)

## 📥 Clone repository
```bash
git clone git@github.com:mxochicale/nvidia-open-source-robot-lab.git
```
