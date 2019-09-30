# Abaqus on Docker / Singularity

This file provides instructions for creation docker / singularity images with Abaqus.

## Docker Image 

See the [docker](https://www.docker.com/) pages for setting up Docker on your system. 

Abaqus installation files are not publicly available, we create the Docker image in three steps: 
(1) setting up a suitable linux installation via the *Dockerfile*, (2) installing Abaqus from a Docker container
and, (3) making this container persistent.

Most recent versions of Docker support authentication mechanisms in Dockerfiles, as discussed [here](https://docs.docker.com/develop/develop-images/build_enhancements/),
so that those steps can me merged in the future.
 
### Build Docker Image

The Dockerfile in this folder provides you with a recent Ubuntu system, including abaqus requirements and a dedicated Abaqus user.

```shell script
    docker build -t meshtool linux_for_abaqus .
```

You create and access a container from this image by:

```shell script
    docker run --name linux_abq -w /shared -v /PATH/TO/SHARED/DIR/ON/HOST/:/shared -dit linux_for_abaqus
    docker attach abq
```

### Install Abaqus

To install Abaqus, enter the docker container as explained above.
Make the file `abq_install.sh` available by copying to the shared folder and execute by

```shell script
    sh abq_install.sh
```

After execution, a folder */home/abquser/software/DassaultSystemes* should exist.
Open another terminal to identify the id of this container by calling `docker ps`.
Copy this id, leave the container (`exit`) and stop it (`docker stop abq`).
 
### Commit Changes to Container

To make the installation permanent, we will now [create an image from this container](https://docs.docker.com/engine/reference/commandline/commit/):

```shell script
    docker commit -m "installed abaqus" <container-id> abaqus_img
```

### Use abaqus image

You can now run this image.
With these settings, graphics forwarding to the host works on linux:

```shell script
  docker run --name abq -w /shared -v ~/PATH/TO/SHARED/DIR/ON/HOST/:/shared -dit --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" abaqus_img

```

## Singularity Image

To create a singularity image from a local docker image, we need to start a docker registry:

```
    docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

and push the docker image to this registry:

```shell script
    docker tag abaqus_img localhost:5000/abaqus_img
    docker push localhost:5000/abaqus_img
```

Then, build an image via:

```shell script
    sudo SINGULARITY_NOHTTPS=1 singularity build abaqus.simg docker://localhost:5000/abaqus_img
```

This image can be accessed using:

```shell script
    singularity shell -e abaqus.simg
```

