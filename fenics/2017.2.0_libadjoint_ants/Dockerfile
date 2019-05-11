# Dockerfile for GlimS based on dolfinadjoint/libadjoint
FROM danabl/glimslib:2017.2

# Set the working directory
WORKDIR /shared

# Create directory for custom software installation
ARG INST_DIR=/home/fenics/software
RUN mkdir ${INST_DIR} && echo "Created ${INST_DIR}"
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
ENV ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=2
ENV ANTSPATH=${ANT_INST_PATH}/bin
ENV PATH=${ANTSPATH}:$PATH
ENV PYTHONPATH=/opt/project:$PYTHONPATH
