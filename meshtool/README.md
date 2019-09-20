# Images for MeshTool

These images provides an installation of [MeshTool](https://c4science.ch/diffusion/9312/meshtool.git), 
a tool for generating tetrahedral meshes from labeled images.

## Docker Image 

See the [docker](https://www.docker.com/) pages for setup. 

### Use Built Image
A built version of this image is available on [docker hub](https://hub.docker.com/) at
https://cloud.docker.com/u/danabl/repository/docker/danabl/meshtool .

You can download this image by:

```
docker pull danabl/meshtool:latest
```  

### Building Image
Enter the directory where this readme file is located.
Build the docker image with name *meshtool* by

```
    docker build -t meshtool .
```

### Creating Container

Create container *meshtool_container* from *meshtool*, with working directory
(`-w`) */home/mesher/project* in the container and mapping (`-v`) local
*/path/on/host* to */home/mesher/project* as user with gid=1000.

```
docker run --name meshtool_container -w /shared -v /path/on/host/:/shared -dit -u 1000 danabl/meshtool
```
Option `-d` detaches the process.

In order to make the shared folder */path/on/host/* and */home/mesher/project* writeable for the host user and from 
the docker container, it is important to:
- Make sure that the folder */path/on/host/* has been created by the local user on the host. 
  If the folder does not exist before calling above command, it will be created by docker and be owned by *root*.
- The container has been created with a docker user called *mesher* with gid=1000.
  By default, i.e. w/o specifying the `-u` flag, the container will be started as this user.
  If your user on host has the same `gid`, you can start the container without the `-u` flag.
  
  Otherwise, run the container with the `gid` of your local user. 
  ```
  docker run --name meshtool_container -w /shared -v /path/on/host/:/shared -dit -u $(id -u):$(id -g) danabl/meshtool
  ```
  This will prompt a message 'I have no name!' in the terminal, but should work.
  
The container should now be running, which you can check by
```shell script
docker ps
```

You can re-attach the docker process by calling:
```shell script
docker attach meshtool_container
```
or 
```
docker exec -ti meshtool_container /bin/bash -l
```

To start and stop a container:
```
docker start container_name
docker stop container_name
```

### Running MeshTool via Docker

Create a docker container and enter as explained above.

The `MeshTool` command has been added to the `PATH` variable in the docker image, you will be able to 
run `MeshTool` from any arbitrary location in the docker file system, including any shared folder.

```
./MeshTool -c \path\to\config_file.xml -m 'image'
```


## Singularity Image 

See the [singularity](https://sylabs.io/docs/) pages for setup. 

### Use Built Image

A built version of this image is available on [singularity hub](https://singularity-hub.org/) at:
XXX

You can download this image by:

```
docker pull danabl/meshtool:latest
```  

### Building Image
Enter the directory where this readme file is located.
Build the singularity image with name *meshtool.img* by

```
    sudo singularity build meshtool.img Singularity.meshtool
```

### Running MeshTool from Singularity Image

You can enter a shell in the singularity container by

```
singularity shell -e /path/to/meshtool.img
```

After executing this command you will have access to and can navigate through the entire host file system.
You will also have access to the home folder of the user account that was used to set up the singularity system and
to install MeshTool, e.g.

```shell script
ls /home/mesher/software
```

Since the `MeshTool` command has been added to the `PATH` variable in the singularity image, you will be able to 
run `MeshTool` from any arbitrary location in your file system.

```
./MeshTool -c \path\to\config_file.xml -m 'image'
```

Leave the singularity shell again with `exit`.