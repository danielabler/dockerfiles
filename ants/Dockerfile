# Dockerfile for GlimS based on dolfinadjoint/libadjoint
FROM ubuntu:bionic

# Set the working directory
WORKDIR /shared

# Copy the current directory contents into the container at /app
#COPY . /shared

# Install open-gl dependencies for vtk -- suboptimal solution ...
RUN apt-get update && \
    apt-get -y install freeglut3-dev freeglut3 libgl1-mesa-glx libsm6 git cmake build-essential wget git-lfs sudo

# Set up user
ARG HOME_DIR=/home/antsuser
RUN echo "Setting up non-sudo user ..." && \
    groupadd --system --gid 1000 antsgroup  && \
    useradd --uid 1000 --system --gid 1000 --create-home --home-dir ${HOME_DIR} --shell /sbin/nologin --comment "ants user" antsuser && \
    chmod 755 /opt

# Create directory for custom software installation
ARG INST_DIR=${HOME_DIR}/software
RUN mkdir ${INST_DIR} && \
    echo "Created ${INST_DIR}"


# Install open-gl dependencies for vtk -- suboptimal solution ...
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6B05F25D762E3157 &&\
    sudo apt-get update && \
    sudo apt-get -y install libgl1-mesa-glx libsm6

# Replace outdated cmake by current version, following this guide:
# https://askubuntu.com/questions/355565/how-do-i-install-the-latest-version-of-cmake-from-the-command-line/865294#865294
#- remove existing cmake and install libncurses-dev
RUN sudo apt-get update && \
    sudo apt -y remove --purge --auto-remove cmake && \
    sudo apt-get -y install libncurses-dev
#- install new cmake from sources
ARG version=3.13
ARG build=0
ARG CMAKE_NAME=cmake-$version.$build
RUN echo "Installing cmake..." && cd ${INST_DIR} && \
    wget https://cmake.org/files/v$version/${CMAKE_NAME}.tar.gz && \
    tar -xzvf ${CMAKE_NAME}.tar.gz && \
    cd ${INST_DIR}/${CMAKE_NAME} && \
    ./bootstrap && \
    make -j4 && \
    sudo make install
ENV PATH=$PATH:/usr/local/bin

# Install ANTs from sources
# https://github.com/ANTsX/ANTs/wiki/Compiling-ANTs-on-Linux-and-Mac-OS
ARG ANTS_FILES=${INST_DIR}/ants_git
ARG ANT_INST_PATH=${INST_DIR}/ants_build
RUN echo "Installing ANTs..." && cd ${INST_DIR} && \
    git clone https://github.com/stnava/ANTs.git ${ANTS_FILES} && \
    mkdir ${ANT_INST_PATH} && \
    cd ${ANT_INST_PATH} && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DSuperBuild_ANTS_USE_GIT_PROTOCOL=OFF -DRUN_LONG_TESTS=OFF ${ANTS_FILES} &&\
    make -j4 && \
    cp ${ANTS_FILES}/Scripts/* ${ANT_INST_PATH}/bin
ENV ANTSPATH=${ANT_INST_PATH}/bin
ENV PATH=${ANTSPATH}:$PATH

# change owner of
RUN chown -R antsuser:antsgroup ${HOME_DIR}/
RUN chown -R antsuser:anstsgroup ${SHARED_FOLDER_DIR}/
RUN chmod -R ug+rwx ${HOME_DIR}
RUN chmod -R ug+rwx ${SHARED_FOLDER_DIR}

## Set the user & working directory
#WORKDIR ${HOME_DIR}
#USER mesher
