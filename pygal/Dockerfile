# Dockerfile based on ubuntu
FROM ubuntu:bionic

# Install open-gl dependencies for vtk -- suboptimal solution ...

RUN apt-get update && \
    apt-get -y install git cmake build-essential gcc wget git-lfs libcgal-dev libeigen3-dev software-properties-common

RUN add-apt-repository ppa:ubuntu-toolchain-r/test &&\
	apt-get update && \
	apt-get -y install gcc-7 g++-7 && \
	echo gcc -v
# 	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 90 --slave /usr/bin/g++ g++ /usr/bin/g++-5 &&\
# 	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 80 --slave /usr/bin/g++ g++ /usr/bin/g++-6 &&\
#    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7 &&\
#    update-alternatives --set gcc7 /usr/bin/gcc-7

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

RUN echo "Installing MINICONDA ..." && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ${INST_DIR}/miniconda.sh && \
    bash ${INST_DIR}/miniconda.sh -b -p ${INST_DIR}/miniconda && \
    rm ${INST_DIR}/miniconda.sh
    
ENV PATH=${INST_DIR}/miniconda/bin:${PATH}

RUN echo "Setup up python env ..." && \
    export PATH=${INST_DIR}/miniconda/bin:${PATH} &&\
    conda create --name pygal python=3 numpy matplotlib
	
ENV PATH="${INST_DIR}/miniconda/envs/pygal/bin:${PATH}"

# RUN which python &&\
#  	pip install -U pygalmesh &&\
# 	pip install meshio
# 


# PROBLEM WITH PYCALMESH INSTALLATION
