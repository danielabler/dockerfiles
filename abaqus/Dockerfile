# Dockerfile for GlimS based on dolfinadjoint/libadjoint
FROM ubuntu:18.04


RUN apt-get update && \
    apt-get install -y csh tcsh ksh gcc g++ gfortran libstdc++5 build-essential make libjpeg62 libmotif-dev ssh lsb-core sudo

 
# Set up abaqus user
ARG HOME_DIR=/home/abquser
RUN echo "Setting up abquser user ..." && \
    groupadd --system --gid 1000 abqgroup  && \
    useradd --uid 1000 --system --gid 1000 --create-home --home-dir ${HOME_DIR} --shell /sbin/nologin --comment "abquser user" abquser && \
    chmod 755 /opt && \
    adduser abquser sudo

# Create directory for custom software installation
ARG INST_DIR=${HOME_DIR}/software
RUN mkdir ${INST_DIR} && \
    echo "Created ${INST_DIR}"

#shared folder
ARG SHARED_FOLDER_DIR=/shared
RUN echo "Setting up shared folder..." && \
    mkdir ${SHARED_FOLDER_DIR}
 
#change owner of
RUN chown -R abquser:abqgroup ${HOME_DIR}/
RUN chown -R abquser:abqgroup ${SHARED_FOLDER_DIR}/
RUN chmod -R ug+rwx ${HOME_DIR}
RUN chmod -R ug+rwx ${SHARED_FOLDER_DIR}
 
#Set the user & working directory
WORKDIR ${HOME_DIR}
USER abquser
