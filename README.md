# ACAP-Axis-Camera-People_counter
This project is a C++ application designed for Axis cameras using the ACAP Native SDK. The goal is to count people in a scene while handling variations in movement and orientation.

# 🎯 ACAP-Axis-Camera-People-Counter

This project is a **C++ application** designed for **Axis cameras** using the **ACAP Native SDK**.  
The goal is to **count people** in a scene while handling variations in movement and orientation.

---

## 🚀 Features

- ✅ Developed in **C++**
- ✅ Uses **OpenCV** for image processing
- ✅ Designed for **Axis ARTPEC-8 cameras, aarch64**
- ✅ Packaged as an **.eap application**

---
## 📁 Project Structure

```bash
Counter1/
│── app/
│   ├── people_counter.cpp  # Main C++ application
│   ├── Makefile            # Build instructions
│   ├── manifest.json       # ACAP execution configuration
│── Dockerfile              # Container build instructions
│── README.md               # Documentation
│── build/                  # Output folder for the .eap package
│── assets/                 # Additional assets if needed
```
---


## ⚙️ Installation & Build Instructions

### 📌 Prerequisites

- 🐳 **Docker** installed on your development machine  
- 🎯 **Axis ACAP Native SDK** set up  
- 📷 A compatible **Axis camera** (**ARTPEC-8**)  

---

### Set up for ACAP Native SDK
1- Open Visual Studio Code and install the Dev Containers extension.

2- Create a subfolder called .devcontainer in the top directory of the source code project you're working on.

3- In .devcontainer, create devcontainer.json with the following content:
```sh
{
    "name": "ACAP Native (aarch64)",
    "build": {
        "dockerfile": "Dockerfile",
        "args": {
            "ARCH": "aarch64"
        }
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-vscode.cpptools-extension-pack",
                "ms-vscode.makefile-tools",
                "ms-azuretools.vscode-docker"
            ]
        }
    }
}
```
You might need to replace aarch64 with armv7hf as it depends on the device your application targets. 
4- In .devcontainer, create Dockerfile with the following content:
```sh
ARG ARCH
ARG VERSION=latest
ARG UBUNTU_VERSION=22.04
ARG REPO=axisecp
ARG SDK=acap-native-sdk

FROM ${REPO}/${SDK}:${VERSION}-${ARCH}-ubuntu${UBUNTU_VERSION}

RUN apt-get update
RUN apt install cppcheck -y
```

5-Create a new subfolder called .vscode in the top directory of the source code project you're working on.

6- In .vscode, create c_cpp_properties.json file with the following content:
```sh
{
    "configurations": [
        {
            "name": "Linux",
            "includePath": [
                "${workspaceFolder}/**",
                "${SDKTARGETSYSROOT}/**"
            ]
        }
    ],
    "version": 4
}
```
7- In Visual Studio Code, click View > Command Palette... and type Dev Containers: Reopen in Container. This restarts Visual Studio Code, builds the container if it doesn't exist, and then opens the source code in the container. This might take some time the first time you do it.

---
### You can also build docker image by following the next step: 

### 🔧 Steps to Build & Deploy

#### 🏗️ **Build the Docker image**  

```sh
docker build --tag people-counter .
```

#### For aarch64 architecture, use:
```sh
docker build --tag people-counter --build-arg ARCH=aarch64 .
```

#### 📦 Extract the .eap package

```sh
docker cp $(docker create people-counter):/opt/app ./build
```

#### ⬆️ Upload the .eap package
#### Upload the .eap file from the build/ folder to your Axis camera via ACAP.

#### ▶️ Start the application on the camera

#### To monitor logs, run:
```sh
ssh root@<camera-ip>
journalctl -f
```

#### 🎯 Enjoy real-time people counting with your Axis camera!
#### Feel free to contribute or report issues in the repository. 🚀
