ARG ARCH=aarch64
ARG VERSION=latest
ARG UBUNTU_VERSION=22.04
ARG REPO=axisecp
ARG SDK=acap-native-sdk

FROM ${REPO}/${SDK}:${VERSION}-${ARCH}-ubuntu${UBUNTU_VERSION}

# Set general arguments
ARG ARCH
ARG SDK_LIB_PATH_BASE=/opt/axis/acapsdk/sysroots/${ARCH}/usr
ARG BUILD_DIR=/opt/build

# Install build dependencies for cross-compiling OpenCV and Crow
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    build-essential \
    git \
    libasio-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#-------------------------------------------------------------------------------
# Build OpenCV libraries
#-------------------------------------------------------------------------------

ARG OPENCV_VERSION=4.10.0
ARG OPENCV_DIR=${BUILD_DIR}/opencv
ARG OPENCV_SRC_DIR=${OPENCV_DIR}/opencv-${OPENCV_VERSION}
ARG OPENCV_BUILD_DIR=${OPENCV_DIR}/build

WORKDIR ${OPENCV_DIR}
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://github.com/opencv/opencv/archive/$OPENCV_VERSION.tar.gz | tar -xz

WORKDIR ${OPENCV_BUILD_DIR}
ENV COMMON_CMAKE_FLAGS="-S $OPENCV_SRC_DIR \
        -B $OPENCV_BUILD_DIR \
        -D CMAKE_INSTALL_PREFIX=$SDK_LIB_PATH_BASE \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D WITH_OPENEXR=OFF \
        -D WITH_GTK=OFF \
        -D WITH_V4L=OFF \
        -D WITH_FFMPEG=OFF \
        -D WITH_GSTREAMER=OFF \
        -D BUILD_LIST=core,imgproc,video \
        -D OPENCV_GENERATE_PKGCONFIG=ON "

RUN . /opt/axis/acapsdk/environment-setup* && \
    cmake $COMMON_CMAKE_FLAGS && \
    make -j"$(nproc)" install

#-------------------------------------------------------------------------------
# Install Crow framework
#-------------------------------------------------------------------------------

# RUN git clone --single-branch --branch master https://github.com/CrowCpp/Crow.git /opt/crow
# WORKDIR /opt/crow
# RUN . /opt/axis/acapsdk/environment-setup* && \
#     git submodule update --init --recursive && \
#     cmake . && \
#     make -j"$(nproc)" install

#-------------------------------------------------------------------------------
# Copy the built OpenCV library files to the application directory
#-------------------------------------------------------------------------------

WORKDIR /opt/app
COPY ./app .
RUN mkdir lib && cp -P ${OPENCV_BUILD_DIR}/lib/lib*.so* ./lib/

#-------------------------------------------------------------------------------
# Build the people counter application
#-------------------------------------------------------------------------------

COPY app/counter_people.cpp .
RUN . /opt/axis/acapsdk/environment-setup* && \
    g++ counter_people.cpp -o counter_people \
    -I/usr/include/opencv4 \
    -L/usr/lib/aarch64-linux-gnu \
    -lopencv_core -lopencv_imgproc -lopencv_videoio -lopencv_objdetect

#-------------------------------------------------------------------------------
# Package the ACAP application
#-------------------------------------------------------------------------------

RUN . /opt/axis/acapsdk/environment-setup* && acap-build .
