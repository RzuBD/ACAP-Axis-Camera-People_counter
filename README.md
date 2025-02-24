# ACAP-Axis-Camera-People_counter
This project is a C++ application designed for Axis cameras using the ACAP Native SDK. The goal is to count people in a scene while handling variations in movement and orientation.

# 🎯 ACAP-Axis-Camera-People-Counter

This project is a **C++ application** designed for **Axis cameras** using the **ACAP Native SDK**.  
The goal is to **count people** in a scene while handling variations in movement and orientation.

---

## 🚀 Features

- ✅ Developed in **C++**
- ✅ Uses **OpenCV** for image processing
- ✅ Designed for **Axis ARTPEC-8 cameras**
- ✅ Packaged as an **.eap application**

---

## 📁 Project Structure


Counter1/
│── app/
│   ├── people_counter.cpp  # Main C++ application
│   ├── Makefile            # Build instructions
│   ├── manifest.json       # ACAP execution configuration
│── Dockerfile              # Container build instructions
│── README.md               # Documentation
│── build/                  # Output folder for the .eap package
│── assets/                 # Additional assets if needed
building-opencv


---

## ⚙️ Installation & Build Instructions

### 📌 Prerequisites

- 🐳 **Docker** installed on your development machine  
- 🎯 **Axis ACAP Native SDK** set up  
- 📷 A compatible **Axis camera** (**ARTPEC-8**)  

---

### 🔧 Steps to Build & Deploy

#### 🏗️ **Build the Docker image**  

```sh
docker build --tag people-counter .

#For aarch64 architecture, use:

docker build --tag people-counter --build-arg ARCH=aarch64 .
# 📦 Extract the .eap package
---

docker cp $(docker create people-counter):/opt/app ./build

# ⬆️ Upload the .eap package

# Upload the .eap file from the build/ folder to your Axis camera via the web interface or API.

# ▶️ Start the application on the camera

#To monitor logs, run:

ssh root@<camera-ip>
journalctl -f

```
🎯 Enjoy real-time people counting with your Axis camera!
Feel free to contribute or report issues in the repository. 🚀
