# Dockerfile for GlimS based on dolfinadjoint/libadjoint
FROM danabl/meshtool:dependencies

# Install MeshTool as user mesher
ARG HOME_DIR=/home/mesher
ARG INST_DIR=${HOME_DIR}/software

# Set the user & working directory
WORKDIR ${HOME_DIR}
USER mesher

# Install MeshTool
ARG VTK_BUILD_DIR=${INST_DIR}/VTK_build
ARG XERCES_INSTALL_DIR=${INST_DIR}/XERCES_install
ARG BOOST_SOURCE_DIR=${INST_DIR}/BOOST_source
ARG XSD_INSTALL_DIR=${INST_DIR}/XSD_install
ARG CGAL_BUILD_DIR=${INST_DIR}/CGAL_build
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

