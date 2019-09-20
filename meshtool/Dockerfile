# Dockerfile for GlimS based on dolfinadjoint/libadjoint
FROM ubuntu:bionic

# Install open-gl dependencies for vtk -- suboptimal solution ...
RUN apt-get update && \
    apt-get -y install freeglut3-dev freeglut3 libgl1-mesa-glx libsm6 git cmake build-essential wget git-lfs sudo

# Set up user
ARG HOME_DIR=/home/mesher
RUN echo "Setting up non-sudo user ..." && \
    groupadd --system --gid 1000 meshgroup  && \
    useradd --uid 1000 --system --gid 1000 --create-home --home-dir ${HOME_DIR} --shell /sbin/nologin --comment "meshtool user" mesher && \
    chmod 755 /opt

# Create directory for custom software installation
ARG INST_DIR=${HOME_DIR}/software
RUN mkdir ${INST_DIR} && \
    echo "Created ${INST_DIR}"

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

# BOOST
# meshtool does not compile against most recent version of BOOST; we only need boost headers
ARG BOOST_SOURCE_DIR=${INST_DIR}/BOOST_source
ARG BOOST_TAR_FILE=${INST_DIR}/BOOST.tar.bz2
RUN echo "Installing BOOST..." && \
    wget -O ${BOOST_TAR_FILE} https://sourceforge.net/projects/boost/files/boost/1.66.0/boost_1_66_0.tar.bz2/download && \
    mkdir ${BOOST_SOURCE_DIR} && \
    tar -xjf ${BOOST_TAR_FILE} -C ${BOOST_SOURCE_DIR} --strip-components=1


# Install CGAL
RUN sudo apt-get update && \
    sudo apt-get -y install libgmp3-dev libmpfr-dev

ARG CGAL_SOURCE_DIR=${INST_DIR}/CGAL_source
ARG CGAL_BUILD_DIR=${INST_DIR}/CGAL_build
ARG CGAL_INSTALL_DIR=${INST_DIR}/CGAL_install
RUN echo "Installing CGAL..." && \
    git clone https://github.com/CGAL/cgal.git ${CGAL_SOURCE_DIR} && \
    cd ${CGAL_SOURCE_DIR}&& \
    git checkout releases/CGAL-4.8.1 && \
    mkdir ${CGAL_BUILD_DIR} && \
    cd ${CGAL_BUILD_DIR} && \
    cmake -DCMAKE_INSTALL_PREFIX=${CGAL_INSTALL_DIR} -DBUILD_SHARED_LIBS=OFF ${CGAL_SOURCE_DIR} -DBOOST_ROOT=${BOOST_SOURCE_DIR} &&\
    make -j4 && \
    make install

# Install XSD
ARG XSD_TAR_FILE=${INST_DIR}/XSD.tar.bz2
ARG XSD_INSTALL_DIR=${INST_DIR}/XSD_install
RUN echo "Installing XSD..." && \
    wget -O ${XSD_TAR_FILE} https://www.codesynthesis.com/download/xsd/4.0/linux-gnu/x86_64/xsd-4.0.0-x86_64-linux-gnu.tar.bz2 && \
    mkdir ${XSD_INSTALL_DIR} && \
    tar -xjf ${XSD_TAR_FILE} -C ${XSD_INSTALL_DIR} --strip-components=1

# Install MeshTool
ARG MESHTOOL_SOURCE_DIR=${INST_DIR}/MESHTOOL_source
ARG MESHTOOL_BUILD_DIR=${INST_DIR}/MESHTOOL_build
ARG MESHTOOL_INSTALL_DIR=${INST_DIR}/MESHTOOL_install
RUN echo "Installing MeshTool..." && \
    git clone https://c4science.ch/diffusion/9312/meshtool.git ${MESHTOOL_SOURCE_DIR} && \
    cd ${MESHTOOL_SOURCE_DIR} && \
    git checkout master && \
    git lfs install && \
    git lfs pull && \
    mkdir ${MESHTOOL_BUILD_DIR} && \
    cd ${MESHTOOL_BUILD_DIR} && \
    cmake -DCMAKE_INSTALL_PREFIX=${MESHTOOL_INSTALL_DIR} -DCGAL_DIR=${CGAL_BUILD_DIR} -DVTK_DIR=${VTK_BUILD_DIR} -DXERCESC_ROOT_DIR=${XERCES_INSTALL_DIR} -DXSD_DIR=${XSD_INSTALL_DIR}/libxsd ${MESHTOOL_SOURCE_DIR} &&\
    make -j4 && \
    make install

# environment variables
ARG MESHTOOL_BIN_DIR=${MESHTOOL_SOURCE_DIR}/bin
ENV PATH="${MESHTOOL_BIN_DIR}:${PATH}"

ARG SCRIPTS_FOLDER=${MESHTOOL_SOURCE_DIR}/scripts
ENV PATH="${SCRIPTS_FOLDER}:${PATH}"

# shared folder
ARG SHARED_FOLDER_DIR=/shared
RUN echo "Setting up shared folder..." && \
    mkdir ${SHARED_FOLDER_DIR}

# change owner of
RUN chown -R mesher:meshgroup ${HOME_DIR}/
RUN chown -R mesher:meshgroup ${SHARED_FOLDER_DIR}/
RUN chmod -R ug+rwx ${HOME_DIR}
RUN chmod -R ug+rwx ${SHARED_FOLDER_DIR}

# Set the user & working directory
WORKDIR ${HOME_DIR}
USER mesher