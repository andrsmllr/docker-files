# docker-files

## Overview

Dockerfiles for various EDA tools for FPGA and ASIC design, simulation and verification.

## How to use

There are different ways to get going with these docker images:
1. pull an image from [dockerhub](https://hub.docker.com/search?q=andrsmllr&type=image)
2. use a Dockerfile to build an image locally
3. use a Dockerfile as reference to create your own docker image

The choice is yours.

Inside an image the applications are installed under `/opt/<application-name>` and the executables are available on $PATH. The default command of the docker image is to launch the application when starting the container.

To report a bug, request a feature or suggest an improvement, please open an issue.

## Dockerfiles

Each Dockerfile contains two build targets.
The first build target named <image-name>-dev is for building and developing the application.
The second build target named <image-name>-app contains only the build result (copied over from the -dev image) and runtime dependencies.
This way the image size is kept small, while keeping the build process transparent.

To run an image call `docker run andrsmllr/<image-name>`.
  
Most images need to access some files from a work directory on your disk to function properly. E.g. `docker run --rm -t -v $(pwd):/work -w /work andrsmllr/gtkwave`
