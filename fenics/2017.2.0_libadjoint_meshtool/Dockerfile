# Dockerfile for GlimS based on dolfinadjoint/libadjoint
FROM quay.io/dolfinadjoint/dolfin-adjoint:latest

# Set the working directory
WORKDIR /shared

# Copy the current directory contents into the container at /app
COPY . /shared

# Install open-gl dependencies for vtk -- suboptimal solution ...
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6B05F25D762E3157 &&\
    sudo apt-get update && \
    sudo apt-get -y install libgl1-mesa-glx libsm6

# Install any needed python packages specified in requirements.txt
#RUN pip install --trusted-host pypi.python.org -r requirements.txt
RUN pip3 install --upgrade pip &&\
    pip3 install --trusted-host pypi.python.org -r requirements.txt
# Set Environment variables
ENV MATPLOTLIBRC=/opt/project/matplotlibrc

# For TK support add
#RUN sudo apt-get update
#RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python-tk

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


#-- Setup MESHING-TOOL

# Install VTK
ARG VTK_SOURCE_DIR=${INST_DIR}/VTK_source
ARG VTK_BUILD_DIR=${INST_DIR}/VTK_build
ARG VTK_INSTALL_DIR=${INST_DIR}/VTK_install
RUN echo "Installing VTK..." && \
    git clone https://github.com/Kitware/VTK ${VTK_SOURCE_DIR} && \
    cd ${VTK_SOURCE_DIR} && \
    git checkout v8.1.0 && \
    mkdir ${VTK_BUILD_DIR} && \
    cd ${VTK_BUILD_DIR} && \
    cmake -DCMAKE_INSTALL_PREFIX=${VTK_INSTALL_DIR} -DBUILD_EXAMPLES:BOOL=OFF -DBUILD_TESTING:BOOL=OFF ${VTK_SOURCE_DIR} &&\
    make -j4 && \
    make install

# Install XERCESC
ARG XERCES_SOURCE_DIR=${INST_DIR}/XERCES_source
ARG XERCES_BUILD_DIR=${INST_DIR}/XERCES_build
ARG XERCES_INSTALL_DIR=${INST_DIR}/XERCES_install
RUN echo "Installing XERCESC..." && \
    git clone https://github.com/apache/xerces-c ${XERCES_SOURCE_DIR} && \
    cd ${XERCES_SOURCE_DIR}&& \
    git checkout Xerces-C_3_2_0 && \
    mkdir ${XERCES_BUILD_DIR} && \
    cd ${XERCES_BUILD_DIR} && \
    cmake -DCMAKE_INSTALL_PREFIX=${XERCES_INSTALL_DIR} ${XERCES_SOURCE_DIR} &&\
    make -j4 && \
    make install

# Install CGAL
ARG CGAL_SOURCE_DIR=${INST_DIR}/CGAL_source
ARG CGAL_BUILD_DIR=${INST_DIR}/CGAL_build
ARG CGAL_INSTALL_DIR=${INST_DIR}/CGAL_install
RUN echo "Installing CGAL..." && \
    git clone https://github.com/CGAL/cgal.git ${CGAL_SOURCE_DIR} && \
    cd ${CGAL_SOURCE_DIR}&& \
    git checkout releases/CGAL-4.8.1 && \
    mkdir ${CGAL_BUILD_DIR} && \
    cd ${CGAL_BUILD_DIR} && \
    cmake -DCMAKE_INSTALL_PREFIX=${CGAL_INSTALL_DIR} -DBUILD_SHARED_LIBS=OFF ${CGAL_SOURCE_DIR} &&\
    make -j4 && \
    make install

# Install XSD
ARG XSD_TAR_FILE=${INST_DIR}/XSD.tar.bz2
ARG XSD_INSTALL_DIR=${INST_DIR}/xsd-4.0.0-x86_64-linux-gnu
RUN echo "Installing XSD..." && \
    wget -O ${XSD_TAR_FILE} https://www.codesynthesis.com/download/xsd/4.0/linux-gnu/x86_64/xsd-4.0.0-x86_64-linux-gnu.tar.bz2 && \
    tar -xjf ${XSD_TAR_FILE}

# Install MeshTool
ARG MESHTOOL_SOURCE_DIR=${INST_DIR}/MESHTOOL_source
ARG MESHTOOL_BUILD_DIR=${INST_DIR}/MESHTOOL_build
ARG MESHTOOL_INSTALL_DIR=${INST_DIR}/MESHTOOL_install
RUN echo "Installing MeshTool..." && \
    git clone https://github.com/danielabler/meshtool.git ${MESHTOOL_SOURCE_DIR} && \
    cd ${MESHTOOL_SOURCE_DIR} && \
    git checkout master && \
    mkdir ${MESHTOOL_BUILD_DIR} && \
    cd ${MESHTOOL_BUILD_DIR} && \
    cmake -DCMAKE_INSTALL_PREFIX=${MESHTOOL_INSTALL_DIR} -DCGAL_DIR=${CGAL_BUILD_DIR} -DVTK_DIR=${VTK_BUILD_DIR} -DXERCESC_ROOT_DIR=${XERCES_INSTALL_DIR} -DXSD_DIR=${XSD_INSTALL_DIR}/libxsd ${MESHTOOL_SOURCE_DIR} &&\
    make -j4 && \
    make install
