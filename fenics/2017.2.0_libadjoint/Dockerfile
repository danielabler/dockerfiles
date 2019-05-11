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
